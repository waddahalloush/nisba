import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'gift_details_controller.dart';

class GiftDetailsScreen extends GetView<GiftDetailsController> {
  const GiftDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: Obx(
          () => controller.isLoading.value
              ? Center(child: CircularProgressIndicator(color: cs.primaryFixed))
              : CustomScrollView(
                  slivers: [
                    // ── 1. الهيدر مع الكارد المتداخل (Stack & Positioned bottom -40) ──
                    SliverToBoxAdapter(child: _buildHeaderWithStackCard(theme)),

                    // ── 2. الفراغ الضامن لعدم التصاق باقي العناصر الكارد ──
                    SliverToBoxAdapter(child: SizedBox(height: 55.h)),

                    // ── 3. أزرار التبويبات (Group Buttons) ──
                    SliverToBoxAdapter(child: _buildCategoryTabs(theme)),

                    SliverToBoxAdapter(child: SizedBox(height: 20.h)),

                    // ── 4. عرض كافة أقسام الخدمات والمنتجات ──
                    ...controller.services.map(
                      (service) => SliverToBoxAdapter(
                        child: _buildServiceSection(service, theme),
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 30.h)),
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
              image: NetworkImage(controller.coverImageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // تدرج داكن لإبراز النصوص والأزرار
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
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
                            icon: Icon(Iconsax.heart, color: cs.primaryFixed),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // معلومات الاسم واللوجو داخل الصورة
              Positioned(
                bottom: 55.h,
                left: 16.w,
                right: 16.w,
                child: Row(
                  children: [
                    // لوجو المتجر
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
                            controller.shopName,
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
                              Text(
                                controller.location,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: cs.onPrimary.withValues(alpha: 0.7),
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
                  color: cs.shadow.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: controller.shopStats.map((stat) {
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
      case 'truck':
        return Iconsax.truck_fast;
      case 'star':
        return Iconsax.star1;
      case 'clock':
        return Iconsax.clock;
      case 'award':
        return Iconsax.award;
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
  //  عرض قسم الخدمة بالمنتجات المندرجة تحتها
  // ─────────────────────────────────────────────
  Widget _buildServiceSection(ShopService service, ThemeData theme) {
    final cs = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان الخدمة مع زر "عرض الكل"
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                  Text(service.title, style: theme.textTheme.titleSmall),
                ],
              ),
              Text(
                'عرض الكل',
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.primaryFixed,
                ),
              ),
            ],
          ),
        ),

        // قائمة المنتجات الأفقية الخاصة بهذه الخدمة
        SizedBox(
          height: 230.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: service.products.length,
            itemBuilder: (context, index) {
              final product = service.products[index];
              return _buildProductCard(product, theme);
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  بطاقة المنتج المصممة باحترافية
  // ─────────────────────────────────────────────
  Widget _buildProductCard(GiftProduct product, ThemeData theme) {
    final cs = theme.colorScheme;
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(left: 12.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
                child: Image.network(
                  product.imageUrl,
                  height: 110.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: cs.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.star1, color: cs.primary, size: 12.sp),
                      SizedBox(width: 2.w),
                      Text(
                        '${product.rating}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // التفاصيل
          Padding(
            padding: EdgeInsets.all(10.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  product.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontSize: 10.sp,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${product.price.toInt()} ر.ق',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: cs.primaryFixed,
                      ),
                    ),
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: cs.primaryFixed,
                      child: Icon(
                        Iconsax.add,
                        color: cs.onPrimaryFixed,
                        size: 16.sp,
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
}
