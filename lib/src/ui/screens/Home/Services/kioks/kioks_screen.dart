import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/configs/theme_extensions.dart';

import 'kioks_controller.dart';

class KioksScreen extends GetView<KioksController> {
  const KioksScreen({super.key});

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
                'المناطق',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              Text(
                'استكشف المناطق وتعرف على خدماتها',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {
                // TODO: open notifications
              },
              icon: Icon(Iconsax.notification, color: cs.onSurface),
            ),
          ],
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Search bar ──
                      _buildSearchBar(theme),

                      SizedBox(height: 12.h),

                      // ── Location banner ──
                      _buildLocationBanner(theme),

                      SizedBox(height: 14.h),

                      // ── Category chips ──
                      _buildCategoryChips(theme),

                      SizedBox(height: 14.h),

                      // ── Kiosk cards grid ──
                      _buildKioskGrid(theme),

                      SizedBox(height: 20.h),

                      // ── Top rated section ──
                      _buildTopRatedSection(theme),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Search Bar
  // ─────────────────────────────────────────────
  Widget _buildSearchBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
          style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
          decoration: InputDecoration(
            hintText: 'ابحث عن منطقة...',
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
    );
  }

  // ─────────────────────────────────────────────
  //  Location Banner
  // ─────────────────────────────────────────────
  Widget _buildLocationBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [cs.primary, cs.primary.withValues(alpha: 0.8)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            // ── Map pin icon ──
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: cs.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(Iconsax.location, color: cs.onPrimary, size: 26.sp),
            ),
            SizedBox(width: 14.w),

            // ── Text ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'اكتشف منطقتك',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'فعّل الموقع لتصفح المناطق القريبة منك',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: cs.onPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),

            // ── Allow button ──
            SizedBox(
              height: 36.h,
              child: ElevatedButton(
                onPressed: () {
                  // TODO: request location permission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.onPrimary,
                  foregroundColor: cs.primary,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: Text(
                  'السماح بالموقع',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
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
  //  Kiosk Grid
  // ─────────────────────────────────────────────
  Widget _buildKioskGrid(ThemeData theme) {
    return Obx(() {
      final kiosks = controller.filteredKiosks;

      if (kiosks.isEmpty) {
        return _buildEmptyState(theme);
      }

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.72,
          ),
          itemCount: kiosks.length,
          itemBuilder: (context, index) {
            return _buildKioskCard(theme, kiosks[index]);
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
            'لا توجد مناطق',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  Single Kiosk Card
  // ─────────────────────────────────────────────
  Widget _buildKioskCard(ThemeData theme, Kiosk kiosk) {
    final cs = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14.r),
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
          // ── Image ──
          SizedBox(
            height: 110.h,
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
                      size: 40.sp,
                    ),
                  ),
                ),

                // ── Rating badge ──
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Iconsax.star1, color: cs.onPrimary, size: 10.sp),
                        SizedBox(width: 3.w),
                        Text(
                          '${kiosk.rating}',
                          style: TextStyle(
                            fontSize: 10.sp,
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
          ),

          // ── Info ──
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kiosk.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 3.h),
                Row(
                  children: [
                    Icon(
                      Iconsax.location,
                      color: cs.onSurface.withValues(alpha: 0.4),
                      size: 11.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      kiosk.city,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Iconsax.star1,
                      color: cs.primary,
                      size: 12.sp,
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '${kiosk.rating}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Text(
                      '(${kiosk.reviewCount})',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.45),
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

  // ─────────────────────────────────────────────
  //  Top Rated Section
  // ─────────────────────────────────────────────
  Widget _buildTopRatedSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Section header ──
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                'الأعلى تقييماً',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // TODO: navigate to "show all" or scroll to grid
                },
                child: Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: cs.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        // ── Top rated horizontal list ──
        SizedBox(
          height: 200.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: controller.topRatedKiosks.length,
            itemBuilder: (context, index) {
              final kiosk = controller.topRatedKiosks[index];
              return Container(
                width: 150.w,
                margin: EdgeInsets.only(left: 10.w),
                child: _buildKioskCard(theme, kiosk),
              );
            },
          ),
        ),
      ],
    );
  }
}
