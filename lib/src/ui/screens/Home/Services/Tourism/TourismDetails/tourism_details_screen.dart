import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'tourism_details_controller.dart';

class TourismDetailsScreen extends GetView<TourismDetailsController> {
  const TourismDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,

        // ── زر "حجز الآن" المثبت بأسفل الشاشة ──
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: cs.surface,
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.06),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'التكلفة الكلية',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10.sp,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        '250 ر.ق',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: cs.primary,
                        ),
                      ),
                      Text(
                        ' / للشخص',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10.sp,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.bookNow(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'حجز الرحلة الآن',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        body: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator(color: cs.primary))
              : CustomScrollView(
                  slivers: [
                    // ── 1. الهيدر مع الكارد المتداخل (Stack & Positioned bottom -40) ──
                    SliverToBoxAdapter(child: _buildHeaderWithStackCard(theme)),

                    // ── 2. الفراغ الضامن لعدم التصاق العناصر بالكارد ──
                    SliverToBoxAdapter(child: SizedBox(height: 55.h)),

                    // ── 3. أزرار التبويبات (Group Buttons) ──
                    SliverToBoxAdapter(child: _buildCategoryTabs(theme)),

                    SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                    // ── 4. محتوى الشاشة بناءً على الأقسام المحددة ──
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // قسم: نبذة عن المكان
                            _buildAboutSection(theme),
                            SizedBox(height: 24.h),

                            // قسم: برنامج الرحلة
                            _buildItinerarySection(theme),
                            SizedBox(height: 24.h),

                            // قسم: مرشد سياحي خاص
                            _buildGuideSection(theme),
                            SizedBox(height: 24.h),

                            // قسم: الفعاليات والنشاطات
                            _buildActivitiesSection(theme),
                            SizedBox(height: 30.h),
                          ],
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
  //  الهيدر مع الكارد المتداخل (Header Stack)
  // ─────────────────────────────────────────────
  Widget _buildHeaderWithStackCard(ThemeData theme) {
    final cs = theme.colorScheme;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // ── خلفية الصورة الرئيسية ──
        Container(
          height: 300.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.r),
              bottomRight: Radius.circular(28.r),
            ),
            image: DecorationImage(
              image: AssetImage(controller.coverImageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // تدرج داكن لإبراز النصوص والأزرار العلوية
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.75),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(28.r),
                    bottomRight: Radius.circular(28.r),
                  ),
                ),
              ),

              // الأزرار العلوية (رجوع، مشاركة، مفضلة)
              Positioned(
                top: 50.h,
                left: 16.w,
                right: 16.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundColor: cs.surface,
                      child: IconButton(
                        icon: Icon(Iconsax.arrow_right_1, color: cs.onSurface),
                        onPressed: () => Get.back(),
                      ),
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: cs.surface,
                          child: IconButton(
                            icon: Icon(Iconsax.share, color: cs.onSurface),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 8.w),
                        CircleAvatar(
                          backgroundColor: cs.surface,
                          child: IconButton(
                            icon: Icon(Iconsax.heart, color: cs.error),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // معلومات الاسم واللوجو والموقع
              Positioned(
                bottom: 55.h,
                left: 16.w,
                right: 16.w,
                child: Row(
                  children: [
                    // لوجو الوجهة السياحية
                    Container(
                      width: 65.w,
                      height: 65.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: cs.surface, width: 2),
                        image: DecorationImage(
                          image: NetworkImage(controller.logoImageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // تفاصيل الاسم والموقع
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.destinationName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: cs.onPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Iconsax.location,
                                color: cs.onPrimary.withValues(alpha: 0.7),
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  controller.location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: cs.onPrimary.withValues(alpha: 0.7),
                                  ),
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
            ],
          ),
        ),

        // ── الكارد المتداخل المميز (Positioned bottom: -40) ──
        Positioned(
          bottom: -40.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            height: 85.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: cs.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: cs.shadow.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: controller.destinationStats.map((stat) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getStatIcon(stat['icon']!),
                      color: cs.primary,
                      size: 20.sp,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      stat['value']!,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      stat['title']!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10.sp,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getStatIcon(String icon) {
    switch (icon) {
      case 'ticket':
        return Iconsax.ticket;
      case 'star':
        return Iconsax.star1;
      case 'clock':
        return Iconsax.clock;
      case 'location':
        return Iconsax.location;
      default:
        return Iconsax.info_circle;
    }
  }

  // ─────────────────────────────────────────────
  //  أزرار التبويبات (Group Buttons)
  // ─────────────────────────────────────────────
  Widget _buildCategoryTabs(ThemeData theme) {
    final cs = theme.colorScheme;
    return SizedBox(
      height: 42.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          final isSelected = controller.selectedTab.value == category;
          return GestureDetector(
            onTap: () => controller.selectTab(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(left: 8.w),
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? cs.primary : cs.surface,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: isSelected ? cs.primary : cs.outline,
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
                category,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? cs.onPrimary : cs.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  1. قسم: نبذة عن المكان
  // ─────────────────────────────────────────────
  Widget _buildAboutSection(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('نبذة عن المكان', theme),
        SizedBox(height: 8.h),
        Text(
          controller.aboutText,
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.78),
            height: 1.6,
          ),
        ),
        SizedBox(height: 12.h),
        Column(
          children: controller.highlights.map((highlight) {
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  Icon(Iconsax.tick_circle, color: cs.primary, size: 16.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      highlight,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  2. قسم: برنامج الرحلة (Itinerary)
  // ─────────────────────────────────────────────
  Widget _buildItinerarySection(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('برنامج الرحلة المقترح', theme),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.itinerarySteps.length,
          itemBuilder: (context, index) {
            final step = controller.itinerarySteps[index];
            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Row(
                children: [
                  Container(
                    width: 45.w,
                    height: 45.h,
                    decoration: BoxDecoration(
                      color: cs.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      _getItineraryIcon(step.iconName),
                      color: cs.primary,
                      size: 22.sp,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              step.title,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                            Text(
                              step.time,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: cs.primary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          step.description,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontSize: 10.sp,
                            color: cs.onSurface.withValues(alpha: 0.55),
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
      ],
    );
  }

  IconData _getItineraryIcon(String icon) {
    switch (icon) {
      case 'building':
        return Iconsax.building;
      case 'coffee':
        return Iconsax.coffee;
      case 'gallery':
        return Iconsax.gallery;
      case 'ship':
        return Iconsax.ship;
      default:
        return Iconsax.calendar;
    }
  }

  // ─────────────────────────────────────────────
  //  3. قسم: مرشد سياحي خاص
  // ─────────────────────────────────────────────
  Widget _buildGuideSection(ThemeData theme) {
    final cs = theme.colorScheme;
    final guide = controller.privateGuide;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('مرشد سياحي خاص بالرحلة', theme),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: cs.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Image.network(
                  guide.imageUrl,
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          guide.name,
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Iconsax.star1, color: cs.primary, size: 14.sp),
                            SizedBox(width: 2.w),
                            Text(
                              '${guide.rating}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      guide.title,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10.sp,
                        color: cs.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Iconsax.translate, color: cs.primary, size: 14.sp),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            guide.languages,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 10.sp,
                              color: cs.onSurface.withValues(alpha: 0.78),
                            ),
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
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  4. قسم: الفعاليات والنشاطات
  // ─────────────────────────────────────────────
  Widget _buildActivitiesSection(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('الفعاليات والنشاطات التفاعلية', theme),
        SizedBox(height: 12.h),
        SizedBox(
          height: 220.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.activities.length,
            itemBuilder: (context, index) {
              final activity = controller.activities[index];
              return Container(
                width: 165.w,
                margin: EdgeInsets.only(left: 12.w),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(18.r),
                      ),
                      child: Image.network(
                        activity.imageUrl,
                        height: 100.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            activity.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            activity.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontSize: 9.sp,
                              color: cs.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${activity.price.toInt()} ر.ق',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.clock,
                                    size: 11.sp,
                                    color: cs.onSurface.withValues(alpha: 0.55),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    activity.duration,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      fontSize: 9.sp,
                                      color: cs.onSurface.withValues(
                                        alpha: 0.55,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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

  // عنصر مساعدة لرأس كل قسم
  Widget _buildSectionHeader(String title, ThemeData theme) {
    final cs = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 18.h,
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(fontSize: 15.sp),
        ),
      ],
    );
  }
}
