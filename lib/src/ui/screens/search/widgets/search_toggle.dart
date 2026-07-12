import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// مفتاح تبديل عرض القائمة / عرض الخريطة
class SearchToggle extends StatelessWidget {
  final RxBool isMapView;
  final VoidCallback onToggle;

  const SearchToggle({
    super.key,
    required this.isMapView,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Obx(
      () => Container(
        height: 44.h,

        decoration: BoxDecoration(
          color: cs.onPrimary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Row(
          children: [
            // زر "عرض على الخريطة"
            _buildToggleButton(
              context,
              label: 'عرض على الخريطة',
              isActive: isMapView.value,
              cs: cs,
              theme: theme,
              onTap: () {
                if (!isMapView.value) onToggle();
              },
            ),
            // زر "عرض كقائمة"
            _buildToggleButton(
              context,
              label: 'عرض كقائمة',
              isActive: !isMapView.value,
              cs: cs,
              theme: theme,
              onTap: () {
                if (isMapView.value) onToggle();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context, {
    required String label,
    required bool isActive,
    required ColorScheme cs,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOut,
          margin: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: isActive ? Colors.transparent : cs.surface,
            borderRadius: BorderRadius.circular(22.r),
            border: isActive
                ? Border.all(color: cs.surface.withValues(alpha: 0.5), width: 1)
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: isActive ? cs.surface : cs.onSurface,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
        ),
      ),
    );
  }
}
