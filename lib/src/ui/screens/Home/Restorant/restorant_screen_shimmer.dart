import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/utils/custom_shimmer_widget.dart';

/// Shimmer placeholder that mirrors [RestorantScreen] while the section
/// details API call is in progress.
class RestorantScreenShimmer extends StatelessWidget {
  const RestorantScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── AppBar area (back + title + notification) ──
          _AppBarShimmer(),

          // ── 1. Promo cards ──
          _PromoCardsShimmer(),
          SizedBox(height: 16.h),

          // ── 2. Search bar ──
          _SearchBarShimmer(),
          SizedBox(height: 14.h),

          // ── 3. Category icons ──
          _CategoryIconsShimmer(),
          SizedBox(height: 16.h),

          // ── 4. Discount banner ──
          _DiscountBannerShimmer(),
          SizedBox(height: 16.h),

          // ── 5. Nearby section ──
          _SectionTitleShimmer(),
          _NearbyCardsShimmer(),
          SizedBox(height: 16.h),

          // ── 6. Footer actions ──
          _FooterChipsShimmer(),
          SizedBox(height: 16.h),

          // ── 7. Restaurant grid ──
          _SectionTitleShimmer(),
          _RestaurantGridShimmer(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────

/// AppBar area: back icon, two text lines, notification icon.
class _AppBarShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.h,
        left: 8.w,
        right: 8.w,
      ),
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          children: [
            CustomShimmerWidget.circular(size: 40.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShimmerWidget(
                    width: 100.w,
                    height: 14.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  SizedBox(height: 6.h),
                  CustomShimmerWidget(
                    width: 160.w,
                    height: 10.h,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ],
              ),
            ),
            CustomShimmerWidget.circular(size: 40.w),
          ],
        ),
      ),
    );
  }
}

/// Two side-by-side promo card shimmers.
class _PromoCardsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: SizedBox(
        height: 120.h,
        child: Row(
          children: [
            Expanded(
              child: CustomShimmerWidget(
                width: double.infinity,
                height: 120.h,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CustomShimmerWidget(
                width: double.infinity,
                height: 120.h,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-width search bar shimmer.
class _SearchBarShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: CustomShimmerWidget(
        width: double.infinity,
        height: 50.h,
        borderRadius: BorderRadius.circular(25.r),
      ),
    );
  }
}

/// Horizontal scroll of squircle icon + label shimmers.
class _CategoryIconsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomShimmerWidget(
                width: 52.w,
                height: 52.h,
                borderRadius: BorderRadius.circular(14.r),
              ),
              SizedBox(height: 6.h),
              CustomShimmerWidget(
                width: 40.w,
                height: 10.h,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gradient-like discount banner shimmer.
class _DiscountBannerShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: CustomShimmerWidget(
        width: double.infinity,
        height: 130.h,
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}

/// Section title placeholder.
class _SectionTitleShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomShimmerWidget(
            width: 130.w,
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
    );
  }
}

/// Horizontal scroll of restaurant card shimmers.
class _NearbyCardsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        itemCount: 3,
        itemBuilder: (_, __) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: CustomShimmerWidget(
            width: 160.w,
            height: 200.h,
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
    );
  }
}

/// Row of 4 filter chip shimmers.
class _FooterChipsShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: List.generate(
          4,
          (_) => Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: CustomShimmerWidget(
                width: double.infinity,
                height: 36.h,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 2-column grid of restaurant card shimmers.
class _RestaurantGridShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 9 / 12,
        ),
        itemCount: 6,
        itemBuilder: (_, __) => CustomShimmerWidget(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),
    );
  }
}
