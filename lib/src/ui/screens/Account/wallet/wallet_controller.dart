import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class WalletTransaction {
  final IconData icon;
  final String title;
  final String amount;
  final bool isCredit;

  const WalletTransaction({
    required this.icon,
    required this.title,
    required this.amount,
    required this.isCredit,
  });
}

/// A pre-loaded gift card (`nisba_cards` in `/wallets/users/cards`).
class NisbaCardModel {
  final int id;
  final String name;
  final double price;

  const NisbaCardModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory NisbaCardModel.fromMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return NisbaCardModel(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '') ?? 0,
    );
  }
}

/// A saved payment card (`visas` in `/wallets/users/cards`).
class UserVisaModel {
  final int id;
  final String? number;
  final String? lastFour;
  final bool isDefault;
  final bool isSkipCash;
  final bool isUsable;

  const UserVisaModel({
    required this.id,
    this.number,
    this.lastFour,
    required this.isDefault,
    required this.isSkipCash,
    required this.isUsable,
  });

  String get displayNumber => number ?? (lastFour != null ? '**** $lastFour' : '****');

  factory UserVisaModel.fromMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return UserVisaModel(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      number: map['number']?.toString(),
      lastFour: map['last_four']?.toString(),
      isDefault: map['is_default'] == true,
      isSkipCash: map['is_skipcash'] == true,
      isUsable: map['is_usable'] != false,
    );
  }
}

class WalletController extends GetxController {
  final userName = ''.obs;
  final phoneNumber = ''.obs;
  final balance = 0.00.obs;
  final totalPayments = 0.00.obs;
  final totalTopUps = 0.00.obs;

  final transactions = <WalletTransaction>[].obs;

  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  final Rx<ApiResponse<dynamic>> walletsResponse =
      ApiResponse<dynamic>.init().obs;

  // ── Cards (`/wallets/users/cards`) ──
  final nisbaCards = <NisbaCardModel>[].obs;
  final visas = <UserVisaModel>[].obs;
  final isCardsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWallets();
  }

  /// Fetches gift cards + saved payment cards for the "بطاقاتي" screen.
  Future<void> fetchCards() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isCardsLoading.value = true;
    try {
      final res = await repository.walletCards();
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        final cards = data['nisba_cards'] as List? ?? [];
        nisbaCards.assignAll(cards.whereType<Map>().map(NisbaCardModel.fromMap));
        final visaList = data['visas'] as List? ?? [];
        visas.assignAll(visaList.whereType<Map>().map(UserVisaModel.fromMap));
      }
    } on DioException catch (error) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(error));
    } catch (e) {
      log('fetchCards: $e');
    } finally {
      isCardsLoading.value = false;
    }
  }

  void openWalletCards() {
    Get.toNamed(AppRoutesNames.walletCards);
    fetchCards();
  }

  Future<void> fetchWallets() async {
    walletsResponse.value = ApiResponse<dynamic>.loading('');
    if (!await connectionChecker.hasConnection) {
      walletsResponse.value =
          ApiResponse<dynamic>.error('check_connection'.tr);
      return;
    }
    try {
      final res = await repository.getWallets();
      final data = ApiResult.ensureSuccess(res);
      walletsResponse.value = ApiResponse<dynamic>.completed(res);
      if (data is Map) {
        final user = data['user'];
        if (user is Map) {
          userName.value = user['name']?.toString() ?? userName.value;
          phoneNumber.value = [
            user['key']?.toString() ?? '',
            user['phone']?.toString() ?? '',
          ].where((e) => e.isNotEmpty).join(' ');
          final walletBal = user['wallet'];
          if (walletBal != null) {
            balance.value = double.tryParse(walletBal.toString()) ?? 0;
          }
        }
        final list = data['wallet'] as List? ?? [];
        transactions.assignAll(
          list.whereType<Map>().map(_mapTx).toList(),
        );
        _recomputeTotals(list);
      }
    } on DioException catch (error) {
      log(error.response?.data?['message']?.toString() ?? error.toString());
      walletsResponse.value = ApiResponse<dynamic>.error(
        DioErrorUtil.handleError(error),
      );
      AppSnackbar.showError(message: walletsResponse.value.message);
    } on ApiException catch (e) {
      walletsResponse.value = ApiResponse<dynamic>.error(e.message);
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      walletsResponse.value = ApiResponse<dynamic>.error(e.toString());
    }
  }

  WalletTransaction _mapTx(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final direction = map['direction'];
    final type = map['type'];
    final dirValue = direction is Map
        ? direction['value']?.toString() ?? ''
        : direction?.toString() ?? '';
    final typeDesc = type is Map
        ? type['desc']?.toString() ?? 'معاملة'
        : type?.toString() ?? 'معاملة';
    final isCredit = dirValue == 'deposit';
    final amount = map['amount']?.toString() ?? '0';
    return WalletTransaction(
      icon: isCredit ? Iconsax.wallet_add : Iconsax.card_send,
      title: typeDesc,
      amount: '${isCredit ? '+' : '-'} $amount QAR',
      isCredit: isCredit,
    );
  }

  void _recomputeTotals(List list) {
    double topUps = 0;
    double payments = 0;
    for (final raw in list.whereType<Map>()) {
      final direction = raw['direction'];
      final dirValue = direction is Map
          ? direction['value']?.toString() ?? ''
          : direction?.toString() ?? '';
      final amt = double.tryParse(raw['amount']?.toString() ?? '') ?? 0;
      if (dirValue == 'deposit') {
        topUps += amt;
      } else {
        payments += amt;
      }
    }
    totalTopUps.value = topUps;
    totalPayments.value = payments;
  }

  void showBalance() {
    AppSnackbar.showInfo(
      message: 'الرصيد الحالي: ${balance.value.toStringAsFixed(2)} QAR',
    );
  }

  void topUpWallet() {
    Get.toNamed(AppRoutesNames.rechargeWallet);
  }

  void sendGift() {
    Get.toNamed(AppRoutesNames.giftCredit);
  }

  void payWithQR() {
    Get.toNamed(AppRoutesNames.dashboard);
  }
}
