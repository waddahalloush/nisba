import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/configs/theme_extensions.dart';

import 'hotel_details_controller.dart';

class HotelDetailsScreen extends GetView<HotelDetailsController> {
  const HotelDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    // ── Image gallery with overlay actions ──
                    _buildImageGallery(theme),

                    // ── Hotel info ──
                    SliverToBoxAdapter(child: _buildHotelInfo(theme)),

                    // ── Amenities ──
                    SliverToBoxAdapter(child: _buildAmenities(theme)),

                    // ── Instant booking CTA ──
                    SliverToBoxAdapter(child: _buildBookingCta(theme)),

                    // ── Room tabs ──
                    SliverToBoxAdapter(child: _buildRoomTabs(theme)),

                    // ── Room detail card ──
                    SliverToBoxAdapter(child: _buildRoomCard(theme)),

                    // ── Bottom spacing ──
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  ],
                ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Image Gallery
  // ─────────────────────────────────────────────
  Widget _buildImageGallery(ThemeData theme) {
    final cs = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 260.h,
      pinned: true,
      backgroundColor: cs.surface,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Container(
          margin: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: cs.shadow.withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.onPrimary, size: 20.sp),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Container(
            margin: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: cs.shadow.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.heart, color: cs.onPrimary, size: 20.sp),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: Container(
            margin: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: cs.shadow.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.share, color: cs.onPrimary, size: 20.sp),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            // ── Placeholder image ──
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withValues(alpha: 0.9),
                    cs.primary.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Icon(
                  Iconsax.building,
                  color: cs.onPrimary.withValues(alpha: 0.2),
                  size: 80.sp,
                ),
              ),
            ),

            // ── Location + counter overlay (bottom-left) ──
            Positioned(
              bottom: 16.h,
              right: 16.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: cs.shadow.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.location,
                          color: cs.onPrimary,
                          size: 12.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          controller.location,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: cs.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Image counter (bottom-right) ──
            Positioned(
              bottom: 16.h,
              left: 16.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: cs.shadow.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Obx(
                  () => Text(
                    '${controller.currentImageIndex.value + 1}/${controller.totalImages}',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Hotel Info
  // ─────────────────────────────────────────────
  Widget _buildHotelInfo(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Rating row ──
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${controller.rating}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: cs.onPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      controller.ratingLabel,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: cs.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '${controller.reviewCount} تقييم',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // ── Hotel name ──
          Text(
            controller.hotelName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),

          SizedBox(height: 4.h),

          // ── Stars + subtitle ──
          Row(
            children: [
              ...List.generate(
                controller.stars,
                (_) => Padding(
                  padding: EdgeInsets.only(left: 2.w),
                  child: Icon(
                    Iconsax.star1,
                    color: cs.primary,
                    size: 14.sp,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                controller.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Amenities
  // ─────────────────────────────────────────────
  Widget _buildAmenities(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: controller.amenities
            .map(
              (a) => Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: cs.outlineVariant, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_amenityIcon(a), color: cs.primary, size: 14.sp),
                    SizedBox(width: 6.w),
                    Text(
                      a,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  IconData _amenityIcon(String amenity) {
    switch (amenity) {
      case 'واي فاي مجاني':
        return Iconsax.wifi;
      case 'مسبح':
        return Iconsax.empty_wallet;
      case 'إفطار مجاني':
        return Iconsax.coffee;
      case 'مواقف سيارات':
        return Iconsax.car;
      default:
        return Iconsax.tick_circle;
    }
  }

  // ─────────────────────────────────────────────
  //  Instant Booking CTA
  // ─────────────────────────────────────────────
  Widget _buildBookingCta(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: cs.primary.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // ── Lightning icon ──
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Iconsax.flash, color: cs.primary, size: 22.sp),
            ),
            SizedBox(width: 12.w),

            // ── Text ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تأكيد فوري',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'استلام الحجز خلال 30 دقيقة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // ── CTA button ──
            SizedBox(
              height: 40.h,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: instant booking
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'استلام',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Room Tabs
  // ─────────────────────────────────────────────
  Widget _buildRoomTabs(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 42.h,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.roomTabs.length,
          itemBuilder: (context, index) {
            final tab = controller.roomTabs[index];
            final isSelected = controller.selectedRoomTab.value == index;
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: GestureDetector(
                onTap: () => controller.selectRoomTab(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
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
                    tab,
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
  //  Room Detail Card
  // ─────────────────────────────────────────────
  Widget _buildRoomCard(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(() {
      final room = controller.selectedRoom;

      return Padding(
        padding: EdgeInsets.all(16.r),
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
              // ── Room image ──
              SizedBox(
                height: 160.h,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            cs.primary.withValues(alpha: 0.85),
                            cs.primary.withValues(alpha: 0.4),
                          ],
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Iconsax.home,
                          color: cs.onPrimary.withValues(alpha: 0.25),
                          size: 50.sp,
                        ),
                      ),
                    ),

                    // ── Capacity badge ──
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.profile_2user,
                              color: cs.onPrimary,
                              size: 12.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${room.capacity} ${room.bedType}',
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

              // ── Room details ──
              Padding(
                padding: EdgeInsets.all(14.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Room name ──
                    Text(
                      room.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // ── Features list ──
                    ...room.amenities.map(
                      (feat) => Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.tick_circle,
                              color: cs.primary,
                              size: 14.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                feat,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ── Area ──
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Row(
                        children: [
                          Icon(
                            Iconsax.maximize,
                            color: cs.primary,
                            size: 14.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'مساحة الغرفة: ${room.area.toStringAsFixed(0)} م²',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── View ──
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: Row(
                        children: [
                          Icon(Iconsax.eye, color: cs.primary, size: 14.sp),
                          SizedBox(width: 8.w),
                          Text(
                            room.view,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // ── Divider ──
                    Container(height: 1, color: cs.outlineVariant),

                    SizedBox(height: 12.h),

                    // ── Price + book button ──
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'السعر لليلة',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.45),
                              ),
                            ),
                            Text(
                              '${room.pricePerNight.toStringAsFixed(0)} در.ا',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          height: 42.h,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: book room
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: cs.onPrimary,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(horizontal: 22.w),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              'احجز الآن',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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
    });
  }
}
