import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Search/search_controller.dart';

/// قائمة التبويبات الفرعية (كبسولات) — تتغير حسب التبويب الرئيسي
class SubTabs extends GetView<SearchhController> {
  const SubTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Obx(() {
      final labels = controller.subTabLabels;
      return SizedBox(
        height: 36.h,
        child: Row(
          children: List.generate(labels.length, (i) {
            final isActive = controller.selectedSubTab.value == i;
            return Expanded(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => controller.selectSubTab(i),
                    child: Text(
                      labels[i],
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight:
                            isActive ? FontWeight.w700 : FontWeight.w500,
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
              ),
            );
          }),
        ),
      );
    });
  }
}
