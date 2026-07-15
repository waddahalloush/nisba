import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/configs/theme_extensions.dart';

import 'mall_controller.dart';

class MallScreen extends GetView<MallController> {
  const MallScreen({super.key});

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
                'مولات',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              Text(
                'اكتشف افضل المولات القريبة منك',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Featured malls horizontal cards ──
                      _buildFeaturedMalls(theme),

                      SizedBox(height: 14.h),

                      // ── Search bar + filter ──
                      _buildSearchAndFilter(theme),

                      SizedBox(height: 14.h),

                      // ── Category chips ──
                      _buildCategoryChips(theme),

                      SizedBox(height: 12.h),

                      // ── Mall list ──
                      _buildMallList(theme),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Featured Malls Horizontal Scroll
  // ─────────────────────────────────────────────
  Widget _buildFeaturedMalls(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 190.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.featuredMalls.length,
        itemBuilder: (context, index) {
          final mall = controller.featuredMalls[index];
          return Container(
            width: 260.w,
            margin: EdgeInsets.only(left: 12.w),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ── Placeholder image ──
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cs.primary.withValues(alpha: 0.85),
                        cs.primary.withValues(alpha: 0.55),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Iconsax.shop,
                      color: cs.onPrimary.withValues(alpha: 0.25),
                      size: 80.sp,
                    ),
                  ),
                ),

                // ── Gradient overlay ──
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 110.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          cs.shadow.withValues(alpha: 0.75),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                // ── Content ──
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mall.name,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          _buildInfoChip(Iconsax.location, mall.distance, cs),
                          SizedBox(width: 8.w),
                          _buildInfoChip(Iconsax.star, '${mall.rating}', cs),
                          SizedBox(width: 8.w),
                          if (mall.hours != null)
                            _buildInfoChip(Iconsax.clock, mall.hours!, cs),
                        ],
                      ),
                    ],
                  ),
                ),

                // ── Rating badge ──
                Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
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
                          '${mall.rating}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: cs.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, ColorScheme cs) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: cs.onPrimary.withValues(alpha: 0.7), size: 11.sp),
        SizedBox(width: 3.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 10.sp,
            color: cs.onPrimary.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  Search Bar + Filter Button
  // ─────────────────────────────────────────────
  Widget _buildSearchAndFilter(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // ── Search field ──
          Expanded(
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
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'ابحث عن مول...',
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
          ),

          SizedBox(width: 10.w),

          // ── Filter button ──
          Container(
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: IconButton(
              onPressed: () {
                // TODO: open filter bottom sheet
              },
              icon: Icon(Iconsax.setting_4, color: cs.onPrimary, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Category Chips
  // ─────────────────────────────────────────────
  Widget _buildCategoryChips(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 38.h,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.categories.length,
          itemBuilder: (context, index) {
            final cat = controller.categories[index];
            final isSelected = controller.selectedCategory.value == cat;
            return Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: GestureDetector(
                onTap: () => controller.selectCategory(cat),
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
                    cat,
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
  //  Mall List
  // ─────────────────────────────────────────────
  Widget _buildMallList(ThemeData theme) {
    return Obx(() {
      final malls = controller.filteredMalls;

      if (malls.isEmpty) {
        return _buildEmptyState(theme);
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: malls.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            return _buildMallCard(theme, malls[index]);
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
            Iconsax.shop,
            size: 64.sp,
            color: cs.onSurface.withValues(alpha: 0.2),
          ),
          SizedBox(height: 14.h),
          Text(
            'لا توجد مولات',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Single Mall Card
  // ─────────────────────────────────────────────
  Widget _buildMallCard(ThemeData theme, Mall mall) {
    final cs = theme.colorScheme;

    return Container(
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
      child: Row(
        children: [
          // ── Mall image ──
          SizedBox(
            width: 110.w,
            height: 130.h,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        cs.primary.withValues(alpha: 0.85),
                        cs.primary.withValues(alpha: 0.5),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Iconsax.shop,
                      color: cs.onPrimary.withValues(alpha: 0.3),
                      size: 44.sp,
                    ),
                  ),
                ),
                // ── Distance badge ──
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.location,
                          color: cs.onPrimary,
                          size: 10.sp,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          mall.distance,
                          style: TextStyle(
                            fontSize: 10.sp,
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

          // ── Mall info ──
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + rating
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          mall.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: cs.primary.withAlpha(12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Iconsax.star1,
                              color:cs.primary,
                              size: 11.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              '${mall.rating}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Address
                  Text(
                    mall.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // Stats row
                  Row(
                    children: [
                      _buildStatChip(
                        Iconsax.shop,
                        '${mall.stores} متجر',
                        cs,
                        theme,
                      ),
                      SizedBox(width: 8.w),
                      _buildStatChip(
                        Iconsax.coffee,
                        '${mall.restaurants} مطعم',
                        cs,
                        theme,
                      ),
                      SizedBox(width: 8.w),
                      if (mall.hasCinema)
                        _buildStatChip(Iconsax.video, 'سينما', cs, theme),
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

  Widget _buildStatChip(
    IconData icon,
    String label,
    ColorScheme cs,
    ThemeData theme,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: cs.primary, size: 11.sp),
          SizedBox(width: 3.w),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
