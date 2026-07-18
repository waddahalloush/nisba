import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../../data/models/service_model.dart';
import '../../../../../routes/routes_names.dart';
import 'base_service_controller.dart';

class BaseServiceScreen<T extends BaseServiceController> extends GetView<T> {
  final String title;
  final String subtitle;
  final String searchHint;

  const BaseServiceScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.searchHint,
  });

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                ),
              ),
              Text(
                subtitle,
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
                      // 1. العناصر المميزة
                      if (controller.featuredItems.isNotEmpty)
                        _buildFeaturedSection(theme),

                      SizedBox(height: 14.h),

                      // 2. شريط البحث والفلترة
                      _buildSearchAndFilter(theme),

                      SizedBox(height: 14.h),

                      // 3. أزرار الفئات
                      _buildCategoryChips(theme),

                      SizedBox(height: 12.h),

                      // 4. القائمة الأساسية
                      _buildMainList(theme),

                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // ── التمرير الأفقي للأماكن المميزة ──
  Widget _buildFeaturedSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            spacing: 4,
            children: [
              Icon(Iconsax.location, color: cs.primary, size: 16.sp),
              Text(
                "القريبة منك",
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            itemCount: controller.featuredItems.length,
            itemBuilder: (context, index) {
              final item = controller.featuredItems[index];
              return InkWell(
                onTap: () {
                  // Get.toNamed(
                  //   AppRoutesNames
                  //       .placeDetails, // تأكد من إضافة هذا الروت في ملف الروابط
                  //   arguments: item, // نمرر كائن الـ BaseServiceItem بالكامل
                  // );
                },
                child: Container(
                  width: Get.width / 2.5,
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
                      Expanded(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16.r),
                              ),
                              child: Image.asset(
                                item.imageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.r),
                                      color: cs.primary,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Iconsax.location,
                                          color: cs.onPrimary,
                                          size: 12.sp,
                                        ),
                                        SizedBox(width: 3.w),
                                        Text(
                                          item.distance,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: cs.onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Iconsax.heart, color: cs.primary),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              item.address,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurface,
                                fontSize: 10.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  item.rating.toString(),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: cs.primary,
                                  ),
                                ),
                                SizedBox(width: 3.w),
                                Icon(
                                  Iconsax.star1,
                                  color: cs.primary,
                                  size: 14.sp,
                                ),
                              ],
                            ),
                            if (item.hours != null) ...[
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.timer_14,
                                    color: cs.onSurface,
                                    size: 12.sp,
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    item.hours!,
                                    style: TextStyle(
                                      fontSize: 9.sp,
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  // ── شريط البحث والفلترة ──
  Widget _buildSearchAndFilter(ThemeData theme) {
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(25.r),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.07),
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
                  hintText: searchHint,
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
          Container(
            height: 48.h,
            width: 48.w,
            decoration: BoxDecoration(
              color: cs.onPrimary,
              borderRadius: BorderRadius.circular(30.r),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.setting_4, color: cs.primary, size: 20.sp),
            ),
          ),
        ],
      ),
    );
  }

  // ── الفئات (Chips) ──
  Widget _buildCategoryChips(ThemeData theme) {
    final cs = theme.colorScheme;

    return SizedBox(
      height: 42.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 3.h),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          final isSelected = controller.selectedCategory.value == cat.name;
          return Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: GestureDetector(
              onTap: () => controller.selectCategory(cat.name),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isSelected ? cs.primary : cs.surface,
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(
                    color: isSelected ? cs.primary : cs.outlineVariant,
                    width: 1,
                  ),
                ),
                child: Row(
                  spacing: 4.w,
                  children: [
                    Icon(
                      cat.icon,
                      color: isSelected ? cs.onPrimary : cs.outlineVariant,
                      size: 16.sp,
                    ),
                    Text(
                      cat.name,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected ? cs.onPrimary : cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── القائمة الأساسية ──
  Widget _buildMainList(ThemeData theme) {
    final items = controller.filteredItems;

    if (items.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 60.h),
        child: Column(
          children: [
            Icon(
              Iconsax.search_status,
              size: 64.sp,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
            SizedBox(height: 14.h),
            Text(
              'لا توجد نتائج مطابقة لبحثك',
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) => _buildCard(theme, items[index]),
      ),
    );
  }

  // ── كارت الخدمة ──
  Widget _buildCard(ThemeData theme, BaseServiceItem item) {
    final cs = theme.colorScheme;

    return InkWell(
      onTap: () {
        // Get.toNamed(
        //   AppRoutesNames.placeDetails, // تأكد من إضافة هذا الروت في ملف الروابط
        //   arguments: item, // نمرر كائن الـ BaseServiceItem بالكامل
        // );
      },
      child: Container(
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
            SizedBox(
              width: 130.w,
              height: 130.h,
              child: Image.asset(item.imageUrl, fit: BoxFit.cover),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Icon(Iconsax.heart, color: cs.primary),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      item.address,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // عرض الخصائص الديناميكية المخصصة لكل شاشة
                    if (item.features != null)
                      Wrap(
                        children: item.features!
                            .map(
                              (f) => Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      f.icon,
                                      color: cs.primary,
                                      size: 11.sp,
                                    ),
                                    SizedBox(width: 3.w),
                                    Flexible(
                                      child: Text(
                                        f.label,
                                        style: TextStyle(fontSize: 10.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${item.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Icon(Iconsax.star1, color: cs.primary, size: 11.sp),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 4.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: cs.primary, width: 0.5),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Iconsax.location,
                                color: cs.primary,
                                size: 11.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                item.distance,
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  color: cs.primary,
                                ),
                              ),
                            ],
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
  }
}
