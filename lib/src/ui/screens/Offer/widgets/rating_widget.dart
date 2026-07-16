import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int reviewsCount;

  const RatingWidget({
    super.key,
    required this.rating,
    required this.reviewsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '($reviewsCount تقييمات)',
          style: textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.4),
            fontSize: 10.sp,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          rating.toStringAsFixed(1),
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: cs.onSurface.withValues(alpha: 0.7),
            fontSize: 12.sp,
          ),
        ),
        SizedBox(width: 4.w),
        Icon(
          Icons.star_rounded,
          color: AppColors.star,
          size: 16.sp,
        ),
      ],
    );
  }
}
