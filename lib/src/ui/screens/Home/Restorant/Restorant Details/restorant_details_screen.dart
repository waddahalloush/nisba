import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
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
        body: CustomScrollView(
          slivers: [
            // ── Hero banner ──
            _buildHeroBanner(theme),

            // ── Restaurant info ──
            SliverToBoxAdapter(child: _buildRestaurantInfo(theme)),

            // ── Order options ──
            SliverToBoxAdapter(child: _buildOrderOptions(theme)),

            // ── Coupon banner ──
            SliverToBoxAdapter(child: _buildCouponBanner(theme)),

            // ── Tabs ──
            SliverToBoxAdapter(child: _buildTabs(theme)),

            // ── Special offers ──
            SliverToBoxAdapter(child: _buildSpecialOffers(theme)),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Hero Banner
  // ─────────────────────────────────────────────
  Widget _buildHeroBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 200.h,
      pinned: true,
      backgroundColor: cs.surface,
      leading: Padding(
        padding: EdgeInsets.only(left: 8.w),
        child: Container(
          margin: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            color: cs.onPrimary,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.primary, size: 20.sp),
          ),
        ),
      ),

      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.r),
              bottomRight: Radius.circular(50.r),
            ),
            image: DecorationImage(
              image: Assets.images.coverImage.provider(),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.restorant.name,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xff733a16),
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                'طعم الأصالة.. جودة تستحق الثقة',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff733a16).withValues(alpha: 0.85),
                ),
              ),
              SizedBox(height: 28.h),
              SizedBox(
                height: 38.h,
                child: ElevatedButton(
                  onPressed: controller.orderNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff733a16),
                    foregroundColor: cs.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                  ),
                  child: Text(
                    'اطلب الآن',
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
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Restaurant Info
  // ─────────────────────────────────────────────
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
          // ── Logo ──
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14.r),
              image: DecorationImage(image: AssetImage(r.imagePath)),
            ),
          ),
          SizedBox(width: 12.w),

          // ── Info ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.verified, color: cs.primary, size: 16.sp),
                    SizedBox(width: 6.w),
                    Text(
                      r.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Iconsax.star1, size: 14.sp, color: Colors.amber),
                    SizedBox(width: 3.w),
                    Text(
                      '${r.rating} (100+)',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Iconsax.clock, color: cs.primary, size: 10.sp),
                          SizedBox(width: 3.w),
                          Text(
                            r.deliveryTime,
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: cs.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        'سريع',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Favorite icon ──
          GestureDetector(
            onTap: () {
              // TODO: toggle favorite
            },
            child: Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: cs.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(45.r),
              ),
              child: Icon(Iconsax.heart, color: cs.error, size: 18.sp),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Order Options
  // ─────────────────────────────────────────────
  Widget _buildOrderOptions(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: _OrderOption(
              icon: Assets.images.detailsMotorIcon.path,
              title: 'توصيل',
              subtitle: 'يوصل طلبك',
            ),
          ),

          SizedBox(width: 8.w),
          Expanded(
            child: _OrderOption(
              icon: Assets.images.detailsTableIcon.path,
              title: 'حجز طاولة',
              subtitle: 'احجز جلستك',
            ),
          ),

          SizedBox(width: 8.w),
          Expanded(
            child: _OrderOption(
              icon: Assets.images.detailsCarIcon.path,
              title: 'إلى السيارة',
              subtitle: 'يوصلك الطلب',
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _OrderOption(
              icon: Assets.images.detailsDeliveryIcon.path,
              title: 'تناول هنا',
              subtitle: 'استلام',
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Coupon Banner
  // ─────────────────────────────────────────────
  Widget _buildCouponBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: Assets.images.pointBg.provider(),
          fit: BoxFit.fill,
        ),
        border: Border.all(color: cs.primary.withValues(alpha: 0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'قسائم مستخدم جديدة بقيمة 200 ر.ق',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xff733a16),
            ),
          ),
          SizedBox(height: 5.h),
          Row(
            spacing: 18.w,
            children: [
              Text(
                'سجل للحصول عليها',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff733a16),
                ),
              ),
              SizedBox(
                height: 36.h,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: navigate to login/register
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.onPrimary,
                    foregroundColor: cs.primary,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'سجل الآن',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Tabs
  // ─────────────────────────────────────────────
  Widget _buildTabs(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 14.h),
      height: 40.h,
      child: Obx(() {
        final selectedIndex = controller.selectedTab.value;
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.tabs.length,
          separatorBuilder: (_, __) => SizedBox(width: 8.w),
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;
            return GestureDetector(
              onTap: () => controller.selectTab(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: BoxBorder.fromLTRB(
                    bottom: BorderSide(
                      color: isSelected ? cs.primary : Colors.transparent,
                    ),
                  ),
                ),
                child: Text(
                  controller.tabs[index],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isSelected ? cs.primary : cs.onSurface,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  //  Special Offers
  // ─────────────────────────────────────────────
  Widget _buildSpecialOffers(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(() {
            final tabTitle = controller.tabs[controller.selectedTab.value];
            return Row(
              children: [
                Icon(Iconsax.star1, color: cs.primary, size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  tabTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ],
            );
          }),
        ),
        SizedBox(height: 10.h),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.meals.length,
          separatorBuilder: (_, __) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            final meal = controller.meals[index];
            return Container(
              clipBehavior: Clip.antiAlias,
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: cs.onPrimary,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          meal.description,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          'عدد الطلبات : ${meal.orders}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: cs.onSurface,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          '${meal.price} ريال قطري',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.asset(
                          meal.image,
                          width: 120.w,
                          height: 100.w,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned(
                        left: 5,
                        bottom: 5,
                        child: CircleAvatar(
                          radius: 14.r,
                          backgroundColor: cs.onPrimary,
                          child: Icon(Icons.add, color: cs.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
//  Order Option Widget
// ─────────────────────────────────────────────
class _OrderOption extends StatelessWidget {
  final String icon;
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
          Image.asset(icon, width: 30, height: 30),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
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
