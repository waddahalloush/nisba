import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'rating_widget.dart';

class RestaurantHeader extends StatelessWidget {
  final String name;
  final double rating;
  final int reviewsCount;
  final String logoPath;
  final VoidCallback? onTapDetails;

  const RestaurantHeader({
    super.key,
    required this.name,
    required this.rating,
    required this.reviewsCount,
    required this.logoPath,
    this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      children: [
        // ── Logo (Right) ──
        Container(
          width: 56.w,
          height: 56.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.r),
            child: Image.asset(logoPath, fit: BoxFit.cover),
          ),
        ),
        // ── Info (Middle) ──
        SizedBox(width: 12.w),

        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the right
          children: [
            Text(
              name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 4.h),
            RatingWidget(rating: rating, reviewsCount: reviewsCount),
          ],
        ),

        const Spacer(),
        // ── Navigation Details Button (Left) ──
        GestureDetector(
          onTap: onTapDetails,
          child: Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: cs.primary,
                size: 14.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
