// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/models/product_model.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

class HomeMeals extends StatelessWidget {
  final String title;
  const HomeMeals({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SliverPadding(
      padding: EdgeInsets.only(top: 10.h),
      sliver: SliverToBoxAdapter(
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
                    title,
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
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: [
                  _buildCard(
                    theme,
                    primaryColor,
                    'كريسبي دجاج',
                    '25 ر.ق',
                    '76 ر.ق',
                    '25%',
                    '330 دقيقة • 1.2 كم',
                    Assets.images.homeMeals1.path,
                  ),
                  _buildCard(
                    theme,
                    primaryColor,
                    'بروستد مقرمش',
                    '25 ر.ق',
                    '59 ر.ق',
                    '25%',
                    '395 دقيقة • 1.5 كم',
                    Assets.images.homeMeals2.path,
                  ),
                  _buildCard(
                    theme,
                    primaryColor,
                    'زنجر سبايسي',
                    '25 ر.ق',
                    '49 ر.ق',
                    '25%',
                    '330 دقيقة • 1.1 كم',
                    Assets.images.homeMeals3.path,
                  ),
                ],
              ),
            ),
          ],
        ),
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
        final product = Product(
          name: title,
          description: title,
          price: double.tryParse(price.replaceAll(' ر.ق', '')) ?? 0,
          oldPrice: double.tryParse(oldPrice.replaceAll(' ر.ق', '')) ?? 0,
          savings: savings,
          deliveryTime: deliveryMeta.split(' ').first,
          distance: deliveryMeta.split('•').last.trim().split(' ').first,
          imagePath: imageUrl,
          rating: 4.8,
          ratingCount: 253,
        );
        Get.toNamed(AppRoutesNames.productDetails, arguments: product);
      },
      child: Container(
        width: 200.w,
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
                  borderRadius: BorderRadius.circular(16.r),
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
                      "خصم\n$savings",
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
