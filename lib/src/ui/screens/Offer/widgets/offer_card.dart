import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Offer/offer_controller.dart';
import 'restaurant_header.dart';
import 'discount_banner.dart';
import 'menu_item_card.dart';
import 'delivery_info.dart';

class OfferCard extends StatelessWidget {
  final OfferRestaurant restaurant;
  final VoidCallback? onTapDetails;
  final Function(OfferItem)? onTapAddItem;

  const OfferCard({
    super.key,
    required this.restaurant,
    this.onTapDetails,
    this.onTapAddItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: cs.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Restaurant Header ──
          Padding(
            padding: EdgeInsets.all(14.r),
            child: RestaurantHeader(
              name: restaurant.name,
              rating: restaurant.rating,
              reviewsCount: restaurant.reviewsCount,
              logoPath: restaurant.logoPath,
              onTapDetails: onTapDetails,
            ),
          ),

          // ── 2. Discount & Delivery Banner ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: DiscountBanner(
              discountTitle: restaurant.discountTitle,
              discountDesc: restaurant.discountDesc,
              deliveryTitle: restaurant.deliveryTitle,
              deliveryDesc: restaurant.deliveryDesc,
            ),
          ),

          // ── 3. Horizontal Menu Items ──
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: restaurant.items.map((item) {
                  return Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: MenuItemCard(
                      name: item.name,
                      price: item.price,
                      oldPrice: item.oldPrice,
                      imagePath: item.imagePath,
                      isPopular: item.isPopular,
                      prepTime: item.prepTime,
                      onTapAdd: onTapAddItem != null
                          ? () => onTapAddItem!(item)
                          : null,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // ── 4. Bottom Delivery Info Footer ──
          DeliveryInfo(
            deliveryTime: restaurant.deliveryTime,
            deliveryBy: restaurant.deliveryBy,
            satisfactionRate: restaurant.satisfactionRate,
          ),
        ],
      ),
    );
  }
}
