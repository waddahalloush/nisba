import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'offer_controller.dart';
import 'widgets/category_tabs.dart';
import 'widgets/offer_card.dart';

class OfferScreen extends GetView<OfferController> {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              // ── 1. Top Curved Background Wave ──
              ClipPath(
                clipper: HeaderWaveClipper(),
                child: Container(
                  height: 135.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFB300), // Yellow/Amber
                        cs.primary, // Orange
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              // ── 2. Content ──
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Row: Location Pill (Left) & Title Row (Right)
                  _buildTopBar(context, theme, cs, textTheme),

                  SizedBox(height: 24.h),

                  // Center Titles: عروض بالقرب منك
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Text(
                              'عروض بالقرب منك',
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                                fontSize: 20.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'عروض حصرية بأفضل الأسعار وتوصيل سريع',
                          style: textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.45),
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Category Tab Bar
                  Obx(
                    () => CategoryTabs(
                      selectedIndex: controller.selectedTab.value,
                      onTabSelected: controller.selectTab,
                    ),
                  ),

                  SizedBox(height: 18.h),

                  // Restaurant Cards List
                  Obx(() {
                    if (controller.selectedTab.value != 0) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 60.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                controller.selectedTab.value == 1
                                    ? Icons.shopping_bag_outlined
                                    : Icons.apartment_outlined,
                                size: 48.sp,
                                color: cs.onSurface.withValues(alpha: 0.2),
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                'لا توجد عروض حالياً لهذه الفئة',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: controller.restaurants.map((restaurant) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: OfferCard(
                              restaurant: restaurant,
                              onTapDetails: () {
                                // Detail navigation
                              },
                              onTapAddItem: (item) {
                                // Add item to cart
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),

                  SizedBox(height: 32.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    ThemeData theme,
    ColorScheme cs,
    TextTheme textTheme,
  ) {
    final topPadding = MediaQuery.paddingOf(context).top;

    return Padding(
      padding: EdgeInsets.only(top: topPadding + 12.h, left: 16.w, right: 16.w),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'العروض',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),

          const Spacer(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: cs.primary,
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'التوصيل إلى',
                      style: textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.4),
                        fontSize: 8.sp,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller.location.value,
                        style: textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                Icon(Icons.location_on_rounded, color: cs.primary, size: 16.sp),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Custom Clipper for top header wave background ──
class HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.65); // Start on left edge at 85% height
    path.cubicTo(
      size.width * 0.72, // Control point 1 X (dips down and right)
      size.height * 0.65, // Control point 1 Y (max depth of wave)
      size.width * 0.2, // Control point 2 X (slopes back up towards top)
      size.height * 0.70, // Control point 2 Y (pulled upward)
      size.width * 0.72, // End point X (meets top edge)
      0, // End point Y (hits top edge)
    );
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
