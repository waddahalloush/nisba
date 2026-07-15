import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'product_details_controller.dart';

class ProductDetailsScreen extends GetView<ProductDetailsController> {
  const ProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        bottomNavigationBar: _buildBottomBar(theme),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Image section ──
              _buildImageSection(theme),

              // ── Product info ──
              _buildProductInfo(theme),

              // ── Meal contents ──
              _buildMealContents(theme),

              // ── Nutrition info ──
              _buildNutritionInfo(theme),

              // ── Allergy notice ──
              _buildAllergyNotice(theme),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Stack(
      children: [
        // Product image placeholder
        Container(
          height: 260.h,
          width: double.infinity,
          color: cs.surfaceContainerHighest,
          child: Icon(
            Iconsax.hospital,
            color: cs.primary.withValues(alpha: 0.3),
            size: 80.sp,
          ),
        ),

        // Top icons
        Positioned(
          top: 44.h,
          left: 12.w,
          right: 12.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Favorite
              Obx(
                () => GestureDetector(
                  onTap: controller.toggleFavorite,
                  child: Container(
                    width: 38.w,
                    height: 38.h,
                    decoration: BoxDecoration(
                      color: cs.surface.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isFavorite.value
                          ? Iconsax.heart5
                          : Iconsax.heart,
                      color: controller.isFavorite.value
                          ? cs.error
                          : cs.onSurface.withValues(alpha: 0.5),
                      size: 18.sp,
                    ),
                  ),
                ),
              ),

              // Back
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 38.w,
                  height: 38.h,
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.arrow_right_1,
                    color: cs.onSurface,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ),

        // "الأكثر طلباً" badge
        Positioned(
          top: 100.h,
          right: 12.w,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Iconsax.star1, color: cs.onPrimary, size: 14.sp),
                SizedBox(width: 4.w),
                Text(
                  'الأكثر طلباً',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Carousel dots
        Positioned(
          bottom: 12.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Container(
                width: i == 0 ? 18.w : 6.w,
                height: 6.h,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: BoxDecoration(
                  color: i == 0
                      ? cs.primary
                      : cs.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ستريبس الدجاج الحار',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'ستربس الدجاج الحار مع بطاطا ومشروب غازي',
            style: TextStyle(
              fontSize: 12.sp,
              color: cs.onSurface.withValues(alpha: 0.55),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Iconsax.star1, color: cs.primary, size: 16.sp),
              SizedBox(width: 4.w),
              Text(
                '4.8 (253 تقييم)',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMealContents(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'محتويات الوجبة',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          ...controller.contents.map(
            (content) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(content.icon, color: cs.primary, size: 16.sp),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    content.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionInfo(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'القيم الغذائية (تقريبية)',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: controller.nutrition.map((n) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        n.value,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        n.label,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAllergyNotice(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Iconsax.warning_2, color: cs.error, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومات الحساسية',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'يحتوي على الغلوتين والصويا',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Quantity
          Container(
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: controller.decrement,
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    alignment: Alignment.center,
                    child: Icon(
                      Iconsax.minus,
                      color: cs.onSurface,
                      size: 16.sp,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    '${controller.quantity.value}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: controller.increment,
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    alignment: Alignment.center,
                    child: Icon(Iconsax.add, color: cs.primary, size: 16.sp),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Price text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'السعر',
                style: TextStyle(
                  fontSize: 10.sp,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
              Text(
                '25.00 ر.ق',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),

          const Spacer(),

          // Add to cart
          SizedBox(
            height: 44.h,
            child: ElevatedButton.icon(
              onPressed: controller.addToCart,
              icon: Icon(Iconsax.shopping_cart, size: 18.sp),
              label: Obx(
                () => Text(
                  'أضف للسلة ${(controller.price.value * controller.quantity.value).toStringAsFixed(2)} ر.ق',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
