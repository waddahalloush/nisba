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
        : (number ?? 'بطاقة');
    return VisaCardModel(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      displayNumber: display,
      isDefault: map['is_default'] == true || map['is_default'] == 1,
      isUsable: map['is_usable'] != false,
    );
  }
}

class PaymentSettingController extends GetxController {
  static const _keyDefault = 'طريقة الدفع الافتراضية';
  static const _keyQr = 'المشتريات عبر QR-Code';
  static const _keyNoPhone = 'الدفع بدون هاتف';

  final dailyLimit = 5000.0.obs;
  final faceIdEnabled = true.obs;
  final fingerprintEnabled = false.obs;
  final selectedPaymentMethod = 'المحفظة'.obs;
  final visas = <VisaCardModel>[].obs;
  final isLoading = false.obs;

  final paymentMethods = <String, String>{
    _keyDefault: 'محفظة',
    _keyQr: 'محفظة',
    _keyNoPhone: 'محفظة',
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
          _enumDesc(map['default_payment_method']) ?? paymentMethods[_keyDefault]!;
      paymentMethods[_keyQr] = _enumDesc(map['default_qr_payment_method']) ??
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
        message: (res is Map ? res['message'] : null)?.toString() ??
            'تم تعيين البطاقة الافتراضية',
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
        message: (res is Map ? res['message'] : null)?.toString() ??
            'تم حذف البطاقة',
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
    selectedPaymentMethod.value =
        _normalizeLabel(paymentMethods[_editingKey] ?? 'المحفظة');

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
                    label: 'المحفظة',
                    isSelected: selectedPaymentMethod.value == 'المحفظة',
                    onTap: () => selectedPaymentMethod.value = 'المحفظة',
                  ),
                  Divider(
                    height: 1.h,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                  PaymentOption(
                    icon: Iconsax.cup,
                    label: 'نقاطي',
                    subtitle: '0 نقطة',
                    isSelected: selectedPaymentMethod.value == 'نقاطي',
                    onTap: () => selectedPaymentMethod.value = 'نقاطي',
                  ),
                  Divider(
                    height: 1.h,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                  PaymentOption(
                    icon: Iconsax.moneys,
                    label: 'نقداً',
                    isSelected: selectedPaymentMethod.value == 'نقداً',
                    onTap: () => selectedPaymentMethod.value = 'نقداً',
                  ),
                  Divider(
                    height: 1.h,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
                  PaymentOption(
                    icon: Iconsax.card,
                    label: 'بطاقة',
                    isSelected: selectedPaymentMethod.value == 'بطاقة',
                    onTap: () => selectedPaymentMethod.value = 'بطاقة',
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
                  'تطبيق',
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
      final res = await repository.setDefaultPaymentMethod(data: {
        'type': _settingKeyToType(_editingKey),
        'payment_method': _labelToApiMethod(label),
      });
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'تم تعيين طريقة الدفع: $label',
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
      final res = await repository.setDailyPurchaseLimit(data: {
        'amount': amount,
      });
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'تم تحديث الحد اليومي',
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
    switch (uiKey) {
      case _keyQr:
        return 'default_qr_payment_method';
      case _keyNoPhone:
        return 'default_without_phone_payment_method';
      case _keyDefault:
      default:
        return 'default_payment_method';
    }
  }

  String _labelToApiMethod(String label) {
    final n = _normalizeLabel(label);
    switch (n) {
      case 'نقاطي':
        return 'point';
      case 'نقداً':
        return 'cash';
      case 'بطاقة':
        return 'card';
      case 'المحفظة':
      default:
        return 'wallet';
    }
  }

  String _apiMethodToLabel(String value) {
    switch (value.toLowerCase()) {
      case 'point':
        return 'نقاطي';
      case 'cash':
        return 'نقداً';
      case 'card':
        return 'بطاقة';
      case 'wallet':
        return 'المحفظة';
      default:
        return value;
    }
  }

  String _normalizeLabel(String label) {
    if (label.contains('محفظ') || label.toLowerCase() == 'wallet') {
      return 'المحفظة';
    }
    if (label.contains('نقاط') || label.toLowerCase() == 'point') {
      return 'نقاطي';
    }
    if (label.contains('نقد') || label.toLowerCase() == 'cash') {
      return 'نقداً';
    }
    if (label.contains('بطاق') || label.toLowerCase() == 'card') {
      return 'بطاقة';
    }
    return label;
  }
}
