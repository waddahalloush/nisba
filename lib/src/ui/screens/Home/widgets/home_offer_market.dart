// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/ui/screens/Home/BaseService/market_type_router.dart';

import '../../../../data/models/Home/home_model.dart';

/// قسم عروض أفقي قابل لإعادة الاستخدام مع كروت المنتجات
class HomeOfferMarket extends StatelessWidget {
  final String title;
  final List<Market> marketList;

  const HomeOfferMarket({
    super.key,
    required this.title,
    required this.marketList,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return SliverPadding(
      padding: EdgeInsets.only(top: 10.h),
      sliver: SliverToBoxAdapter(
        child: marketList.isEmpty
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صف العنوان
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 2.h,
                    ),
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
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      itemCount: marketList.length,
                      itemBuilder: (context, index) =>
                          _buildCard(theme, primaryColor, marketList[index]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCard(ThemeData theme, Color primaryColor, Market market) {
    final cs = theme.colorScheme;
    final onSurface = theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: () {
        if (market.id <= 0) return;
        final type = market.marketType.value.trim().isNotEmpty
            ? market.marketType.value
            : 'store';
        MarketTypeRouter.open(
          type,
          arguments: BaseServiceItem(
            id: '${market.id}',
            name: market.name,
            subTitle: market.location,
            imageUrl: market.mainImage,
            address: market.location,
            rating: market.rating.toDouble(),
            reviewsCount: 0,
            distance: market.distance != null
                ? '${market.distance!.toStringAsFixed(1)} كم'
                : '',
            category: market.marketType.desc,
            serviceType: type,
            aboutText: market.location,
          ),
        );
      },
      child: Container(
        width: 220.w,
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
                    imageUrl: market.mainImage,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
                      color: cs.onPrimary,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      spacing: 5.w,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 10.sp),
                        Text(
                          market.rating.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                    market.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 9.sp,
                      color: onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'تكلفة التوصيل : ${market.deliveryPrice} ر.ق',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11.sp,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    market.isOpen ? market.location : 'مغلق',
                    style: TextStyle(
                      color: market.isOpen ? Colors.green : Colors.red,
                      fontSize: 9.sp,
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
