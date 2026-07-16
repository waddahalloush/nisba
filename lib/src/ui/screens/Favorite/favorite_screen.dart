import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'favorite_controller.dart';

class FavoriteScreen extends GetView<FavoriteController> {
  const FavoriteScreen({super.key});

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
            icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
          ),
          title: Text(
            'المفضلة',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        body: Column(
          children: [
            // ── Tab bar ──
            _buildTabBar(theme),

            SizedBox(height: 14.h),

            // ── Favorite list ──
            Expanded(child: _buildFavoriteList(theme)),

            // ── Bottom CTA banner ──
            _buildBottomBanner(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(
        () => Container(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          decoration: BoxDecoration(
            color: cs.primary.withAlpha(12),
            borderRadius: BorderRadius.circular(45.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: _buildTab(
                  theme,
                  icon: Icons.restaurant_outlined,
                  label: 'المطاعم',
                  isSelected: controller.selectedTab.value == 0,
                  onTap: () => controller.selectTab(0),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _buildTab(
                  theme,
                  icon: Icons.soup_kitchen_outlined,
                  label: 'الوجبات',
                  isSelected: controller.selectedTab.value == 1,
                  onTap: () => controller.selectTab(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    ThemeData theme, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(45.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          spacing: 8.w,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? cs.onPrimary
                  : cs.onSurface.withValues(alpha: 0.6),
              size: 15.sp,
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? cs.onPrimary
                    : cs.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteList(ThemeData theme) {
    return Obx(
      () => ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.currentItems.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return _FavoriteCard(item: controller.currentItems[index]);
        },
      ),
    );
  }

  Widget _buildBottomBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                controller.selectedTab.value == 0 ? Iconsax.shop : Iconsax.cake,
                color: cs.primary,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 12.w),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.selectedTab.value == 0
                        ? 'إضافة مطاعمك المفضلة'
                        : 'إضافة مأكولاتك المفضلة',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    controller.selectedTab.value == 0
                        ? 'احفظ مطاعمك المفضلة للوصول السريع لها'
                        : 'احفظ وجباتك المفضلة للوصول السريع لها',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),

            // CTA button
            SizedBox(
              height: 38.h,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                child: Text(
                  'استكشف',
                  style: TextStyle(
                    fontSize: 11.sp,
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
}

class _FavoriteCard extends StatelessWidget {
  final FavoriteItem item;

  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      height: 110.h,
      padding: EdgeInsets.all(8.r),
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
          // ── Food image ──
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 120.w,
              height: double.infinity,
              child: Image.asset(item.imageUrl, fit: BoxFit.cover),
            ),
          ),

          // ── Content ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.primary.withAlpha(35),
                        ),
                        child: Icon(
                          item.isLiked ? Iconsax.heart5 : Iconsax.heart,
                          color: item.isLiked
                              ? cs.primary
                              : cs.onSurface.withValues(alpha: 0.3),
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Rating row
                  Row(
                    children: [
                      Icon(Iconsax.star1, color: cs.primary, size: 14.sp),
                      SizedBox(width: 3.w),
                      Text(
                        item.rating.toString(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                      SizedBox(width: 8.w),

                      // Tags
                      Expanded(
                        child: Text(
                          item.tags.join(' · '),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: cs.onSurface.withValues(alpha: 0.55),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),

                  // Delivery time
                  Row(
                    children: [
                      Icon(
                        Iconsax.clock,
                        color: cs.onSurface.withValues(alpha: 0.45),
                        size: 12.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        item.deliveryTime,
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
          ),
        ],
      ),
    );
  }
}
