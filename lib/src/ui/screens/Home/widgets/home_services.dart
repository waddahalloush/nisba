import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/ui/screens/Home/BaseService/market_type_router.dart';

/// قسم العلامات المشهورة — يعرض العلامات في صفين أفقيين.
class HomeBrands extends StatelessWidget {
  final List<Market> brands;

  const HomeBrands({super.key, required this.brands});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (brands.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final int half = (brands.length / 2).ceil();
    final List<Market> row1 = brands.sublist(0, half);
    final List<Market> row2 = brands.sublist(half);
    final int itemCount = row1.length > row2.length ? row1.length : row2.length;

    return SliverPadding(
      padding: EdgeInsets.only(top: 6.h),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              child: Text(
                'auto_key_412'.tr,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            SizedBox(
              height: 140.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (index < row1.length)
                          _MarketBrandCard(market: row1[index])
                        else
                          SizedBox(width: 60.w, height: 60.h),
                        SizedBox(height: 12.h),
                        if (index < row2.length)
                          _MarketBrandCard(market: row2[index])
                        else
                          SizedBox(width: 60.w, height: 60.h),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card for an API‑driven [Market] brand.
class _MarketBrandCard extends StatelessWidget {
  final Market market;
  const _MarketBrandCard({required this.market});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 60.w,
      height: 60.h,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
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
                    ? 'auto_key_410'.tr
                    : '',
                category: market.marketType.desc,
                serviceType: type,
                aboutText: market.location,
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: CachedNetworkImage(
                imageUrl: market.mainImage,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (_, __) =>
                    Container(color: theme.colorScheme.surfaceContainerHigh),
                errorWidget: (_, __, ___) =>
                    Container(color: theme.colorScheme.surfaceContainerHigh),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
