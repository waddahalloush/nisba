import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../../generated/assets.gen.dart';
import 'point_controller.dart';

class PointScreen extends GetView<PointController> {
  const PointScreen({super.key});

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
          icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
        ),
        title: Text(
          'نقاطي',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header banner ──
            _buildHeaderBanner(theme),

            // ── Body ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // ── Action cards ──
                  _buildActionCards(theme),

                  SizedBox(height: 14.h),

                  // ── Promo banner ──
                  _buildPromoBanner(theme),

                  SizedBox(height: 16.h),

                  // ── Ways to earn ──
                  _buildEarnWays(theme),

                  SizedBox(height: 16.h),

                  // ── Points log ──
                  _buildPointsLog(theme),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: cs.primary,
        image: DecorationImage(
          image: Assets.images.pointBg.provider(),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.circular(36.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Points total ──
          Text(
            'إجمالي نقاطك',
            style: TextStyle(fontSize: 13.sp, color: cs.onPrimary),
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Obx(
                () => Text(
                  '${controller.totalPoints.value}',
                  style: TextStyle(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'نقطة',
                  style: TextStyle(fontSize: 13.sp, color: cs.onPrimary),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),
          // ── Expiry ──
          Obx(
            () => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Iconsax.clock, color: cs.onPrimary, size: 14.sp),
                  SizedBox(width: 4.w),
                  Text(
                    'تنتهي النقاط في ${controller.expiryDate.value}',
                    style: TextStyle(fontSize: 11.sp, color: cs.onPrimary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
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
          Expanded(
            child: _ActionCard(
              icon: Iconsax.calculator,
              title: 'حاسبة النقاط',
              subtitle: 'احسب نقاط مشترياتك',
              onTap: controller.calculatePoints,
            ),
          ),
          Container(
            width: 1,
            height: 50.h,
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
          Expanded(
            child: _ActionCard(
              icon: Iconsax.send_2,
              title: 'إرسال نقاط لصديق',
              subtitle: 'شارك نقاطك لمن تحب',
              onTap: controller.sendToFriend,
            ),
          ),
          Container(
            width: 1,
            height: 50.h,
            color: cs.outlineVariant.withValues(alpha: 0.5),
          ),
          Expanded(
            child: _ActionCard(
              icon: Iconsax.convert_card,
              title: 'استبدال إلى رصيد',
              subtitle: 'حول نقاطك إلى رصيد',
              onTap: controller.redeemToBalance,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Assets.images.pointIconSmall.image(width: 35.w, height: 35.h),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'كل نقطة تقربك من المزيد!\n استخدم نقاطك واستمتع بمزايا حصرية وعروض مميزة.',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarnWays(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
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
          Text(
            'طرق اكتساب النقاط',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          Divider(
            height: 12.h,
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
          const _EarnWayRow(
            icon: Iconsax.shop,
            text: 'الشراء من المطاعم/المحلات.',
          ),
          Divider(
            height: 12.h,
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
          const _EarnWayRow(
            icon: Iconsax.discount_shape,
            text: 'العروض الخاصة والترويج.',
          ),
          Divider(
            height: 12.h,
            color: cs.outlineVariant.withValues(alpha: 0.4),
          ),
          const _EarnWayRow(icon: Iconsax.people, text: 'إحالة الأصدقاء.'),
        ],
      ),
    );
  }

  Widget _buildPointsLog(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Totals row ──
        Container(
          padding: EdgeInsets.only(bottom: 11.h, right: 11.h, left: 11.h),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16.r),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'سجل النقاط',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    iconAlignment: IconAlignment.end,
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: cs.primary,
                      size: 10.sp,
                    ),
                    label: Text(
                      'عرض الكل',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                        color: cs.primary,
                      ),
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: _TotalColumn(
                      label: 'إجمالي المكتسب',
                      value: controller.totalEarned,
                      color: Colors.teal,
                    ),
                  ),
                  Container(width: 1, height: 30.h, color: cs.outlineVariant),
                  Expanded(
                    child: _TotalColumn(
                      label: 'إجمالي المستبدل',
                      value: controller.totalRedeemed,
                      color: cs.error,
                    ),
                  ),
                  Container(width: 1, height: 30.h, color: cs.outlineVariant),
                  Expanded(
                    child: _TotalColumn(
                      label: 'الرصيد الحالي',
                      value: controller.totalPoints,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        // ── Log entries ──
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(controller.log.length, (i) {
              final entry = controller.log[i];
              final isLast = i == controller.log.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(14.r),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: entry.isEarned
                                ? cs.primary.withValues(alpha: 0.08)
                                : cs.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            entry.isEarned
                                ? Iconsax.add_circle
                                : Iconsax.minus_cirlce,
                            color: entry.isEarned ? cs.primary : cs.error,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.title,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                entry.date,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.45),
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              entry.points,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: entry.isEarned ? cs.primary : cs.error,
                              ),
                            ),
                            Text(
                              entry.isEarned ? 'مكتسب' : 'مستبدل',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: entry.isEarned
                                    ? cs.primary.withValues(alpha: 0.7)
                                    : cs.error.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 66.w,
                      color: cs.outlineVariant.withValues(alpha: 0.4),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
        child: Column(
          children: [
            Icon(icon, color: cs.primary, size: 22.sp),
            SizedBox(height: 6.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 8.sp,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarnWayRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _EarnWayRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: cs.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: cs.primary, size: 16.sp),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: cs.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _TotalColumn extends StatelessWidget {
  final String label;
  final RxInt value;
  final Color color;

  const _TotalColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: color.withValues(alpha: 0.7),
          ),
        ),
        SizedBox(height: 4.h),
        Obx(
          () => Text(
            '${value.value}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
