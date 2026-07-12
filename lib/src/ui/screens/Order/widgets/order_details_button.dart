import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// زر عرض/إخفاء تفاصيل الطلب مع Animation دوران السهم
class OrderDetailsButton extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const OrderDetailsButton({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'عرض التفاصيل',
              style: theme.textTheme.labelMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4.w),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: cs.primary,
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
