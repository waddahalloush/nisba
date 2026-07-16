import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/models/restorant_model.dart';

class NearbyRestaurantCard extends StatelessWidget {
  final RestorantModel restaurant;
  final VoidCallback? onTap;
  final VoidCallback? onTapFavorite;

  const NearbyRestaurantCard({
    super.key,
    required this.restaurant,
    this.onTap,
    this.onTapFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 136.w,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Image with Heart Overlay ──
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: Image.asset(
                    restaurant.imagePath,
                    height: 110.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Wishlist Heart Icon (Top-Left)
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: GestureDetector(
                    onTap: onTapFavorite,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        restaurant.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Detail Section ──
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // RTL align
                children: [
                  // Restaurant Name
                  Text(
                    restaurant.name,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                      fontSize: 11.5.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),

                  SizedBox(height: 4.h),

                  // Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface.withValues(alpha: 0.75),
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Icon(
                        Icons.star_rounded,
                        color: AppColors.star,
                        size: 12.sp,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Prep Time Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        restaurant.deliveryTime,
                        style: textTheme.labelSmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.45),
                          fontSize: 9.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Iconsax.clock,
                        color: cs.onSurface.withValues(alpha: 0.35),
                        size: 10.sp,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Distance Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        restaurant.distance,
                        style: textTheme.labelSmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.45),
                          fontSize: 9.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Iconsax.location,
                        color: cs.onSurface.withValues(alpha: 0.35),
                        size: 10.sp,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
