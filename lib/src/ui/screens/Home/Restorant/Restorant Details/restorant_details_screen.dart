import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'restorant_details_controller.dart';

class RestorantDetailsScreen extends GetView<RestorantDetailsController> {
  const RestorantDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Hero banner ──
              _buildHeroBanner(theme),

              // ── Restaurant info ──
              _buildRestaurantInfo(theme),

              // ── Order options ──
              _buildOrderOptions(theme),

              // ── Coupon banner ──
              _buildCouponBanner(theme),

              // ── Tabs ──
              _buildTabs(theme),

              // ── Special offers ──
              _buildSpecialOffers(theme),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 28.h),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [cs.primary, cs.primary.withValues(alpha: 0.75)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32.r),
              bottomRight: Radius.circular(32.r),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مشاوي الخليج',
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimary,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'طعم الأصالة.. جودة تستحق الثقة',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: cs.onPrimary.withValues(alpha: 0.9),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        SizedBox(
                          height: 36.h,
                          child: ElevatedButton(
                            onPressed: controller.orderNow,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.onPrimary,
                              foregroundColor: cs.primary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                            ),
                            child: Text(
                              'اطلب الآن',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 100.w,
                    height: 100.h,
                    decoration: BoxDecoration(
                      color: cs.onPrimary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(Iconsax.shop, color: cs.onPrimary, size: 50.sp),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 44.h,
          right: 8.w,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.onPrimary),
            style: IconButton.styleFrom(
              backgroundColor: cs.onPrimary.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRestaurantInfo(ThemeData theme) {
    final cs = theme.colorScheme;
    final r = controller.restorant;

    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      padding: EdgeInsets.all(14.r),
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
          Container(
            width: 50.w,
            height: 50.h,
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
                Row(
                  children: [
                    Text(
                      r.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Icon(Icons.verified, color: cs.primary, size: 16.sp),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  'وجبات مشوية، دجاج، مقبلات ${r.deliveryTime}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Iconsax.star1, color: cs.primary, size: 14.sp),
                    SizedBox(width: 3.w),
                    Text(
                      '${r.rating} (100+)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: cs.primary,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      r.distance,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderOptions(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          const Expanded(
            child: _OrderOption(
              icon: Iconsax.shop,
              title: 'تناول هنا',
              subtitle: 'استلام',
            ),
          ),
          SizedBox(width: 8.w),
          const Expanded(
            child: _OrderOption(
              icon: Iconsax.car,
              title: 'إلى السيارة',
              subtitle: 'يوصل الطلب',
            ),
          ),
          SizedBox(width: 8.w),
          const Expanded(
            child: _OrderOption(
              icon: Iconsax.calendar_1,
              title: 'حجز طاولة',
              subtitle: 'احجز جلستك',
            ),
          ),
          SizedBox(width: 8.w),
          const Expanded(
            child: _OrderOption(
              icon: Iconsax.truck_fast,
              title: 'توصيل',
              subtitle: 'يوصل طلبك',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          Icon(Iconsax.ticket_discount, color: cs.primary, size: 20.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'قسائم مستخدم جديدة بقيمة 200 ر.س',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: cs.primary,
              ),
            ),
          ),
          Text(
            'سجل الدخول للحصول عليها',
            style: TextStyle(
              fontSize: 10.sp,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 14.h),
      height: 40.h,
      child: Obx(
        () => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.tabs.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            final isSelected = controller.selectedTab.value == index;
            return GestureDetector(
              onTap: () => controller.selectTab(index),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  controller.tabs[index],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? cs.onPrimary
                        : cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpecialOffers(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Icon(Iconsax.star1, color: cs.primary, size: 18.sp),
              SizedBox(width: 6.w),
              Text(
                'العروض الخاصة',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        SizedBox(
          height: 150.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.meals.length,
            separatorBuilder: (_, __) => SizedBox(width: 10.w),
            itemBuilder: (context, index) {
              final meal = controller.meals[index];
              return Container(
                width: 260.w,
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
                    Container(
                      width: 70.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Iconsax.bag_2,
                        color: cs.primary.withValues(alpha: 0.4),
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            meal.description,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: cs.onSurface.withValues(alpha: 0.5),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Text(
                                'عدد الطلبات: ${meal.orders}',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: cs.onSurface.withValues(alpha: 0.45),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            '${meal.price.toStringAsFixed(2)} ر.س',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrderOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _OrderOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
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
          Icon(icon, color: cs.primary, size: 20.sp),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9.sp,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
