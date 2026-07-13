import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'cart_controller.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.onSurface),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'سلة المشتريات',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
              GetBuilder<CartController>(
                builder: (_) => Text(
                  '${controller.itemCount} منتجات',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Iconsax.trash, color: cs.error, size: 20.sp),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(theme),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Product cards ──
              _buildProductList(theme),

              SizedBox(height: 16.h),

              // ── Coupon section ──
              _buildCouponSection(theme),

              SizedBox(height: 16.h),

              // ── Order summary ──
              _buildOrderSummary(theme),

              SizedBox(height: 16.h),

              // ── Delivery options ──
              _buildDeliveryOptions(theme),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductList(ThemeData theme) {
    final cs = theme.colorScheme;

    return GetBuilder<CartController>(
      builder: (_) => Column(
        children: List.generate(controller.items.length, (index) {
          final item = controller.items[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: cs.shadow.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      width: 70.w,
                      height: 70.h,
                      color: cs.surfaceContainerHighest,
                      child: Icon(
                        Iconsax.bag_2,
                        color: cs.primary.withValues(alpha: 0.5),
                        size: 28.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),

                  // Name + price
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        if (item.note != null) ...[
                          SizedBox(height: 2.h),
                          Text(
                            item.note!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.5),
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                        SizedBox(height: 4.h),
                        Text(
                          'ريال ${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: cs.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quantity controls
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () => controller.incrementQuantity(index),
                        child: Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: cs.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Iconsax.add,
                            color: cs.primary,
                            size: 14.sp,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '${item.quantity}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap: () => controller.decrementQuantity(index),
                        child: Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Icon(
                            Iconsax.minus,
                            color: cs.onSurface.withValues(alpha: 0.5),
                            size: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCouponSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر قسيمة (اختياري)',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),

          // Coupon cards row
          Obx(
            () => Row(
              children: controller.coupons.map((c) {
                final isSelected = controller.selectedCoupon.value == c.title;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: GestureDetector(
                      onTap: () => controller.selectCoupon(c.title),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 6.w,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cs.primary.withValues(alpha: 0.06)
                              : cs.surface,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isSelected
                                ? cs.primary
                                : cs.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              c.icon,
                              color: isSelected
                                  ? cs.primary
                                  : cs.onSurface.withValues(alpha: 0.45),
                              size: 18.sp,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              c.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? cs.primary
                                    : cs.onSurface.withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 8.h),

          // Selected coupon info
          Obx(
            () => Text(
              controller.selectedCoupon.value == 'قسيمة التسوق'
                  ? 'خصم على جميع المشتريات مثال 15%'
                  : '',
              style: TextStyle(
                fontSize: 10.sp,
                color: cs.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(height: 10.h),

          // Coupon code input
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.couponController,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: 'أدخل كود القسيمة (اختياري)',
                    hintStyle: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.35),
                      fontSize: 11.sp,
                    ),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              SizedBox(
                height: 40.h,
                child: ElevatedButton(
                  onPressed: controller.applyCouponCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                  ),
                  child: Text(
                    'تفعيل القسيمة',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(ThemeData theme) {
    final cs = theme.colorScheme;

    return GetBuilder<CartController>(
      builder: (_) => Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملخص الطلب',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 10.h),
            _SummaryRow(
              label: 'المجموع الفرعي',
              value: '${controller.subtotal.toStringAsFixed(2)} ريال',
            ),
            SizedBox(height: 6.h),
            _SummaryRow(
              label: 'رسوم التوصيل',
              value: '${controller.deliveryFee.toStringAsFixed(2)} ريال',
            ),
            SizedBox(height: 6.h),
            _SummaryRow(
              label: 'الضريبة (5%)',
              value: '${controller.tax.toStringAsFixed(2)} ريال',
            ),
            Divider(color: cs.outlineVariant.withValues(alpha: 0.5)),
            _SummaryRow(
              label: 'الإجمالي',
              value: 'ريال ${controller.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryOptions(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر طريقة استلام طلبك',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.truck_fast,
                        color: cs.onPrimary,
                        size: 22.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'حجز الآن',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: cs.onPrimary,
                        ),
                      ),
                      Text(
                        'استلام فوري',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: cs.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Iconsax.calendar_1,
                        color: cs.onSurface.withValues(alpha: 0.5),
                        size: 22.sp,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'جدولة الطلب',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      color: cs.surfaceContainerHighest,
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: ElevatedButton(
          onPressed: controller.checkout,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Text(
            'إتمام الطلب',
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14.sp : 12.sp,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: cs.onSurface.withValues(alpha: isTotal ? 1 : 0.6),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16.sp : 12.sp,
            fontWeight: FontWeight.bold,
            color: isTotal ? cs.primary : cs.onSurface,
          ),
        ),
      ],
    );
  }
}
