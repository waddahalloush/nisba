import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import '../../../../../generated/assets.gen.dart';
import 'restorant_controller.dart';

class RestorantScreen extends GetView<RestorantController> {
  const RestorantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
        ),
        title: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.categoryTitle.value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              Text(
                'اكتشف أفضل ${controller.categoryTitle.value} القريبة منك',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Iconsax.notification, color: cs.primary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Promo cards ──
            _buildPromoCards(theme),

            SizedBox(height: 16.h),

            // ── Search bar ──
            _buildSearchBar(theme),

            SizedBox(height: 14.h),

            // ── Category icons ──
            _buildCategoryIcons(theme),

            SizedBox(height: 16.h),

            // ── Discount banner ──
            _buildDiscountBanner(theme),

            SizedBox(height: 16.h),

            // ── Nearby restaurants section ──
            _buildNearbySection(theme),

            SizedBox(height: 16.h),

            // ── Footer actions ──
            _buildFooterActions(theme),

            SizedBox(height: 16.h),

            // ── Nearby restaurants section ──
            _buildResturantSection(theme),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCards(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 120.h,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: cs.primary.withAlpha(20),

                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: Assets.images.appIcon.image(
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(
                          'وفر حتى 40%',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),

                        Text(
                          'على طلبك الأول',
                          style: TextStyle(fontSize: 9.sp, color: cs.onSurface),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: cs.primary.withAlpha(42),
                          ),
                          child: Text(
                            'الكود : First40',
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: cs.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 8,
                    child: Assets.images.resIcon.image(width: 80),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),

            Expanded(
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: cs.primary.withAlpha(20),

                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: Assets.images.appIcon.image(
                            width: 40,
                            height: 40,
                          ),
                        ),
                        Text(
                          'وجبات ب 25 ر.ق',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),

                        Text(
                          'اختر من قائمة مميزة',
                          style: TextStyle(fontSize: 9.sp, color: cs.onSurface),
                        ),

                        Row(
                          children: [
                            Icon(
                              Iconsax.tick_circle,
                              color: cs.error,
                              size: 14.sp,
                            ),
                            Text(
                              'ينتهي خلال 7 أيام',
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    left: 8,
                    child: Assets.images.resIcon2.image(width: 80),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
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
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'ابحث عن مطعم أو مطبخ…',
            hintStyle: TextStyle(
              color: cs.onSurface.withValues(alpha: 0.35),
              fontSize: 13.sp,
            ),
            prefixIcon: Icon(
              Iconsax.search_normal_1,
              color: cs.onSurface.withValues(alpha: 0.4),
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcons(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 80.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Column(
            children: [
              Container(
                width: 52.w,
                height: 52.h,
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(cat['icon'] as String),
              ),
              SizedBox(height: 6.h),
              Text(
                cat['label'] as String,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDiscountBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.primary.withValues(alpha: 0.7)],
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'خصم 20% على جميع الطلبات',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'فترة محدودة - اطلب الآن',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: cs.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: cs.onPrimary,
                    ),
                    child: Text(
                      'اطلب الآن',
                      style: TextStyle(fontSize: 11.sp, color: cs.primary),
                    ),
                  ),
                ],
              ),
            ),
            Assets.images.resIcon.image(width: 80.w),
            Stack(
              alignment: Alignment.center,
              children: [
                Assets.images.bubble.image(width: 80.w),
                Text(
                  'خصم\n20%',
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: cs.primary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbySection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(
            () => Text(
              controller.nearbyTitle.value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 210.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            itemCount: controller.restaurants.length,
            itemBuilder: (context, index) {
              final r = controller.restaurants[index];
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    AppRoutesNames.restorantDetails,
                    arguments: controller.restaurants[index],
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.w),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.asset(r.imagePath),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10.r),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                r.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.star1,
                                    color: cs.primary,
                                    size: 14.sp,
                                  ),
                                  Icon(
                                    Iconsax.star1,
                                    color: cs.primary,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    r.rating.toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.primary,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.timer_14,
                                    color: cs.onSurface,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    r.deliveryTime,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.location,
                                    color: cs.onSurface,
                                    size: 14.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    r.distance,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildResturantSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(
            () => Text(
              controller.restorantTitle.value,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 9 / 12,
          ),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.restaurants.length,
          itemBuilder: (context, index) {
            final r = controller.restaurants[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutesNames.restorantDetails,
                  arguments: controller.restaurants[index],
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.14),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
                        child: Image.asset(
                          r.imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            r.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Iconsax.star1,
                                color: cs.primary,
                                size: 14.sp,
                              ),
                              Icon(
                                Iconsax.star1,
                                color: cs.primary,
                                size: 14.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                r.rating.toString(),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: cs.primary,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Iconsax.timer_14,
                                color: cs.onSurface,
                                size: 14.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                r.deliveryTime,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Iconsax.location,
                                color: cs.onSurface,
                                size: 14.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                r.distance,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  color: cs.onSurface,
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
          },
        ),
      ],
    );
  }

  Widget _buildFooterActions(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          const Expanded(
            child: _FooterChip(
              icon: Icons.compare_arrows_rounded,
              label: 'ترتيب حسب',
            ),
          ),
          SizedBox(width: 4.w),
          const Expanded(
            child: _FooterChip(icon: Icons.restaurant_menu, label: 'المطابخ'),
          ),
          SizedBox(width: 4.w),
          const Expanded(
            child: _FooterChip(
              icon: Icons.star_border_rounded,
              label: 'تقييم 4.0+',
            ),
          ),
          SizedBox(width: 4.w),
          const Expanded(
            child: _FooterChip(icon: Iconsax.truck_fast, label: 'توصيل سريع'),
          ),
        ],
      ),
    );
  }
}

class _FooterChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FooterChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: cs.primary, size: 14.sp),
          SizedBox(width: 2.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
