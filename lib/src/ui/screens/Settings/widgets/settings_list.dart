import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Settings/app_setting_controller.dart';

/// قائمة خيارات الإعدادات العمودية
class SettingsList extends StatelessWidget {
  final List<SettingsItem> items;

  const SettingsList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Column(
      children: List.generate(items.length, (i) {
        final item = items[i];
        final isLast = i == items.length - 1;

        return Column(
          children: [
            GestureDetector(
              onTap: item.onTap,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                child: Row(
                  children: [
                    // أيقونة داخل دائرة برتقالية شفافة
                    Container(
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, size: 18.sp, color: cs.primary),
                    ),
                    SizedBox(width: 14.w),
                    // عنوان الخيار
                    Expanded(
                      child: Text(
                        item.title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    // سهم للأيسر
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20.sp,
                      color: cs.onSurface.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
            if (!isLast)
              Divider(
                height: 1.h,
                color: cs.outlineVariant.withValues(alpha: 0.5),
              ),
          ],
        );
      }),
    );
  }
}
