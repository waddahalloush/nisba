import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

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
            icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
          ),
          title: Text(
            'إتمام الدفع',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomBar(theme),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Delivery info ──
              _buildDeliveryInfo(theme),

              SizedBox(height: 14.h),

              // ── Delivery Address ──
              _buildDeliveryAddress(theme),

              // ── Points section ──
              _buildPointsSection(theme),

              SizedBox(height: 14.h),

              // ── Payment methods ──
              _buildPaymentMethods(theme),

              SizedBox(height: 14.h),

              // ── Price breakdown ──
              _buildPriceBreakdown(theme),

              SizedBox(height: 14.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryInfo(ThemeData theme) {
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
        children: [
          // Restaurant name
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Iconsax.shopping_bag,
                  color: cs.primary,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                "ملخص الطلب",
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),

          // Delivery time
          _InfoRow(
            icon: Iconsax.shop,
            label: 'اسم المطعم',
            value: controller.restaurantName,
          ),
          SizedBox(height: 8.h),
          // Delivery time
          _InfoRow(
            icon: Iconsax.clock,
            label: 'وقت التوصيل',
            value: controller.deliveryTime,
          ),
          SizedBox(height: 8.h),

          // Address
          _InfoRow(
            icon: Icons.pedal_bike_rounded,
            label: 'مسؤول التوصيل',
            value: controller.deliveryManager,
          ),
        ],
      ),
    );
  }

  // ── Address Change Bottom Sheet ──
  void _showAddressSheet() {
    controller.addressController.text = controller.deliveryAddress.value;
    final theme = Theme.of(Get.context!);
    final cs = theme.colorScheme;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            // Title row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.close, color: cs.onSurface, size: 22.sp),
                  ),
                  Text(
                    'تغيير عنوان التوصيل',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),
            ),
            // Address input
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextFormField(
                controller: controller.addressController,
                maxLines: 3,
                textDirection: TextDirection.rtl,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'أدخل عنوان التوصيل الجديد',
                  hintStyle: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.35),
                    fontSize: 13.sp,
                  ),
                  filled: true,
                  fillColor: cs.primary.withValues(alpha: 0.045),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(14.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Save button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: controller.updateAddress,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'حفظ العنوان',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryAddress(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      margin: EdgeInsets.only(bottom: 14.h),
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
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Iconsax.location, color: cs.primary, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'عنوان التوصيل',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showAddressSheet,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'تغيير',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),
          SizedBox(height: 10.h),
          Obx(
            () => Row(
              children: [
                Icon(
                  Iconsax.map_1,
                  color: cs.onSurface.withValues(alpha: 0.5),
                  size: 18.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    controller.deliveryAddress.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.75),
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSection(ThemeData theme) {
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
          Row(
            children: [
              Container(
                width: 42.w,
                height: 42.h,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Iconsax.cup, color: cs.primary, size: 20.sp),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => Text(
                  'لديك ${controller.availablePoints.value} نقطة',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Points slider
          Obx(
            () => SliderTheme(
              data: SliderThemeData(
                activeTrackColor: cs.primary,
                inactiveTrackColor: cs.primary.withValues(alpha: 0.15),
                thumbColor: cs.primary,
                overlayColor: cs.primary.withValues(alpha: 0.12),
                trackHeight: 6,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
              ),
              child: Slider(
                value: controller.pointsToUse.value,
                min: 0,
                max: controller.availablePoints.value.toDouble(),
                divisions: controller.availablePoints.value,
                onChanged: (v) => controller.pointsToUse.value = v,
              ),
            ),
          ),

          Obx(
            () => Text(
              'استخدام ${controller.pointsToUse.value.toInt()} نقطة يخصم ${controller.pointsDiscount.toStringAsFixed(2)} ريال من الفاتورة',
              style: TextStyle(
                fontSize: 11.sp,
                color: cs.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
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
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
            child: Text(
              'طريقة الدفع',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
          ),
          Obx(
            () => Column(
              children: List.generate(controller.paymentMethods.length, (i) {
                final method = controller.paymentMethods[i];
                final isSelected =
                    controller.selectedPayment.value == method.label;
                final isLast = i == controller.paymentMethods.length - 1;

                return Column(
                  children: [
                    InkWell(
                      onTap: () => controller.selectPayment(method.label),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? cs.primary
                                      : cs.onSurface.withValues(alpha: 0.3),
                                  width: isSelected ? 6 : 1.5,
                                ),
                              ),
                            ),

                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    method.label,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: cs.onSurface,
                                    ),
                                  ),
                                  if (method.subtitle != null)
                                    Text(
                                      method.subtitle!,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: cs.onSurface.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                    ),
                                ],
                              ),
                            ),
                            Image.asset(
                              method.icon,
                              width: 50.w,
                              height: 30.w,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        indent: 62.w,
                        color: cs.outlineVariant.withValues(alpha: 0.4),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => Container(
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
          children: [
            _PriceRow(
              label: 'المجموع الفرعي',
              value: '${controller.subtotal.value.toStringAsFixed(2)} ريال',
            ),
            SizedBox(height: 6.h),
            _PriceRow(
              label: 'رسوم التوصيل',
              value: '${controller.deliveryFee.value.toStringAsFixed(2)} ريال',
            ),
            SizedBox(height: 6.h),
            _PriceRow(
              label: 'خصم القسيمة',
              value: '- ${controller.discount.value.toStringAsFixed(2)} ريال',
              isDiscount: true,
            ),
            SizedBox(height: 6.h),
            _PriceRow(
              label: 'خصم النقاط',
              value: '- ${controller.pointsDiscount.toStringAsFixed(2)} ريال',
              isDiscount: true,
            ),
            SizedBox(height: 6.h),
            _PriceRow(
              label: 'الضريبة',
              value: '${controller.tax.value.toStringAsFixed(2)} ريال',
            ),
            Divider(color: cs.outlineVariant.withValues(alpha: 0.5)),
            _PriceRow(
              label: 'الإجمالي',
              value: '${controller.total.toStringAsFixed(2)} ريال',
              isTotal: true,
            ),
          ],
        ),
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
          onPressed: controller.payNow,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ادفع الآن',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  '${controller.total.toStringAsFixed(2)} ريال',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final RxString value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, color: cs.primary, size: 16.sp),
        SizedBox(width: 8.w),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12.sp,
            color: cs.onSurface.withValues(alpha: 0.55),
          ),
        ),
        Expanded(
          child: Obx(
            () => Text(
              value.value,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: cs.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final bool isDiscount;

  const _PriceRow({
    required this.label,
    required this.value,
    this.isTotal = false,
    this.isDiscount = false,
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
            color: isDiscount
                ? Colors.teal
                : isTotal
                ? cs.primary
                : cs.onSurface,
          ),
        ),
      ],
    );
  }
}
