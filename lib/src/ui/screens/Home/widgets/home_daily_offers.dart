import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// قسم "عروض اليوم القريبة منك" مع كروت المنتجات الأفقية
class HomeDailyOffers extends StatelessWidget {
  const HomeDailyOffers({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صف العنوان
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عروض اليوم القريبة منك',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  'عرض الكل',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // قائمة أفقية للعروض
          SizedBox(
            height: 156.h,
            child: ListView(
              reverse: true,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              children: [
                _buildCard(
                  theme,
                  primaryColor,
                  'شواية الخليج',
                  '53 ر.ق',
                  '76 ر.ق',
                  '25%',
                  '330 دقيقة • 1.2 كم',
                  Assets.images.offer1.path,
                ),
                _buildCard(
                  theme,
                  primaryColor,
                  'سوشي يوشي',
                  '44 ر.ق',
                  '59 ر.ق',
                  '25%',
                  '395 دقيقة • 1.5 كم',
                  Assets.images.offer2.path,
                ),
                _buildCard(
                  theme,
                  primaryColor,
                  'باستا ريمو',
                  '37 ر.ق',
                  '49 ر.ق',
                  '25%',
                  '330 دقيقة • 1.1 كم',
                  Assets.images.offer3.path,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    ThemeData theme,
    Color primaryColor,
    String title,
    String price,
    String oldPrice,
    String savings,
    String deliveryMeta,
    String imageUrl,
  ) {
    final onSurface = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutesNames.productDetails);
      },
      child: Container(
        width: 120.w,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.025),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                  ),
                  child: SizedBox(
                    height: 95.h,
                    width: double.infinity,
                    child: Image.asset(imageUrl, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      "وفر\n$savings",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 9.sp,
                      color: onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        oldPrice,
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.45),
                          fontSize: 10.sp,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      deliveryMeta,
                      style: TextStyle(
                        color: onSurface.withValues(alpha: 0.5),
                        fontSize: 9.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
