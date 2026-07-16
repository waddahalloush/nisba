import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

class CategoryTabs extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CategoryTabs({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab(
            context: context,
            index: 0,
            label: 'عروض المطاعم',
            iconData: Icons.restaurant_rounded,
            theme: theme,
            cs: cs,
            textTheme: textTheme,
          ),

          _buildTab(
            context: context,
            index: 1,
            label: 'عروض مراكز التسوق',
            iconData: Iconsax.shop,
            theme: theme,
            cs: cs,
            textTheme: textTheme,
          ),
          _buildTab(
            context: context,
            index: 2,
            label: 'عروض الفنادق',
            iconData: Iconsax.building,
            theme: theme,
            cs: cs,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required BuildContext context,
    required int index,
    required String label,
    required IconData iconData,
    required ThemeData theme,
    required ColorScheme cs,
    required TextTheme textTheme,
  }) {
    final isSelected = selectedIndex == index;
    final tabColor = isSelected
        ? cs.primary
        : cs.onSurface.withValues(alpha: 0.65);

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconData, color: tabColor, size: 14.sp),
                SizedBox(width: 4.w),
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: tabColor,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
          // Tab Underline Indicator
          Container(
            height: 3.h,
            width: 88.w,
            decoration: BoxDecoration(
              color: isSelected ? cs.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(1.5.r),
            ),
          ),
        ],
      ),
    );
  }
}
