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
            icon: Icon(Iconsax.arrow_right_1, color: cs.onSurface),
          ),
          title: Text(
            'إتمام الدفع',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
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
                child: Icon(Iconsax.shop, color: cs.primary, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Obx(
                  () => Text(
                    controller.restaurantName.value,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Divider(color: cs.outlineVariant.withValues(alpha: 0.4)),

          // Delivery time
          _InfoRow(
            icon: Iconsax.clock,
            label: 'وقت التوصيل',
            value: controller.deliveryTime,
          ),
          SizedBox(height: 8.h),

          // Address
          _InfoRow(
            icon: Iconsax.location,
            label: 'عنوان التوصيل',
            value: controller.deliveryAddress,
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
              Icon(Iconsax.cup, color: cs.primary, size: 20.sp),
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
              'استخدام ${controller.pointsToUse.value.toInt()} نقطة',
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
                              width: 38.w,
                              height: 38.h,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? cs.primary.withValues(alpha: 0.1)
                                    : cs.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Icon(
                                method.icon,
                                color: isSelected
                                    ? cs.primary
                                    : cs.onSurface.withValues(alpha: 0.45),
                                size: 18.sp,
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
              label: 'الخصم',
              value: '- ${controller.discount.value.toStringAsFixed(2)} ريال',
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
              value: '${controller.total.value.toStringAsFixed(2)} ريال',
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
                  '${controller.total.value.toStringAsFixed(2)} ريال',
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
                ? cs.error
                : isTotal
                ? cs.primary
                : cs.onSurface,
          ),
        ),
      ],
    );
  }
}
