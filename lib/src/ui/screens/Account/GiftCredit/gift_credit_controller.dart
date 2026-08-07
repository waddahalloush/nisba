import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class GiftCreditController extends GetxController {
  final selectedTab = 0.obs; // 0 = QR, 1 = phone
  final phoneController = TextEditingController();
  final countryKeyController = TextEditingController(text: '+974');
  final qrController = TextEditingController();
  final noteController = TextEditingController();
  RxString phoneNumber = ''.obs;
  final selectedAmount = 0.0.obs;
  final isSubmitting = false.obs;

  final presetAmounts = <double>[10, 20, 30, 50, 100, 200, 500, 1000];
  final maxNoteLength = 120;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  final recipientName = ''.obs;
  final isCheckingRecipient = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['qr'] != null) {
      selectedTab.value = 0;
      qrController.text = args['qr'].toString();
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
    recipientName.value = '';
  }

  void selectAmount(double amount) => selectedAmount.value = amount;

  void clearAmount() => selectedAmount.value = 0;

  /// Builds the recipient identity query for `getInfoUser`, based on the
  /// currently selected tab (QR vs phone).
  Map<String, dynamic>? _recipientQuery() {
    if (selectedTab.value == 0) {
      final qr = qrController.text.trim();
      if (qr.isEmpty) return null;
      return {'gift_user_qr': qr};
    }
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return null;
    return {
      'gift_user_phone': phone,
      'gift_user_key': countryKeyController.text.trim(),
    };
  }

  /// Verifies the recipient exists via `getInfoUser` and shows their name.
  /// Returns `true` when the recipient was found successfully.
  Future<bool> _verifyRecipient() async {
    final query = _recipientQuery();
    if (query == null) {
      Get.snackbar(
        'خطأ',
        selectedTab.value == 0 ? 'يرجى مسح أو إدخال رمز QR' : 'يرجى إدخال رقم الهاتف',
      );
      return false;
    }

    isCheckingRecipient.value = true;
    try {
      final res = await repository.getInfoUser(query: query);
      final data = ApiResult.ensureSuccess(res);
      final user = data is Map ? (data['user'] ?? data) : null;
      final name = user is Map ? user['name']?.toString() ?? '' : '';
      recipientName.value = name;
      if (name.isEmpty) {
        AppSnackbar.showError(message: 'تعذر العثور على المستخدم');
        return false;
      }
      return true;
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
      return false;
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
      return false;
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
      return false;
    } finally {
      isCheckingRecipient.value = false;
    }
  }

  Future<void> proceed() async {
    if (selectedAmount.value <= 0) {
      Get.snackbar('خطأ', 'يرجى اختيار المبلغ');
      return;
    }

    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    final verified = await _verifyRecipient();
    if (!verified) return;

    final body = <String, dynamic>{
      'amount': selectedAmount.value,
      if (noteController.text.trim().isNotEmpty)
        'note': noteController.text.trim(),
      ..._recipientQuery()!,
    };

    isSubmitting.value = true;
    try {
      final res = await repository.giftWallet(data: body);
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'تم الإهداء بنجاح',
      );
      Get.back();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    countryKeyController.dispose();
    qrController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
