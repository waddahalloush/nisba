import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/services/locale_service.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'payment_setting_controller.dart';

class PaymentSettingScreen extends GetView<PaymentSettingController> {
  const PaymentSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: Get.find<LocaleService>().textDirection,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(backIconData(context), color: cs.onSurface),
          ),
          title: Text(
            'payment_settings'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Payment method cards ──
              _buildPaymentMethodsSection(theme),

              SizedBox(height: 16.h),

              // ── Saved visas ──
              _buildVisasSection(theme),

              SizedBox(height: 16.h),

              // ── Add Visa card ──
              _buildAddVisaCard(theme),

              SizedBox(height: 16.h),

              // ── Daily limit slider ──
              _buildDailyLimitSlider(theme),

              SizedBox(height: 16.h),

              // ── Toggles ──
              _buildTogglesSection(theme),

              SizedBox(height: 16.h),

              // ── Payment password ──
              _buildPaymentPasswordTile(theme),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentPasswordTile(ThemeData theme) {
    final cs = theme.colorScheme;

    return InkWell(
      onTap: () => Get.toNamed(AppRoutesNames.changePaymentPassword),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Iconsax.lock, color: cs.primary, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'auto_key_58'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
            Icon(
              Iconsax.arrow_left_2,
              color: cs.onSurface.withValues(alpha: 0.3),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          children: List.generate(controller.paymentMethods.entries.length, (
            i,
          ) {
            final entry = controller.paymentMethods.entries.elementAt(i);
            final isLast = i == controller.paymentMethods.entries.length - 1;

            return Column(
              children: [
                InkWell(
                  onTap: () => controller.showPaymentMethodSheet(entry.key),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 38.w,
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            _iconForMethod(entry.key),
                            color: cs.primary,
                            size: 18.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // Title + value
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.key,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                entry.value,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Icon(
                          Iconsax.arrow_left_2,
                          color: cs.onSurface.withValues(alpha: 0.3),
                          size: 18.sp,
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 62.w,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  IconData _iconForMethod(String method) {
    if (method == 'auto_key_45'.tr) return Iconsax.card;
    if (method == 'auto_key_46'.tr) return Iconsax.scan_barcode;
    if (method == 'auto_key_47'.tr) return Iconsax.watch;
    return Iconsax.card;
  }

  Widget _buildVisasSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(() {
      if (controller.isLoading.value && controller.visas.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.visas.isEmpty) return const SizedBox.shrink();

      return Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: List.generate(controller.visas.length, (i) {
            final visa = controller.visas[i];
            final isLast = i == controller.visas.length - 1;
            return Column(
              children: [
                ListTile(
                  leading: Icon(Iconsax.card, color: cs.primary),
                  title: Text(visa.displayNumber),
                  subtitle: Text(
                    visa.isDefault ? 'auto_key_59'.tr : 'auto_key_60'.tr,
                    style: TextStyle(
                      color: visa.isDefault ? cs.primary : null,
                      fontSize: 12.sp,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Iconsax.trash, color: cs.error, size: 20.sp),
                    onPressed: () => controller.deleteVisa(visa.id),
                  ),
                  onTap: visa.isDefault
                      ? null
                      : () => controller.setDefaultVisa(visa.id),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 62.w,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
              ],
            );
          }),
        ),
      );
    });
  }

  Widget _buildAddVisaCard(ThemeData theme) {
    final cs = theme.colorScheme;

    return InkWell(
      onTap: () async {
        final result = await Get.toNamed(AppRoutesNames.visa);
        if (result == true) {
          controller.fetchVisas();
        }
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Iconsax.add_circle, color: cs.primary, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                'auto_key_61'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
            Icon(
              Iconsax.arrow_left_2,
              color: cs.primary.withValues(alpha: 0.5),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyLimitSlider(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.slider, color: cs.primary, size: 18.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'auto_key_62'.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // ── Min / Max labels ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
              Obx(
                () => Text(
                  '${controller.dailyLimit.value.toInt()}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
              Text(
                '10,000',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // ── Slider ──
          Obx(
            () => SliderTheme(
              data: SliderThemeData(
                activeTrackColor: cs.primary,
                inactiveTrackColor: cs.primary.withValues(alpha: 0.15),
                thumbColor: cs.primary,
                overlayColor: cs.primary.withValues(alpha: 0.12),
                trackHeight: 6,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
              ),
              child: Slider(
                value: controller.dailyLimit.value,
                min: 0,
                max: 10000,
                divisions: 100,
                onChanged: controller.setDailyLimit,
                onChangeEnd: controller.saveDailyLimit,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTogglesSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Face ID ──
          _ToggleRow(
            icon: Iconsax.scan,
            label: 'auto_key_63'.tr,
            value: controller.faceIdEnabled,
            onChanged: controller.toggleFaceId,
          ),
          Divider(
            height: 1,
            indent: 60.w,
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),

          // ── Fingerprint ──
          _ToggleRow(
            icon: Iconsax.finger_cricle,
            label: 'auto_key_64'.tr,
            value: controller.fingerprintEnabled,
            onChanged: controller.toggleFingerprint,
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final RxBool value;
  final Function(bool) onChanged;

  const _ToggleRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(
      () => SwitchListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
        secondary: Container(
          width: 38.w,
          height: 38.h,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: cs.primary, size: 18.sp),
        ),
        title: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
          ),
        ),
        value: value.value,
        onChanged: (v) => onChanged(v),
        activeThumbColor: cs.primary,
      ),
    );
  }
}
