import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// قائمة التبويبات الفرعية (كبسولات): صحي | مقاهي | بقالة | مطاعم
class SubTabs extends StatelessWidget {
  final RxInt selectedTab;
  final void Function(int) onTabSelected;

  static const _labels = ['صحي', 'مقاهي', 'بقالة', 'مطاعم'];

  const SubTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return SizedBox(
      height: 36.h,
      child: Row(
        children: List.generate(_labels.length, (i) {
          return Expanded(
            child: Obx(() {
              final isActive = selectedTab.value == i;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => onTabSelected(i),
                    child: Text(
                      _labels[i],
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: isActive
                            ? FontWeight.w700
                            : FontWeight.w500,

                        color: isActive
                            ? cs.onSurface
                            : cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: isActive ? 24.w : 0,
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: isActive ? cs.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              );
            }),
          );
        }),
      ),
    );
  }
}
