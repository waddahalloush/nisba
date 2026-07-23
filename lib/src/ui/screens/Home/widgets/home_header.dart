import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/ui/screens/Home/controller/home_controller.dart';

/// الهيدر العلوي للشاشة الرئيسية - SliverAppBar متدرج مع بانر وبحث
class HomeHeader extends StatelessWidget {
  final HomeController controller;

  const HomeHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 316.h,
      automaticallyImplyLeading: false,
      backgroundColor: primaryColor,
      elevation: 0,
      title: _buildTitleBar(theme),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: _buildFlexibleBackground(context, theme, primaryColor),
      ),
    );
  }

  /// شريط العنوان (عربة التسوق + الموقع + صورة البروفايل)
  Widget _buildTitleBar(ThemeData theme) {
    final onPrimary = theme.colorScheme.onPrimary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // البروفايل مع شارة PRO
        GestureDetector(
          onTap: () {
            Get.toNamed(AppRoutesNames.userAccount);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: onPrimary.withValues(alpha: 0.24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.r),
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=150&q=80',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -4.h,
                right: -4.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppColors.star,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'PRO',
                    style: TextStyle(
                      fontSize: 7.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // العنوان (Pill)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: onPrimary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: onPrimary.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Icon(Iconsax.location, color: onPrimary, size: 12.sp),
              SizedBox(width: 4.w),
              Text(
                'توصيل إلى: حي النرجس، الرياض',
                style: TextStyle(
                  color: onPrimary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 2.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: onPrimary,
                size: 12.sp,
              ),
            ],
          ),
        ),
        // السلة مع الإشعار
        Row(
          spacing: 4.w,
          children: [
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutesNames.notification);
              },
              child: Stack(
                children: [
                  Icon(Iconsax.notification, color: onPrimary, size: 22.sp),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: theme.colorScheme.onError,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutesNames.cart);
              },
              child: Stack(
                children: [
                  Icon(Iconsax.shopping_cart, color: onPrimary, size: 22.sp),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '2',
                        style: TextStyle(
                          color: theme.colorScheme.onError,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// الخلفية المرنة (التدرج + البحث + البانر)
  Widget _buildFlexibleBackground(
    BuildContext context,
    ThemeData theme,
    Color primaryColor,
  ) {
    final onPrimary = theme.colorScheme.onPrimary;
    final onSurface = theme.colorScheme.onSurface;
    final surface = theme.colorScheme.surface;

    return Stack(
      children: [
        // الخلفية ذات التدرج الانسيابي المشع
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.lighten(primaryColor, 0.35),
                  AppColors.lighten(primaryColor, 0.20),
                  primaryColor,
                  AppColors.lighten(primaryColor, 0.10),
                  surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.2, 0.4, 0.65, 0.95],
              ),
            ),
          ),
        ),
        // تركيب العناصر فوق التدرج اللوني
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
              ),
              // [ب] السيرش بار
              TextFormField(
                decoration: InputDecoration(
                  fillColor: surface,
                  filled: true,
                  hintText: 'ابحث عن المطاعم، الوجبات، أو المقادير...',
                  hintStyle: TextStyle(
                    color: onSurface.withValues(alpha: 0.55),
                    fontSize: 11.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.r),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: Icon(
                    Iconsax.search_normal_1,
                    color: onSurface.withValues(alpha: 0.87),
                    size: 18.sp,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              // [ج] بانر كارد - يتلاشى تدريجياً عند السحب للأعلى
              Obx(
                () => AnimatedOpacity(
                  duration: const Duration(milliseconds: 150),
                  opacity: (1.0 - (controller.scrollOffset.value / 200.h))
                      .clamp(0.0, 1.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Container(
                      height: 180.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: onPrimary),
                      ),
                      child: Stack(
                        children: [
                          // صورة العرض متراكبة في اليسار (RTL)
                          Positioned(
                            right: 0.w,
                            bottom: 0,
                            top: 0,
                            child: SizedBox(
                              width: 220.w,
                              height: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(16.r),
                                ),
                                child: Assets.images.bannerImg.image(
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          // التدرج اللوني المتراكب
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16.r),
                              ),
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor,
                                  primaryColor,
                                  primaryColor,
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.25, 0.40, 1.0],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                          // النصوص وزر اشترك الآن
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          'NISBAA',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: onPrimary,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'REWARDS',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: onPrimary,
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.star_rounded,
                                      color: onPrimary,
                                      size: 12.sp,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  'كافئ نفسك بخصم',
                                  style: TextStyle(
                                    color: onPrimary,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '40%',
                                  style: TextStyle(
                                    color: onPrimary,
                                    fontSize: 36.sp,
                                    fontWeight: FontWeight.w600,
                                    height: 0.95,
                                  ),
                                ),
                                Text(
                                  'على طلبك التالي!',
                                  style: TextStyle(
                                    color: onPrimary,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                    vertical: 6.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.darken(primaryColor, 0.25),
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: Text(
                                    'اشترك الآن',
                                    style: TextStyle(
                                      color: onPrimary,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Dots Indicator
                          Positioned(
                            bottom: 12.h,
                            right: 0,
                            left: 0,
                            child: Obx(
                              () => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(4, (index) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 2.w,
                                    ),
                                    width:
                                        controller.currentBannerIndex.value ==
                                            index
                                        ? 14.w
                                        : 5.w,
                                    height: 5.h,
                                    decoration: BoxDecoration(
                                      color:
                                          controller.currentBannerIndex.value ==
                                              index
                                          ? onPrimary
                                          : onPrimary.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
