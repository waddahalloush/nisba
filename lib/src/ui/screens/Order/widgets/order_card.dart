import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/data/models/Home/order_details_model.dart';
import 'package:nisba_app/src/ui/screens/Order/extensions/order_status_extension.dart';
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
  final OrderDetail? detail;
  final bool isLoadingDetail;
  final VoidCallback? onCancel;
  final VoidCallback? onRate;
  final VoidCallback? onChat;
  final VoidCallback? onPay;
  final VoidCallback? onRetryDetail;

  const OrderCard({
    super.key,
    required this.order,
    required this.isExpanded,
    required this.onToggleExpand,
    this.detail,
    this.isLoadingDetail = false,
    this.onCancel,
    this.onRate,
    this.onChat,
    this.onPay,
    this.onRetryDetail,
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
                                'auto_key_464'.tr,
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
                      'auto_key_162'.tr,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'auto_key_465'.tr,
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
              if (isLoadingDetail)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (detail != null)
                _buildOrderDetails(context, detail!)
              else
                _buildRetryButton(context),
              SizedBox(height: 10.h),
              _buildActionButtons(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final buttons = <Widget>[];

    final canCancel = order.status == OrderStatus.newOrder ||
        order.status == OrderStatus.waitingPayment;

    if (order.status == OrderStatus.waitingPayment && onPay != null) {
      buttons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPay,
            icon: Icon(Icons.payment_rounded, size: 16.r),
            label: Text('auto_key_466'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              elevation: 0,
            ),
          ),
        ),
      );
    }

    if (canCancel && onCancel != null) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 8.w));
      buttons.add(
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCancel,
            icon: Icon(Icons.cancel_outlined, size: 16.r),
            label: Text('cancel'.tr),
            style: OutlinedButton.styleFrom(
              foregroundColor: cs.error,
              side: BorderSide(color: cs.error.withValues(alpha: 0.4)),
            ),
          ),
        ),
      );
    }

    if (order.status == OrderStatus.delivered && onRate != null) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 8.w));
      buttons.add(
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onRate,
            icon: Icon(Icons.star_outline, size: 16.r),
            label: Text('rating'.tr),
            style: OutlinedButton.styleFrom(foregroundColor: cs.primary),
          ),
        ),
      );
    }

    if (onChat != null && order.status != OrderStatus.waitingPayment) {
      if (buttons.isNotEmpty) buttons.add(SizedBox(width: 8.w));
      buttons.add(
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onChat,
            icon: Icon(Icons.chat_outlined, size: 16.r),
            label: Text('auto_key_467'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              elevation: 0,
            ),
          ),
        ),
      );
    }

    if (buttons.isEmpty) return const SizedBox.shrink();
    return Row(children: buttons);
  }

  // ──────────────────────────────────────────────────────────
  //  Order Details Section
  // ──────────────────────────────────────────────────────────

  Widget _buildRetryButton(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: cs.error, size: 20.r),
          SizedBox(height: 4.h),
          Text(
            'auto_key_445'.tr,
            style: theme.textTheme.labelSmall?.copyWith(color: cs.error),
          ),
          if (onRetryDetail != null) ...[
            SizedBox(height: 6.h),
            TextButton(
              onPressed: onRetryDetail,
              child: Text('auto_key_243'.tr),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, OrderDetail d) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Payment & Delivery row ──
          _detailRow(
            context,
            icon: Icons.payment_rounded,
            label: 'payment_method'.tr,
            value: d.paymentMethod.desc,
          ),
          SizedBox(height: 6.h),
          _detailRow(
            context,
            icon: Icons.local_shipping_rounded,
            label: 'auto_key_468'.tr,
            value: d.deliveryType.desc,
          ),
          SizedBox(height: 6.h),
          _detailRow(
            context,
            icon: Icons.payments_outlined,
            label: 'auto_key_162'.tr,
            value: 'auto_key_469'.tr,
          ),
          if (d.deliveryPrice != '0' && d.deliveryPrice.isNotEmpty) ...[
            SizedBox(height: 6.h),
            _detailRow(
              context,
              icon: Icons.delivery_dining_outlined,
              label: 'delivery'.tr,
              value: 'auto_key_470'.tr,
            ),
          ],
          if (d.note != null && d.note.toString().isNotEmpty) ...[
            SizedBox(height: 6.h),
            _detailRow(
              context,
              icon: Icons.note_alt_rounded,
              label: 'auto_key_471'.tr,
              value: d.note.toString(),
            ),
          ],

          // ── Cart items ──
          if (d.carts.isNotEmpty) ...[
            SizedBox(height: 10.h),
            const DottedDivider(),
            SizedBox(height: 8.h),
            Text(
              'auto_key_472'.tr,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 6.h),
            ...d.carts.map((cart) => _buildCartItem(context, cart)),
          ],

          // ── Order status timeline ──
          if (d.orderStatuses.isNotEmpty) ...[
            SizedBox(height: 10.h),
            const DottedDivider(),
            SizedBox(height: 8.h),
            Text(
              'order_status'.tr,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 6.h),
            ...d.orderStatuses.map((s) => _buildStatusEntry(context, s)),
          ],
        ],
      ),
    );
  }

  // ── Detail row helper ──
  Widget _detailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16.r, color: cs.primary.withValues(alpha: 0.7)),
        SizedBox(width: 6.w),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.5),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: cs.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  // ── Cart item row ──
  Widget _buildCartItem(BuildContext context, CartItem cart) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          // Product thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: CachedNetworkImage(
              imageUrl: cart.product.image,
              width: 36.w,
              height: 36.h,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => Icon(
                Icons.fastfood,
                size: 20.r,
                color: cs.primary.withValues(alpha: 0.4),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cart.product.name,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'auto_key_473'.tr,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              '${cart.quantity}x',
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Status timeline entry ──
  Widget _buildStatusEntry(BuildContext context, OrderStatusEntry entry) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(
              color: cs.primary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              entry.status.desc,
              style: theme.textTheme.labelSmall?.copyWith(
                color: cs.onSurface,
              ),
            ),
          ),
          Text(
            entry.createdAt,
            style: theme.textTheme.labelSmall?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.4),
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
