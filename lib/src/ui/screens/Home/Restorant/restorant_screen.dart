import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import 'restorant_controller.dart';

class RestorantScreen extends GetView<RestorantController> {
  const RestorantScreen({super.key});

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
          title: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.categoryTitle.value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
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
              icon: Icon(Iconsax.notification, color: cs.onSurface),
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

              SizedBox(height: 12.h),

              // ── Footer actions ──
              _buildFooterActions(theme),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCards(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 140.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [
          Container(
            width: 260.w,
            margin: EdgeInsets.only(left: 10.w),
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary, cs.primary.withValues(alpha: 0.75)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'وجبات',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ب 25 ر.س',
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.medical_information,
                    color: cs.onPrimary,
                    size: 34.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 260.w,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cs.primary.withValues(alpha: 0.85),
                  cs.primary.withValues(alpha: 0.6),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'وفر حتى 40%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'الكود FIRST40',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 70.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: cs.onPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Iconsax.discount_shape,
                    color: cs.onPrimary,
                    size: 34.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
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
                child: Icon(
                  cat['icon'] as IconData,
                  color: cs.primary,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                cat['label'] as String,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: cs.onSurface.withValues(alpha: 0.7),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(14.r),
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
                children: [
                  Text(
                    'خصم 20% على جميع الطلبات',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'فترة محدودة - اطلب الآن',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: cs.onPrimary.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                color: cs.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(Iconsax.home, color: cs.onPrimary, size: 28.sp),
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
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
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
                  width: 180.w,
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
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                        child: Container(
                          height: 110.h,
                          width: double.infinity,
                          color: cs.surfaceContainerHighest,
                          child: Icon(
                            Iconsax.shop,
                            color: cs.primary.withValues(alpha: 0.4),
                            size: 40.sp,
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
                                SizedBox(width: 3.w),
                                Text(
                                  r.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: cs.primary,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  '• ${r.deliveryTime}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: cs.onSurface.withValues(alpha: 0.5),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              r.distance,
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: cs.onSurface.withValues(alpha: 0.45),
                              ),
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
        ),
      ],
    );
  }

  Widget _buildFooterActions(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          const Expanded(
            child: _FooterChip(icon: Iconsax.truck_fast, label: 'توصيل سريع'),
          ),
          SizedBox(width: 8.w),
          const Expanded(
            child: _FooterChip(icon: Iconsax.star1, label: 'تقييم 4.0+'),
          ),
          SizedBox(width: 8.w),
          const Expanded(
            child: _FooterChip(icon: Iconsax.category, label: 'المطابخ'),
          ),
          SizedBox(width: 8.w),
          const Expanded(
            child: _FooterChip(icon: Iconsax.sort, label: 'ترتيب حسب'),
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
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
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
      child: Column(
        children: [
          Icon(icon, color: cs.primary, size: 18.sp),
          SizedBox(height: 4.h),
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
