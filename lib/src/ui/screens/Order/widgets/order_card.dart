import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Order/models/order_model.dart';
import 'package:nisba_app/src/ui/screens/Order/widgets/dotted_divider.dart';
import 'package:nisba_app/src/ui/screens/Order/widgets/order_details_button.dart';
import 'package:nisba_app/src/ui/screens/Order/widgets/order_status_chip.dart';
import 'package:nisba_app/src/ui/screens/Order/widgets/order_stepper.dart';
import 'package:nisba_app/src/ui/screens/Order/widgets/restaurant_info.dart';

/// كارد عرض الطلب الفردي
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isExpanded;
  final VoidCallback onToggleExpand;

  const OrderCard({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.onToggleExpand,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- الجزء العلوي: صورة المنتج + Order Status Chip ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة المنتج (من Unsplash عبر CachedNetworkImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: order.itemImageUrl,
                    width: 70.w,
                    height: 70.h,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      width: 70.w,
                      height: 70.h,
                      color: cs.surfaceContainerHighest,
                      child: Icon(
                        Icons.fastfood,
                        color: cs.primary.withValues(alpha: 0.4),
                        size: 32.sp,
                      ),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      width: 70.w,
                      height: 70.h,
                      color: cs.surfaceContainerHighest,
                      child: Icon(
                        Icons.fastfood,
                        color: cs.primary.withValues(alpha: 0.4),
                        size: 32.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                // معلومات الطلب + Stepper
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // تاريخ ورقم الطلب
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'رقم الطلب ${order.orderId}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.5),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                order.dateTime,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: cs.onSurface.withValues(alpha: 0.5),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),

                          // Order Status Chip (أعلى اليسار)
                          OrderStatusChip(status: order.status),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      // Order Stepper
                      OrderStepper(currentStep: order.currentStep),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h),
            // --- Dotted Divider ---
            const DottedDivider(),

            // --- أسفل الكارد: معلومات المطعم + الإجمالي ---
            Row(
              children: [
                Expanded(
                  child: RestaurantInfo(
                    name: order.restaurantName,
                    address: order.restaurantAddress,
                    logoUrl: order.restaurantLogoUrl,
                  ),
                ),
                // الإجمالي بالريال القطري
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الإجمالي',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${order.totalPrice.toStringAsFixed(2)} ر.ق',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 6.h),
            // --- زر عرض التفاصيل (في المنتصف) ---
            Center(
              child: OrderDetailsButton(
                isExpanded: isExpanded,
                onTap: onToggleExpand,
              ),
            ),

            // --- تفاصيل إضافية عند التوسيع ---
            if (isExpanded) ...[
              SizedBox(height: 8.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'تفاصيل الطلب تظهر هنا (مكونات الوجبة، خيارات التوصيل، إلخ).',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
