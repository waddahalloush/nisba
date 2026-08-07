import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Squircle Container ──
          Container(
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: cs.primary,
                size: 24.sp,
              ),
            ),
          ),
          
          SizedBox(height: 6.h),
          
          // ── Category Label ──
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface.withValues(alpha: 0.7),
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
