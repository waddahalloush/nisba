import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// قائمة التبويبات الرئيسية: الكل | المطاعم | الخدمات
class MainTabs extends StatelessWidget {
  final RxInt selectedTab;
  final void Function(int) onTabSelected;

  static const _tabs = ['الكل', 'المطاعم', 'الخدمات'];

  const MainTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(
      () => SizedBox(
        height: 44.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_tabs.length, (i) {
            final isActive = selectedTab.value == i;
            return GestureDetector(
              onTap: () => onTabSelected(i),
              child: Container(
                margin: EdgeInsets.only(left: 24.w),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _tabs[i],
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isActive
                            ? cs.onSurface
                            : cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      width: isActive ? 40.w : 0,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: isActive ? cs.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
