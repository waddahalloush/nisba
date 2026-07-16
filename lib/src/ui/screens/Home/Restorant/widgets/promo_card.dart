import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

class PromoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badgeText;
  final bool hasTimer;
  final String imagePath;

  const PromoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    this.hasTimer = false,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Food Image (Left) ──
          Container(
            width: 72.w,
            height: 72.h,
            alignment: Alignment.centerLeft,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(width: 8.w),

          // ── Text Info (Right) ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end, // Align to right in RTL
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rotated small orange logo icon
                Transform.rotate(
                  angle: 0.785, // 45 degrees
                  child: Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: textTheme.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.45),
                    fontSize: 9.sp,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                // Badge Container
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        badgeText,
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 8.5.sp,
                        ),
                      ),
                      if (hasTimer) ...[
                        SizedBox(width: 4.w),
                        Icon(
                          Iconsax.clock,
                          color: cs.primary,
                          size: 10.sp,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
