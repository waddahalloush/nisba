import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/utils/custom_shimmer_widget.dart';

/// Shimmer placeholder that mirrors the [ProductDetailsScreen] layout while
/// the product details API call is in progress.
class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Image section ──
          _ImageSectionShimmer(cs: cs),

          // ── 2. Product info card ──
          _InfoCardShimmer(cs: cs),

          // ── 3. Meal contents card ──
          _ContentsCardShimmer(cs: cs),

          // ── 4. Nutrition card ──
          _NutritionCardShimmer(cs: cs),

          // ── 5. Allergy card ──
          _AllergyCardShimmer(cs: cs),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// Image placeholder (230.h) with back / fav icon circles and a badge pill.
class _ImageSectionShimmer extends StatelessWidget {
  final ColorScheme cs;
  const _ImageSectionShimmer({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main image area
        CustomShimmerWidget(
          width: double.infinity,
          height: 230.h,
          borderRadius: BorderRadius.zero,
        ),

        // Top action icons
        Positioned(
          top: 44.h,
          left: 12.w,
          right: 12.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomShimmerWidget.circular(size: 38.w),
              CustomShimmerWidget.circular(size: 38.w),
            ],
          ),
        ),

        // "Most ordered" badge
        Positioned(
          bottom: 20.h,
          left: 20.w,
          child: CustomShimmerWidget(
            width: 100.w,
            height: 28.h,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),

        // Carousel dots
        Positioned(
          bottom: 12.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: CustomShimmerWidget(
                  width: i == 0 ? 18.w : 6.w,
                  height: 6.h,
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Product info card: name, description, market, rating, price.
class _InfoCardShimmer extends StatelessWidget {
  final ColorScheme cs;
  const _InfoCardShimmer({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          CustomShimmerWidget(
            width: 180.w,
            height: 16.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 8.h),
          // Description
          CustomShimmerWidget(
            width: 260.w,
            height: 12.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 10.h),
          // Market row
          Row(
            children: [
              CustomShimmerWidget.circular(size: 14.w),
              SizedBox(width: 4.w),
              CustomShimmerWidget(
                width: 80.w,
                height: 12.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
              SizedBox(width: 8.w),
              CustomShimmerWidget(
                width: 70.w,
                height: 12.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Rating
          Row(
            children: [
              CustomShimmerWidget.circular(size: 16.w),
              SizedBox(width: 4.w),
              CustomShimmerWidget(
                width: 100.w,
                height: 12.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Price row
          Row(
            children: [
              CustomShimmerWidget(
                width: 70.w,
                height: 16.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
              SizedBox(width: 8.w),
              CustomShimmerWidget(
                width: 50.w,
                height: 12.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
              SizedBox(width: 8.w),
              CustomShimmerWidget(
                width: 40.w,
                height: 20.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Meal contents card: title + 3 icon+text rows.
class _ContentsCardShimmer extends StatelessWidget {
  final ColorScheme cs;
  const _ContentsCardShimmer({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          CustomShimmerWidget(
            width: 120.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 14.h),
          // 3 content rows
          ...List.generate(
            3,
            (_) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  CustomShimmerWidget(
                    width: 32.w,
                    height: 32.h,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  SizedBox(width: 10.w),
                  CustomShimmerWidget(
                    width: 160.w,
                    height: 12.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nutrition info card: title + 4 value/label columns.
class _NutritionCardShimmer extends StatelessWidget {
  final ColorScheme cs;
  const _NutritionCardShimmer({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          CustomShimmerWidget(
            width: 140.w,
            height: 14.h,
            borderRadius: BorderRadius.circular(4.r),
          ),
          SizedBox(height: 14.h),
          // 4 nutrition columns
          Row(
            children: List.generate(
              4,
              (_) => Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: [
                      CustomShimmerWidget(
                        width: 40.w,
                        height: 14.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      SizedBox(height: 6.h),
                      CustomShimmerWidget(
                        width: 30.w,
                        height: 10.h,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Allergy notice card: icon + text lines.
class _AllergyCardShimmer extends StatelessWidget {
  final ColorScheme cs;
  const _AllergyCardShimmer({required this.cs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          CustomShimmerWidget.circular(size: 20.w),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomShimmerWidget(
                  width: 120.w,
                  height: 12.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
                SizedBox(height: 6.h),
                CustomShimmerWidget(
                  width: 180.w,
                  height: 10.h,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
