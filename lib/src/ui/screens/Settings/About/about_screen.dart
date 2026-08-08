import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../../generated/assets.gen.dart';
import 'about_controller.dart';

class AboutScreen extends GetView<AboutController> {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(backIconData(context), color: cs.primary),
        ),
        title: Text(
          'about_app'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Body content ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // ── Contact info intro card ──
                  _buildContactIntroCard(theme),

                  SizedBox(height: 14.h),

                  // ── 'auto_key_560'.tr sub-card ──
                  _buildContactUsCard(theme),

                  SizedBox(height: 14.h),

                  // ── Contact details card ──
                  _buildContactDetailsCard(theme),

                  SizedBox(height: 14.h),

                  // ── Bottom note ──
                  _buildBottomNote(theme),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactIntroCard(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 32.w),
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
          // Headset icon
          Assets.images.callCenter.image(width: 70.w, height: 70.w),
          SizedBox(height: 12.h),
          Text(
            'auto_key_558'.tr,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'auto_key_559'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildContactUsCard(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.message, color: cs.primary, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'auto_key_560'.tr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'auto_key_561'.tr,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactDetailsCard(ThemeData theme) {
    final cs = theme.colorScheme;

    final items = [
      _ContactRow(
        icon: Iconsax.sms,
        label: 'auto_key_562'.tr,
        value: controller.email,
        onTap: controller.openEmail,
      ),
      _ContactRow(
        icon: Iconsax.call,
        label: 'auto_key_563'.tr,
        value: controller.phone,
        onTap: controller.callPhone,
      ),
      _ContactRow(
        icon: Icons.wechat,
        label: 'auto_key_564'.tr,
        value: controller.whatsapp,
        onTap: controller.openWhatsApp,
      ),
      _ContactRow(
        icon: Iconsax.location,
        label: 'auto_key_565'.tr,
        value: 'auto_key_556'.tr,
      ),
      _ContactRow(
        icon: Iconsax.clock,
        label: 'auto_key_566'.tr,
        value: 'auto_key_557'.tr,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
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
        children: List.generate(items.length, (i) {
          final item = items[i];
          final isLast = i == items.length - 1;

          return Column(
            children: [
              GestureDetector(
                onTap: item.onTap,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(item.icon, color: cs.primary, size: 18.sp),
                      ),
                      SizedBox(width: 12.w),

                      // Label + value
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              item.label,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: cs.primary,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              item.value is RxString
                                  ? (item.value as RxString).value
                                  : item.value as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
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
    );
  }

  Widget _buildBottomNote(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.r),
      decoration: BoxDecoration(
        color: cs.primary.withAlpha(12),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Assets.images.privacy.image(width: 40.w, height: 40.w),
          SizedBox(width: 10.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface),
                children: [
                  TextSpan(text: 'auto_key_567'.tr),
                  TextSpan(
                    text: '${'terms_and_services'.tr}\n',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.primary,
                    ),
                  ),
                  TextSpan(text: 'auto_key_569'.tr),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactRow {
  final IconData icon;
  final String label;
  final dynamic value; // String or RxString
  final VoidCallback? onTap;

  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });
}
