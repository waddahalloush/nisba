import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
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
        body: Obx(() {
          final isStore = controller.isStore;
          return CustomScrollView(
            slivers: [
              // ── Hero banner ──
              _buildHeroBanner(theme),

              // ── Restaurant info ──
              SliverToBoxAdapter(child: _buildRestaurantInfo(theme)),

              // ── Order options (hidden for store) ──
              if (!isStore)
                SliverToBoxAdapter(child: _buildOrderOptions(theme)),

              // ── Coupon banner (hidden for store) ──
              if (!isStore)
                SliverToBoxAdapter(child: _buildCouponBanner(theme)),

              // ── Tabs ──
              if (!isStore) SliverToBoxAdapter(child: _buildTabs(theme)),

              // ── Special offers (hidden for store) ──
              if (!isStore)
                SliverToBoxAdapter(child: _buildSpecialOffers(theme)),

              // ── Reviews ──
              SliverToBoxAdapter(child: _buildReviews(theme)),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        }),
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
              image: AssetImage(controller.coverImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                () => Text(
                  controller.restorant.value.name,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xff733a16),
                  ),
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

    return Obx(() {
      final r = controller.restorant.value;
      final hasDesc = r.description.isNotEmpty;
      final reviewsCount = controller.reviewsCount.value;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top row: logo, name, favorite ──
            Row(
              children: [
                // Logo
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    color: cs.surfaceContainerHighest,
                    child: r.imagePath.startsWith('http')
                        ? Image.network(
                            r.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(
                              Iconsax.shop,
                              color: cs.primary,
                              size: 22.sp,
                            ),
                          )
                        : (r.imagePath.isNotEmpty
                              ? Image.asset(r.imagePath, fit: BoxFit.cover)
                              : Icon(
                                  Iconsax.shop,
                                  color: cs.primary,
                                  size: 22.sp,
                                )),
                  ),
                ),
                SizedBox(width: 12.w),

                // Name & verified
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.verified, color: cs.primary, size: 16.sp),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              r.name,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      // Rating row
                      Row(
                        children: [
                          Icon(
                            Iconsax.star1,
                            size: 14.sp,
                            color: AppColors.star,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            '${r.rating.toStringAsFixed(1)} ($reviewsCount+)',
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

                // Favorite
                GestureDetector(
                  onTap: () => controller.toggleFavorite(),
                  child: Obx(() {
                    final liked = controller.restorant.value.isFavorite;
                    return Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(45.r),
                      ),
                      child: Icon(
                        liked ? Iconsax.heart5 : Iconsax.heart,
                        color: cs.error,
                        size: 18.sp,
                      ),
                    );
                  }),
                ),
              ],
            ),

            // ── Factual details row ──
            SizedBox(height: 10.h),
            Wrap(
              spacing: 10.w,
              runSpacing: 8.h,
              children: [
                // Delivery time
                if (r.deliveryTime.isNotEmpty)
                  _infoChip(cs, Iconsax.clock, r.deliveryTime),
                // Distance
                if (r.distance.isNotEmpty)
                  _infoChip(cs, Iconsax.location, r.distance),
                // Delivery price
                if (r.deliveryPrice != null && r.deliveryPrice! > 0)
                  _infoChip(
                    cs,
                    Iconsax.car,
                    'توصيل ${r.deliveryPrice!.toStringAsFixed(0)} ر.ق',
                  ),
                // Status
                _infoChip(
                  cs,
                  r.isOpen ? Iconsax.tick_circle : Iconsax.close_circle,
                  r.isOpen ? 'مفتوح' : 'مغلق',
                  color: r.isOpen ? Colors.green : cs.error,
                ),
              ],
            ),

            // ── Description ──
            if (hasDesc) ...[
              SizedBox(height: 10.h),
              Divider(height: 1, color: cs.outlineVariant),
              SizedBox(height: 10.h),
              Text(
                r.description,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: cs.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _infoChip(
    ColorScheme cs,
    IconData icon,
    String label, {
    Color? color,
  }) {
    final effectiveColor = color ?? cs.primary;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: effectiveColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: effectiveColor),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: effectiveColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Order Options (from market delivery_types)
  // ─────────────────────────────────────────────
  static const _allDeliveryKeys = [
    'to_home',
    'book_table',
    'to_car',
    'throw_in',
    'at_provider',
  ];

  static const _deliveryMeta =
      <String, ({String title, String subtitle, String iconKey})>{
        'to_home': (title: 'توصيل', subtitle: 'يوصل طلبك', iconKey: 'motor'),
        'book_table': (
          title: 'حجز طاولة',
          subtitle: 'احجز جلستك',
          iconKey: 'table',
        ),
        'to_car': (
          title: 'إلى السيارة',
          subtitle: 'يوصلك الطلب',
          iconKey: 'car',
        ),
        'throw_in': (
          title: 'تناول هنا',
          subtitle: 'استلام',
          iconKey: 'delivery',
        ),
        'at_provider': (
          title: 'عند المزود',
          subtitle: 'استلام من المتجر',
          iconKey: 'delivery',
        ),
      };

  String _deliveryIcon(String key) {
    switch (_deliveryMeta[key]?.iconKey) {
      case 'motor':
        return Assets.images.detailsMotorIcon.path;
      case 'table':
        return Assets.images.detailsTableIcon.path;
      case 'car':
        return Assets.images.detailsCarIcon.path;
      default:
        return Assets.images.detailsDeliveryIcon.path;
    }
  }

  Widget _buildOrderOptions(ThemeData theme) {
    return Obx(() {
      final raw = controller.restorant.value.deliveryTypes;
      if (raw.isEmpty) return const SizedBox.shrink();

      final keys = raw.contains('all')
          ? _allDeliveryKeys
          : _allDeliveryKeys.where(raw.contains).toList();

      if (keys.isEmpty) return const SizedBox.shrink();

      final selectedKey = controller.selectedDeliveryType.value;

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            for (var i = 0; i < keys.length; i++) ...[
              if (i > 0) SizedBox(width: 8.w),
              Expanded(
                child: _OrderOption(
                  icon: _deliveryIcon(keys[i]),
                  title: _deliveryMeta[keys[i]]?.title ?? keys[i],
                  subtitle: _deliveryMeta[keys[i]]?.subtitle ?? '',
                  isSelected: selectedKey == keys[i],
                  onTap: () => controller.selectedDeliveryType.value = keys[i],
                ),
              ),
            ],
          ],
        ),
      );
    });
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
        Obx(
          () => ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.meals.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final meal = controller.meals[index];
              return GestureDetector(
                onTap: () => controller.openProduct(meal),
                child: Container(
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
                            child: CachedNetworkImage(
                              imageUrl: meal.image,
                              width: 120.w,
                              height: 100.w,
                              fit: BoxFit.fill,
                              errorWidget: (_, __, ___) => SizedBox(
                                width: 120.w,
                                height: 100.w,
                                child: Icon(Iconsax.shop, color: cs.primary),
                              ),
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  Reviews
  // ─────────────────────────────────────────────
  Widget _buildReviews(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(() {
      if (controller.reviews.isEmpty && !controller.isReviewsLoading.value) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Iconsax.star1, color: cs.primary, size: 18.sp),
                SizedBox(width: 6.w),
                Text(
                  'تقييمات',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(width: 8.w),
                if (controller.reviewsCount.value > 0)
                  Text(
                    '(${controller.reviewsCount.value}) • ${controller.reviewsAvg.value.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: cs.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10.h),
            if (controller.isReviewsLoading.value)
              const Center(child: CircularProgressIndicator())
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.reviews.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final review = controller.reviews[index];
                  return Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              review.userName,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Iconsax.star1,
                              size: 12.sp,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              review.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: cs.onSurface,
                              ),
                            ),
                          ],
                        ),
                        if (review.comment.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          Text(
                            review.comment,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: cs.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  Order Option Widget
// ─────────────────────────────────────────────
class _OrderOption extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onTap;

  const _OrderOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withValues(alpha: 0.1) : cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
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
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.bold,
                color: isSelected ? cs.primary : cs.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9.sp,
                color: isSelected
                    ? cs.primary.withValues(alpha: 0.7)
                    : cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
