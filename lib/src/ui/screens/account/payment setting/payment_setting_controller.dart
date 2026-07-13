import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'widgets/payment_option.dart';

class PaymentSettingController extends GetxController {
  final dailyLimit = 5000.0.obs;
  final faceIdEnabled = true.obs;
  final fingerprintEnabled = false.obs;
  RxString  selectedPaymentMethod = "المحفظة".obs;

  final paymentMethods = <String, String>{
    'طريقة الدفع الافتراضية': 'محفظة',
    'المشتريات عبر QR-Code': 'محفظة',
    'الدفع بدون هاتف': 'محفظة',
  }.obs;

  void changePaymentMethod(String key) {
    // TODO: Show payment method picker
  }
  void showPaymentMethodSheet() {
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
            // ── Header ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'طريقة الدفع الافتراضية',
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

            // ── Options ──
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
                ],
              ),
            ),

            SizedBox(height: 24.h),

            // ── Apply button ──
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'تم',
                    'تم تعيين طريقة الدفع: ${selectedPaymentMethod.value}',
                  );
                },
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

  void setDailyLimit(double value) => dailyLimit.value = value;
  void toggleFaceId(bool v) => faceIdEnabled.value = v;
  void toggleFingerprint(bool v) => fingerprintEnabled.value = v;
}
