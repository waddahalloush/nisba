import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

class DeliveryInfo extends StatelessWidget {
  final String deliveryTime;
  final String deliveryBy;
  final int satisfactionRate;

  const DeliveryInfo({
    super.key,
    required this.deliveryTime,
    required this.deliveryBy,
    required this.satisfactionRate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh.withValues(alpha: 0.4),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // ── Delivery Time ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.clock, color: cs.primary, size: 16.sp),
              SizedBox(width: 6.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'وقت التوصيل',
                    style: textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.4),
                      fontSize: 9.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    deliveryTime,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Delivery Partner ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.truck_fast, color: cs.primary, size: 16.sp),
              SizedBox(width: 6.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التوصيل بواسطة',
                    style: textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.4),
                      fontSize: 9.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    deliveryBy,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ── Satisfaction Rate ──
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Iconsax.star_1,
                color: cs.onSurface.withValues(alpha: 0.4),
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'نسبة رضا العملاء',
                    style: textTheme.labelSmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.4),
                      fontSize: 9.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '$satisfactionRate%',
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
