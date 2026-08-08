import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

import 'widgets/payment_option.dart';

class VisaCardModel {
  final int id;
  final String displayNumber;
  final bool isDefault;
  final bool isUsable;

  const VisaCardModel({
    required this.id,
    required this.displayNumber,
    required this.isDefault,
    this.isUsable = true,
  });

  factory VisaCardModel.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final lastFour = map['last_four']?.toString();
    final number = map['number']?.toString();
    final display = lastFour != null && lastFour.isNotEmpty
        ? '•••• $lastFour'
        : (number ?? 'card'.tr);
    return VisaCardModel(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      displayNumber: display,
      isDefault: map['is_default'] == true || map['is_default'] == 1,
      isUsable: map['is_usable'] != false,
    );
  }
}

class PaymentSettingController extends GetxController {
  static final String _keyDefault = 'auto_key_45'.tr;
  static final String _keyQr = 'auto_key_46'.tr;
  static final String _keyNoPhone = 'auto_key_47'.tr;

  final dailyLimit = 5000.0.obs;
  final faceIdEnabled = true.obs;
  final fingerprintEnabled = false.obs;
  final selectedPaymentMethod = 'wallet'.tr.obs;
  final visas = <VisaCardModel>[].obs;
  final isLoading = false.obs;

  final paymentMethods = <String, String>{
    _keyDefault: 'auto_key_48'.tr,
    _keyQr: 'auto_key_48'.tr,
    _keyNoPhone: 'auto_key_48'.tr,
  }.obs;

  String _editingKey = _keyDefault;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchPaymentSettings();
    fetchVisas();
  }

  Future<void> fetchPaymentSettings() async {
    if (!await connectionChecker.hasConnection) return;
    try {
      final res = await repository.getPaymentSettings();
      final data = ApiResult.ensureSuccess(res);
      final user = data is Map ? data['user'] : null;
      if (user is! Map) return;
      final map = Map<String, dynamic>.from(user);

      final limit = map['maximum_limit_for_daily_purchases'];
      if (limit != null) {
        dailyLimit.value =
            double.tryParse(limit.toString())?.clamp(0, 10000) ??
            dailyLimit.value;
      }

      paymentMethods[_keyDefault] =
          _enumDesc(map['default_payment_method']) ??
          paymentMethods[_keyDefault]!;
      paymentMethods[_keyQr] =
          _enumDesc(map['default_qr_payment_method']) ??
          _enumDesc(map['default_qr']) ??
          paymentMethods[_keyQr]!;
      paymentMethods[_keyNoPhone] =
          _enumDesc(map['default_without_phone_payment_method']) ??
          _enumDesc(map['default_without_phone']) ??
          paymentMethods[_keyNoPhone]!;
      paymentMethods.refresh();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      log(e.toString());
    }
  }

  String? _enumDesc(dynamic raw) {
    if (raw is Map) {
      final desc = raw['desc']?.toString();
      if (desc != null && desc.isNotEmpty) return desc;
      final value = raw['value']?.toString();
      if (value != null) return _apiMethodToLabel(value);
    }
    if (raw != null) return _apiMethodToLabel(raw.toString());
    return null;
  }

  Future<void> fetchVisas() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getVisas();
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map ? (data['visas'] as List? ?? []) : [];
      visas.assignAll(
        list.whereType<Map>().map(VisaCardModel.fromApiMap).toList(),
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

  Future<void> setDefaultVisa(int id) async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.setDefaultVisa(id);
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message:
            (res is Map ? res['message'] : null)?.toString() ??
            'auto_key_49'.tr,
      );
      await fetchVisas();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  Future<void> deleteVisa(int id) async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.deleteVisa(id);
      ApiResult.ensureSuccess(res);
      visas.removeWhere((v) => v.id == id);
      AppSnackbar.showSuccess(
        message:
            (res is Map ? res['message'] : null)?.toString() ??
            'auto_key_50'.tr,
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  void changePaymentMethod(String key) => showPaymentMethodSheet(key);

  void showPaymentMethodSheet([String? forKey]) {
    _editingKey = forKey ?? _keyDefault;
    selectedPaymentMethod.value = _normalizeLabel(
      paymentMethods[_editingKey] ?? 'wallet'.tr,
    );

    final theme = Theme.of(Get.context!);
    final cs = theme.colorScheme;

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          20.w,
          20.h,
          20.w,
          MediaQuery.of(Get.context!).padding.bottom + 16.h,
        ),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _editingKey,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18.sp,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Obx(
              () => Column(
                children: [
                  PaymentOption(
                    icon: Iconsax.wallet_2,
                    label: 'wallet'.tr,
                    isSelected: selectedPaymentMethod.value == 'wallet'.tr,
                    onTap: () => selectedPaymentMethod.value = 'wallet'.tr,
                  ),
                  Divider(
                    height: 1.h,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                  PaymentOption(
                    icon: Iconsax.cup,
                    label: 'auto_key_51'.tr,
                    subtitle: 'auto_key_52'.tr,
                    isSelected: selectedPaymentMethod.value == 'auto_key_51'.tr,
                    onTap: () => selectedPaymentMethod.value = 'auto_key_51'.tr,
                  ),
                  Divider(
                    height: 1.h,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                  PaymentOption(
                    icon: Iconsax.moneys,
                    label: 'cash'.tr,
                    isSelected: selectedPaymentMethod.value == 'cash'.tr,
                    onTap: () => selectedPaymentMethod.value = 'cash'.tr,
                  ),
                  Divider(
                    height: 1.h,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                  PaymentOption(
                    icon: Iconsax.card,
                    label: 'card'.tr,
                    isSelected: selectedPaymentMethod.value == 'card'.tr,
                    onTap: () => selectedPaymentMethod.value = 'card'.tr,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () => _applyPaymentMethod(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: Text(
                  'apply'.tr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> _applyPaymentMethod() async {
    final label = selectedPaymentMethod.value;
    paymentMethods[_editingKey] = label;
    paymentMethods.refresh();
    Get.back();

    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.setDefaultPaymentMethod(
        data: {
          'type': _settingKeyToType(_editingKey),
          'payment_method': _labelToApiMethod(label),
        },
      );
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'auto_key_53'.tr,
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  void setDailyLimit(double value) => dailyLimit.value = value;

  Future<void> saveDailyLimit([double? value]) async {
    final amount = value ?? dailyLimit.value;
    dailyLimit.value = amount;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.setDailyPurchaseLimit(
        data: {'amount': amount},
      );
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'auto_key_54'.tr,
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  void toggleFaceId(bool v) => faceIdEnabled.value = v;
  void toggleFingerprint(bool v) => fingerprintEnabled.value = v;

  String _settingKeyToType(String uiKey) {
    if (uiKey == _keyQr) return 'default_qr_payment_method';
    if (uiKey == _keyNoPhone) return 'default_without_phone_payment_method';
    return 'default_payment_method';
  }

  String _labelToApiMethod(String label) {
    final n = _normalizeLabel(label);
    if (n == 'auto_key_51'.tr) return 'point';
    if (n == 'cash'.tr) return 'cash';
    if (n == 'card'.tr) return 'card';
    return 'wallet';
  }

  String _apiMethodToLabel(String value) {
    switch (value.toLowerCase()) {
      case 'point':
        return 'auto_key_51'.tr;
      case 'cash':
        return 'cash'.tr;
      case 'card':
        return 'card'.tr;
      case 'wallet':
        return 'wallet'.tr;
      default:
        return value;
    }
  }

  String _normalizeLabel(String label) {
    if (label.contains('auto_key_55'.tr) || label.toLowerCase() == 'wallet') {
      return 'wallet'.tr;
    }
    if (label.contains('points'.tr) || label.toLowerCase() == 'point') {
      return 'auto_key_51'.tr;
    }
    if (label.contains('auto_key_56'.tr) || label.toLowerCase() == 'cash') {
      return 'cash'.tr;
    }
    if (label.contains('auto_key_57'.tr) || label.toLowerCase() == 'card') {
      return 'card'.tr;
    }
    return label;
  }
}
