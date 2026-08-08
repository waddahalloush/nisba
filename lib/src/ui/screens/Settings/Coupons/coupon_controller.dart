import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class CouponModel {
  final int? id;
  final String title;
  final String description;
  final String discount;
  final String maxSaving;
  final String minOrder;
  final String expiry;
  final String status; // valid, used, expired
  final String code;

  const CouponModel({
    this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.maxSaving,
    required this.minOrder,
    required this.expiry,
    required this.status,
    this.code = '',
  });

  factory CouponModel.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final statusRaw = map['status'];
    final statusValue = statusRaw is Map
        ? statusRaw['value']?.toString() ?? ''
        : statusRaw?.toString() ?? '';
    final discountType = map['discount_type'];
    final discountTypeDesc = discountType is Map
        ? discountType['desc']?.toString() ?? ''
        : '';
    final discountVal = map['discount']?.toString() ?? '';
    String uiStatus = 'valid';
    switch (statusValue) {
      case 'used':
        uiStatus = 'used';
        break;
      case 'finished':
      case 'un_active':
      case 'expired':
        uiStatus = 'expired';
        break;
      default:
        uiStatus = 'valid';
    }
    return CouponModel(
      id: int.tryParse(map['id']?.toString() ?? ''),
      title: map['name']?.toString() ?? map['title']?.toString() ?? 'auto_key_585'.tr,
      description: map['code']?.toString() ?? '',
      discount: discountTypeDesc.isNotEmpty
          ? '$discountTypeDesc $discountVal'
          : 'auto_key_586'.tr,
      maxSaving: '',
      minOrder: '',
      expiry: map['end_at']?.toString() ?? '',
      status: uiStatus,
      code: map['code']?.toString() ?? '',
    );
  }
}

class CouponController extends GetxController {
  final selectedTab = 0.obs;
  final codeController = TextEditingController();
  final coupons = <CouponModel>[].obs;
  final isLoading = false.obs;
  final isChecking = false.obs;

  final tabs = ['auto_key_587'.tr, 'auto_key_588'.tr, 'auto_key_589'.tr];

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  List<CouponModel> get filteredCoupons {
    if (selectedTab.value == 0) {
      return coupons.where((c) => c.status == 'valid').toList();
    }
    if (selectedTab.value == 1) {
      return coupons.where((c) => c.status == 'used').toList();
    }
    return coupons.where((c) => c.status == 'expired').toList();
  }

  @override
  void onInit() {
    super.onInit();
    fetchCoupons();
  }

  Future<void> fetchCoupons() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getCoupons();
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map
          ? (data['coupons'] as List? ?? [])
          : (data is List ? data : []);
      coupons.assignAll(
        list.whereType<Map>().map(CouponModel.fromApiMap).toList(),
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectTab(int index) => selectedTab.value = index;

  void useCoupon(CouponModel coupon) {
    if (coupon.code.isNotEmpty) {
      codeController.text = coupon.code;
    }
    AppSnackbar.showSuccess(message: 'auto_key_590'.tr);
  }

  Future<void> applyCode() async {
    final code = codeController.text.trim();
    if (code.isEmpty) {
      AppSnackbar.showError(message: 'auto_key_137'.tr);
      return;
    }
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isChecking.value = true;
    try {
      final res = await repository.checkCoupon(data: {'code': code});
      final data = ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'auto_key_591'.tr,
      );
      if (data is Map) {
        final name = data['name']?.toString();
        final discount = data['discount']?.toString() ?? '';
        final typeRaw = data['discount_type'];
        final type = typeRaw is Map
            ? typeRaw['desc']?.toString() ?? typeRaw['value']?.toString() ?? ''
            : typeRaw?.toString() ?? '';
        if (name != null && name.isNotEmpty) {
          AppSnackbar.showInfo(
            message: 'auto_key_592'.tr,
          );
        }
      }
      codeController.clear();
      await fetchCoupons();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isChecking.value = false;
    }
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
