import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

class MenuItemCard extends StatelessWidget {
  final String name;
  final double price;
  final double? oldPrice;
  final String imagePath;
  final bool isPopular;
  final String prepTime;
  final VoidCallback? onTapAdd;

  const MenuItemCard({
    super.key,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imagePath,
    this.isPopular = false,
    this.prepTime = '0-0 دقيقة',
    this.onTapAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: 104.w,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Image Stack ──
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Food Image
              Container(
                height: 84.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),

              // Plus Button (Bottom-Left overlap)
              Positioned(
                bottom: -6.h,
                left: -4.w,
                child: GestureDetector(
                  onTap: onTapAdd,
                  child: Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: cs.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.add, color: Colors.white, size: 14.sp),
                    ),
                  ),
                ),
              ),

              // Popularity Badge (Top-Right)
              if (isPopular)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(8.r),
                        topRight: Radius.circular(15.r),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'الأكثر طلباً',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text('🔥', style: TextStyle(fontSize: 7.sp)),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 10.h),

          // ── Text Info ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Item Name
                Text(
                  name,
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    fontSize: 10.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 4.h),

                // Prep Time
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      prepTime,
                      style: textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.35),
                        fontSize: 8.sp,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Icon(
                      Iconsax.clock,
                      color: cs.onSurface.withValues(alpha: 0.3),
                      size: 9.sp,
                    ),
                  ],
                ),

                SizedBox(height: 4.h),

                // Price (Current + Old)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${price.toStringAsFixed(2)} ريال',
                      style: textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                        fontSize: 10.sp,
                      ),
                    ),
                    if (oldPrice != null) ...[
                      SizedBox(width: 4.w),
                      Text(
                        oldPrice!.toStringAsFixed(2),
                        style: textTheme.labelSmall?.copyWith(
                          color: cs.onSurface.withValues(alpha: 0.3),
                          decoration: TextDecoration.lineThrough,
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}
