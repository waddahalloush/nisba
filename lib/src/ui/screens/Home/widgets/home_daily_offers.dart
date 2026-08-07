// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/ui/screens/Home/Products/ProductDetails/product_details_controller.dart';

import '../../../../data/models/Home/home_model.dart';

/// قسم عروض أفقي قابل لإعادة الاستخدام مع كروت المنتجات
class HomeDailyOffers extends StatelessWidget {
  final String title;
  final List<OfferProduct> productList;

  const HomeDailyOffers({
    super.key,
    required this.title,
    required this.productList,
  });

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
                  // Text(
                  //   'عرض الكل',
                  //   style: TextStyle(
                  //     color: primaryColor,
                  //     fontSize: 12.sp,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
            // قائمة أفقية للعروض
            SizedBox(
              height: 156.h,
              child: ListView.builder(
                reverse: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                itemCount: productList.length,
                itemBuilder: (context, index) =>
                    _buildCard(theme, primaryColor, productList[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(ThemeData theme, Color primaryColor, OfferProduct product) {
    final onSurface = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        if (Get.isRegistered<ProductDetailsController>()) {
          Get.delete<ProductDetailsController>(force: true);
        }
        Get.toNamed(AppRoutesNames.productDetails, arguments: product);
      },
      child: Container(
        width: 150.w,
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
                  child: CachedNetworkImage(
                    height: 95.h,
                    width: double.infinity,
                    imageUrl: product.image,
                    fit: BoxFit.cover,
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
                      _buildSavingsText(product.price, product.oldPrice),
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
                    product.name,
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
                        '${product.oldPrice} ر.ق',
                        style: TextStyle(
                          color: onSurface.withValues(alpha: 0.45),
                          fontSize: 10.sp,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      Text(
                        '${product.price} ر.ق',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      product.status.desc,
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

/// Calculates savings percentage from price and oldPrice strings.
String _buildSavingsText(String priceStr, String oldPriceStr) {
  final price = double.tryParse(priceStr);
  final oldPrice = double.tryParse(oldPriceStr);
  if (price == null || oldPrice == null || oldPrice <= 0 || price >= oldPrice) {
    return 'وفر';
  }
  final savingsPercent = ((oldPrice - price) / oldPrice * 100).round();
  return 'وفر\n$savingsPercent%';
}
