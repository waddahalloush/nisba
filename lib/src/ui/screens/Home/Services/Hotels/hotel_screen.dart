import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import 'hotel_controller.dart';

class HotelScreen extends GetView<HotelController> {
  const HotelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.onSurface),
          ),
          title: Text(
            'الفنادق',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Search bar ──
                      _buildSearchBar(theme),

                      SizedBox(height: 12.h),

                      // ── Filter chips ──
                      _buildFilterChips(theme),

                      SizedBox(height: 14.h),

                      // ── Hotel list ──
                      _buildHotelList(theme),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Search Bar
  // ─────────────────────────────────────────────
  Widget _buildSearchBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          onChanged: controller.setSearchQuery,
          style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: 'ابحث عن فندق، مدينة أو منطقة',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            prefixIcon: Icon(
              Iconsax.search_normal_1,
              color: cs.onSurface.withValues(alpha: 0.4),
              size: 20.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 13.h),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Filter Chips
  // ─────────────────────────────────────────────
  Widget _buildFilterChips(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 38.h,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.filters.length,
          itemBuilder: (context, index) {
            final filter = controller.filters[index];
            final isSelected = controller.selectedFilter.value == filter;
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: GestureDetector(
                onTap: () => controller.selectFilter(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? cs.primary : cs.surface,
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: isSelected ? cs.primary : cs.outlineVariant,
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: cs.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: isSelected ? cs.onPrimary : cs.onSurface,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Hotel List
  // ─────────────────────────────────────────────
  Widget _buildHotelList(ThemeData theme) {
    return Obx(() {
      final hotels = controller.filteredHotels;

      if (hotels.isEmpty) {
        return _buildEmptyState(theme);
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: hotels.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return _buildHotelCard(theme, hotels[index]);
          },
        ),
      );
    });
  }

  Widget _buildEmptyState(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 60.h),
      child: Column(
        children: [
          Icon(
            Iconsax.building,
            size: 64.sp,
            color: cs.onSurface.withValues(alpha: 0.2),
          ),
          SizedBox(height: 14.h),
          Text(
            'لا توجد فنادق',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Single Hotel Card
  // ─────────────────────────────────────────────
  Widget _buildHotelCard(ThemeData theme, Hotel hotel) {
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutesNames.hotelDetails);
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hotel image with overlay badges ──
            SizedBox(
              height: 170.h,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // ── Placeholder image ──
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          cs.primary.withValues(alpha: 0.85),
                          cs.primary.withValues(alpha: 0.45),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Iconsax.building,
                        color: cs.onPrimary.withValues(alpha: 0.25),
                        size: 60.sp,
                      ),
                    ),
                  ),

                  // ── Rating badge (top-left) ──
                  Positioned(
                    top: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.star1, color: cs.onPrimary, size: 12.sp),
                          SizedBox(width: 4.w),
                          Text(
                            '${hotel.rating}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: cs.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Distance badge (bottom-left) ──
                  Positioned(
                    bottom: 10.h,
                    left: 10.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w,
                        vertical: 5.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.shadow.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Iconsax.location,
                            color: cs.onPrimary,
                            size: 11.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            hotel.distance,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: cs.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Card body ──
            Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Name + price ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          hotel.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'ابتداءً من',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.45),
                            ),
                          ),
                          Text(
                            '${hotel.price.toStringAsFixed(0)} ر.ق',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // ── Address ──
                  Row(
                    children: [
                      Icon(
                        Iconsax.location,
                        color: cs.onSurface.withValues(alpha: 0.4),
                        size: 13.sp,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          hotel.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  // ── Amenities chips ──
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: hotel.amenities
                        .map((a) => _buildAmenityChip(a, cs, theme))
                        .toList(),
                  ),

                  SizedBox(height: 12.h),

                  // ── Details button ──
                  SizedBox(
                    width: double.infinity,
                    height: 42.h,
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: navigate to hotel details
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.primary,
                        side: BorderSide(color: cs.primary, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        'عرض التفاصيل',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityChip(String label, ColorScheme cs, ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          color: cs.primary,
        ),
      ),
    );
  }
}
