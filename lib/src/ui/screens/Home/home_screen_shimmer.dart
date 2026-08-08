import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/utils/custom_shimmer_widget.dart';

/// Shimmer placeholder that mirrors the [HomeScreen] layout while the
/// [HomeResponse] API call is in progress (Status.init / Status.loading).
class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return CustomScrollView(
      slivers: [
        // ── 1. Header (profile + location pill + icons + search + banner) ──
        _HeaderShimmer(scheme: scheme),

        // ── Banners carousel ──
        _BannersCarouselShimmer(),

        // ── 2. Categories chips ──
        _CategoriesShimmer(),

        // ── 3. Services chips ──
        _CategoriesShimmer(),

        // ── 4. Daily offers ──
        _SectionTitleShimmer(),
        _HorizontalCardsShimmer(cardWidth: 120.w),

        // ── 5. Selected for you ──
        _SectionTitleShimmer(),
        _HorizontalCardsShimmer(cardWidth: 120.w),

        // ── 6. Popular brands ──
        _SectionTitleShimmer(),
        _BrandsGridShimmer(),

        // ── 7. Meals section ──
        _SectionTitleShimmer(),
        _HorizontalCardsShimmer(cardWidth: 200.w),

        // ── Bottom safe area ──
        SliverToBoxAdapter(child: SizedBox(height: 30.h)),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Private shimmer sub‑widgets
// ──────────────────────────────────────────────────────────────────────────────

/// Mimics the SliverAppBar header: profile avatar, location pill, action icons,
/// search field, and a large banner card.
class _HeaderShimmer extends StatelessWidget {
  final ColorScheme scheme;
  const _HeaderShimmer({required this.scheme});

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SliverToBoxAdapter(
      child: Container(
        color: scheme.primary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Toolbar area (matches SliverAppBar title bar) ──
            Padding(
              padding: EdgeInsets.only(
                top: statusBarHeight + 8.h,
                left: 16.w,
                right: 16.w,
              ),
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomShimmerWidget.circular(size: 36.w),
                    CustomShimmerWidget(
                      width: 160.w,
                      height: 28.h,
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    Row(
                      children: [
                        CustomShimmerWidget.circular(size: 22.w),
                        const SizedBox(width: 8),
                        CustomShimmerWidget.circular(size: 22.w),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ── Flexible space (search + banner) ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 12.h),
                  CustomShimmerWidget(
                    width: double.infinity,
                    height: 46.h,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  SizedBox(height: 10.h),
                  CustomShimmerWidget(
                    width: double.infinity,
                    height: 180.h,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scroll of banner-card shimmers.
class _BannersCarouselShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          SizedBox(height: 8.h),
          SizedBox(
            height: 130.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 3,
              itemBuilder: (_, __) => Padding(
                padding: EdgeInsetsDirectional.only(end: 10.w),
                child: CustomShimmerWidget(
                  width: 280.w,
                  height: 130.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal row of circular shimmer chips that mimic category/service items.
class _CategoriesShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const itemCount = 7;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 105.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemCount: itemCount,
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: SizedBox(
              width: 81.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomShimmerWidget.circular(size: 75.w),
                  SizedBox(height: 4.h),
                  CustomShimmerWidget(
                    width: 60.w,
                    height: 12.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Section title placeholder ("────" line + 'view_all'.tr line).
class _SectionTitleShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 10.h,
          bottom: 4.h,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomShimmerWidget(
              width: 120.w,
              height: 14.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
            CustomShimmerWidget(
              width: 60.w,
              height: 14.h,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal scroll of product-card shimmers.
class _HorizontalCardsShimmer extends StatelessWidget {
  final double cardWidth;
  const _HorizontalCardsShimmer({required this.cardWidth});

  @override
  Widget build(BuildContext context) {
    const visibleCount = 3;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 156.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          itemCount: visibleCount,
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: CustomShimmerWidget(
              width: cardWidth,
              height: 150.h,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}

/// Two‑row grid of square shimmers (popular brands).
class _BrandsGridShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const itemsPerRow = 6;

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 140.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          itemCount: itemsPerRow,
          itemBuilder: (_, __) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomShimmerWidget(
                  width: 60.w,
                  height: 60.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                SizedBox(height: 12.h),
                CustomShimmerWidget(
                  width: 60.w,
                  height: 60.h,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
