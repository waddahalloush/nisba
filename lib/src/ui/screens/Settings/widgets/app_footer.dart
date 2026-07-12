import 'package:flutter/material.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// فوتر التطبيق - النسخة والمعلومات
class AppFooter extends StatelessWidget {
  final String appName;
  final String appVersion;

  const AppFooter({super.key, required this.appName, required this.appVersion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // شارة "نسخة حديثة" خضراء
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  size: 14,
                  color: Color(0xFF2E7D32),
                ),
                SizedBox(width: 4.w),
                const Text(
                  'نسخة حديثة',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2E7D32),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // معلومات التطبيق
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                appName,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                appVersion,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          SizedBox(width: 8.w),
          // لوقو التطبيق
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Assets.images.appIcon.image(
              width: 36.r,
              height: 36.r,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
