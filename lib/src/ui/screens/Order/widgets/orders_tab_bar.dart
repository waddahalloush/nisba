import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// شريط تبويبات متحرك (الحالية / السابقة)
class OrdersTabBar extends StatelessWidget {
  final RxInt selectedTab;
  final void Function(int) onTabChanged;

  const OrdersTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            _buildTab(
              context,
              title: 'الحالية',
              index: 0,
              cs: cs,
              theme: theme,
            ),
            _buildTab(
              context,
              title: 'السابقة',
              index: 1,
              cs: cs,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required int index,
    required ColorScheme cs,
    required ThemeData theme,
  }) {
    final isSelected = selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(28.r),
          ),
          child: Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isSelected
                  ? cs.onPrimary
                  : cs.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
