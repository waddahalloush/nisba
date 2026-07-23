import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'beauty_details_controller.dart';

class BeautyDetailsScreen extends GetView<BeautyDetailsController> {
  const BeautyDetailsScreen({super.key});

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
                    'الإجمالي المتوقع',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 10.sp,
                      color: cs.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Obx(
                    () => Text(
                      '${controller.totalPrice.toInt()} ر.ق',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: cs.primaryFixed,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => controller.bookNow(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primaryFixed,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'حجز موعد الآن',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onPrimaryFixed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        body: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator(color: cs.primaryFixed))
              : CustomScrollView(
                  slivers: [
                    // ── 1. الهيدر مع الكارد المتداخل (Stack & Positioned bottom -40) ──
                    SliverToBoxAdapter(child: _buildHeaderWithStackCard(theme)),

                    // ── 2. الفراغ الضامن لعدم التصاق العناصر بالكارد ──
                    SliverToBoxAdapter(child: SizedBox(height: 55.h)),

                    // ── 3. أزرار التبويبات (Group Buttons) ──
                    SliverToBoxAdapter(child: _buildCategoryTabs(theme)),

                    SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                    // ── 4. محتوى الشاشة التفصيلي ──
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. نبذة عن المكان
                            _buildAboutSection(theme),
                            SizedBox(height: 24.h),

                            // 2. الخدمات التي يقدمها المركز والتسعير (ر.ق)
                            _buildServicesSection(theme),
                            SizedBox(height: 24.h),

                            // 3. أقسام المركز
                            _buildDepartmentsSection(theme),
                            SizedBox(height: 24.h),

                            // 4. ساعات العمل والتقييم التفصيلي
                            _buildWorkingHoursAndRatingSection(theme),
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
        // ── صورة غلاف المركز ──
        Container(
          height: 300.h,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.r),
              bottomRight: Radius.circular(28.r),
            ),
            image: DecorationImage(
              image: NetworkImage(controller.coverImageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // تدرج لوني لإبراز النصوص والأزرار
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

              // أزرار التحكم العلوية
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

              // شعار واسم مركز التجميل
              Positioned(
                bottom: 55.h,
                left: 16.w,
                right: 16.w,
                child: Row(
                  children: [
                    // اللوجو
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
                    // الاسم والموقع
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.centerName,
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

        // ── الكارد المتداخل في المنتصف (Positioned bottom: -40) ──
        Positioned(
          bottom: -40.h,
          left: 16.w,
          right: 16.w,
          child: Container(
            height: 85.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
              children: controller.centerStats.map((stat) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getStatIcon(stat['icon']!),
                      color: cs.primaryFixed,
                      size: 20.sp,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      stat['value']!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      stat['title']!,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 9.sp,
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
      case 'star':
        return Iconsax.star1;
      case 'like':
        return Iconsax.like_1;
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
                color: isSelected ? cs.primaryFixed : cs.surface,
                borderRadius: BorderRadius.circular(22.r),
                border: Border.all(
                  color: isSelected ? cs.primaryFixed : cs.outline,
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: cs.primaryFixed.withValues(alpha: 0.3),
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
                  color: isSelected ? cs.onPrimaryFixed : cs.onSurface,
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
        _buildSectionHeader('نبذة عن المركز', theme),
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
          children: controller.centerHighlights.map((highlight) {
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  Icon(Iconsax.verify, color: cs.primaryFixed, size: 16.sp),
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
  //  2. قسم: الخدمات المتاحة والتسعير (ر.ق)
  // ─────────────────────────────────────────────
  Widget _buildServicesSection(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('الخدمات والتسعير (ر.ق)', theme),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            final service = controller.services[index];
            return Obx(() {
              final isSelected =
                  controller.selectedServiceId.value == service.id;
              return GestureDetector(
                onTap: () => controller.selectService(service.id),
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? cs.primaryFixed.withValues(alpha: 0.05)
                        : cs.surface,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isSelected ? cs.primaryFixed : cs.outlineVariant,
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          service.imageUrl,
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
                            Text(
                              service.name,
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              service.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontSize: 10.sp,
                                color: cs.onSurface.withValues(alpha: 0.55),
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${service.price.toInt()} ر.ق',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.bold,
                                    color: cs.primaryFixed,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Iconsax.clock,
                                      size: 12.sp,
                                      color: cs.onSurface.withValues(
                                        alpha: 0.55,
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      service.duration,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            fontSize: 10.sp,
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
                ),
              );
            });
          },
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  3. قسم: أقسام المركز
  // ─────────────────────────────────────────────
  Widget _buildDepartmentsSection(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('أقسام السبا والمركز', theme),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.3,
          ),
          itemCount: controller.departments.length,
          itemBuilder: (context, index) {
            final dept = controller.departments[index];
            return Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: cs.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: cs.primaryFixed.withValues(alpha: 0.1),
                    child: Icon(
                      _getDeptIcon(dept.iconName),
                      color: cs.primaryFixed,
                      size: 18.sp,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    dept.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${dept.servicesCount} خدمات متاحة',
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9.sp,
                      color: cs.onSurface.withValues(alpha: 0.55),
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

  IconData _getDeptIcon(String icon) {
    switch (icon) {
      case 'magicpen':
        return Iconsax.magicpen;
      case 'award':
        return Iconsax.award;
      case 'sun':
        return Iconsax.sun_1;
      case 'scissor':
        return Iconsax.scissor;
      default:
        return Iconsax.element_4;
    }
  }

  // ─────────────────────────────────────────────
  //  4. قسم: ساعات العمل والتقييم التفصيلي
  // ─────────────────────────────────────────────
  Widget _buildWorkingHoursAndRatingSection(ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('ساعات العمل والتقييمات', theme),
        SizedBox(height: 12.h),

        // كارد التقييم وساعات العمل
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: cs.outlineVariant),
          ),
          child: Column(
            children: [
              // ساعات العمل
              Row(
                children: [
                  Icon(Iconsax.clock, color: cs.primaryFixed, size: 20.sp),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'أوقات العمل الرسمية',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.55),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          controller.workingHours,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: cs.primaryFixed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      'مفتوح الآن',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontSize: 10.sp,
                        color: cs.primaryFixed,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Divider(
                height: 24.h,
                thickness: 1,
                color: cs.surfaceContainerHighest,
              ),

              // ملخص التقييمات من 5 وعدد التقييمات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${controller.rating}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontSize: 24.sp,
                            ),
                          ),
                          Text(
                            ' / 5',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              color: cs.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Iconsax.star1,
                            color: cs.primary,
                            size: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'إجمالي التقييمات',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10.sp,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${controller.reviewsCount} تقييم حقيقي',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primaryFixed,
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
            color: cs.primaryFixed,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}
