import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'offer_controller.dart';

class OfferScreen extends GetView<OfferController> {
  const OfferScreen({super.key});

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'العروض',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              Text(
                'عروض بالقرب منك',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Location bar ──
              _buildLocationBar(theme),

              SizedBox(height: 12.h),

              // ── Tab bar ──
              _buildTabBar(theme),

              SizedBox(height: 14.h),

              // ── Offer cards ──
              _buildOfferList(theme),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
        child: Row(
          children: [
            Icon(Iconsax.location, color: cs.primary, size: 18.sp),
            SizedBox(width: 10.w),
            Obx(
              () => Text(
                'التوصيل إلى ${controller.location.value}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface,
                ),
              ),
            ),
            const Spacer(),
            Icon(
              Iconsax.arrow_left_2,
              color: cs.onSurface.withValues(alpha: 0.3),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 36.h,
      child: Obx(
        () => ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          children: [
            _TabChip(
              label: 'عروض المطاعم',
              isSelected: controller.selectedTab.value == 0,
              onTap: () => controller.selectTab(0),
            ),
            SizedBox(width: 8.w),
            _TabChip(
              label: 'عروض مراكز التسوق',
              isSelected: controller.selectedTab.value == 1,
              onTap: () => controller.selectTab(1),
            ),
            SizedBox(width: 8.w),
            _TabChip(
              label: 'عروض الفنادق',
              isSelected: controller.selectedTab.value == 2,
              onTap: () => controller.selectTab(2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferList(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: controller.restaurants.map((restaurant) {
          return Padding(
            padding: EdgeInsets.only(bottom: 14.h),
            child: _RestaurantOfferCard(restaurant: restaurant),
          );
        }).toList(),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? cs.onPrimary
                : cs.onSurface.withValues(alpha: 0.55),
          ),
        ),
      ),
    );
  }
}

class _RestaurantOfferCard extends StatelessWidget {
  final OfferRestaurant restaurant;

  const _RestaurantOfferCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
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
          // ── Header ──
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                // Restaurant image placeholder
                Container(
                  width: 52.w,
                  height: 52.h,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(Iconsax.shop, color: cs.primary, size: 26.sp),
                ),
                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Iconsax.star1, color: cs.primary, size: 14.sp),
                          SizedBox(width: 3.w),
                          Text(
                            restaurant.rating.toString(),
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
                ),

                // Discount badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    restaurant.discount,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Items ──
          ...restaurant.items.map(
            (item) => Container(
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: cs.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Iconsax.bag_2,
                      color: cs.primary.withValues(alpha: 0.5),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      item.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                  Text(
                    '${item.price.toStringAsFixed(2)} ريال',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Delivery info ──
          Container(
            margin: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(Iconsax.truck_fast, color: cs.primary, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  restaurant.deliveryInfo,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w500,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
