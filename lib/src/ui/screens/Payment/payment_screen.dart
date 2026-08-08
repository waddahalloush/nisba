import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:nisba_app/src/services/locale_service.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import 'payment_controller.dart';

class PaymentScreen extends GetView<PaymentController> {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: Get.find<LocaleService>().textDirection,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(backIconData(context), color: cs.primary),
          ),
          title: Text(
            'auto_key_487'.tr,
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
              _buildDeliveryInfo(theme),
              SizedBox(height: 14.h),
              Obx(
                () => controller.needsAddress
                    ? _buildDeliveryAddress(theme)
                    : const SizedBox.shrink(),
              ),
              Obx(
                () => controller.needsCar
                    ? _buildCarSection(theme)
                    : const SizedBox.shrink(),
              ),
              _buildPointsSection(theme),
              SizedBox(height: 14.h),
              _buildPaymentMethods(theme),
              SizedBox(height: 14.h),
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
                'order_summary'.tr,
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
          Obx(() {
            if (controller.restaurantName.value.isEmpty) {
              return const SizedBox.shrink();
            }
            return Column(
              children: [
                _InfoRow(
                  icon: Iconsax.shop,
                  label: 'auto_key_488'.tr,
                  value: controller.restaurantName,
                ),
                SizedBox(height: 8.h),
              ],
            );
          }),
          Obx(() {
            final label = controller.deliveryTypeLabel;
            return Row(
              children: [
                Icon(Iconsax.truck_fast, color: cs.primary, size: 16.sp),
                SizedBox(width: 8.w),
                Text(
                  'auto_key_489'.tr,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  void _showAddressPicker() {
    final theme = Theme.of(Get.context!);
    final cs = theme.colorScheme;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.55),
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
                    'auto_key_490'.tr,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),
            ),
            Flexible(
              child: Obx(() {
                if (controller.addresses.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('auto_key_31'.tr),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.toNamed(AppRoutesNames.addresses);
                          },
                          child: Text('auto_key_16'.tr),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  itemCount: controller.addresses.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, i) {
                    final a = controller.addresses[i];
                    return Obx(() {
                      final selected =
                          controller.selectedAddressId.value == a.id;
                      return ListTile(
                        onTap: () {
                          controller.selectAddress(a);
                          Get.back();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: selected
                                ? cs.primary
                                : cs.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        leading: Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selected ? cs.primary : cs.onSurface,
                        ),
                        title: Text(
                          a.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                        ),
                        subtitle: Text(
                          a.details,
                          style: TextStyle(fontSize: 11.sp),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showCarPicker() {
    final theme = Theme.of(Get.context!);
    final cs = theme.colorScheme;

    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(maxHeight: Get.height * 0.55),
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
                    'auto_key_491'.tr,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(width: 22),
                ],
              ),
            ),
            Flexible(
              child: Obx(() {
                if (controller.cars.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('auto_key_492'.tr),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            Get.toNamed(AppRoutesNames.myCars);
                          },
                          child: Text('auto_key_493'.tr),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  itemCount: controller.cars.length,
                  separatorBuilder: (_, __) => SizedBox(height: 8.h),
                  itemBuilder: (_, i) {
                    final c = controller.cars[i];
                    return Obx(() {
                      final selected = controller.selectedCarId.value == c.id;
                      return ListTile(
                        onTap: () {
                          controller.selectCar(c);
                          Get.back();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: selected
                                ? cs.primary
                                : cs.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        leading: Icon(
                          selected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          color: selected ? cs.primary : cs.onSurface,
                        ),
                        title: Text(
                          c.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13.sp,
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),
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
                  'auto_key_494'.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showAddressPicker,
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
                    'auto_key_495'.tr,
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
            () => Text(
              controller.deliveryAddress.value.isNotEmpty
                  ? controller.deliveryAddress.value
                  : 'auto_key_496'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.75),
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarSection(ThemeData theme) {
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
                child: Icon(Iconsax.car, color: cs.primary, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'auto_key_497'.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showCarPicker,
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
                    'auto_key_495'.tr,
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
            () => Text(
              controller.selectedCarLabel.value.isNotEmpty
                  ? controller.selectedCarLabel.value
                  : 'auto_key_498'.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.75),
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => Container(
        margin: EdgeInsets.only(top: 0, bottom: 0),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'auto_key_499'.tr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        controller.earnedPoints.value > 0
                            ? 'auto_key_500'.tr
                            : 'auto_key_501'.tr,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              'auto_key_502'.tr,
              style: TextStyle(
                fontSize: 11.sp,
                color: cs.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
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
              'payment_method'.tr,
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
              label: 'subtotal'.tr,
              value: 'auto_key_503'.tr,
            ),
            SizedBox(height: 6.h),
            _PriceRow(
              label: 'delivery_fee'.tr,
              value: 'auto_key_504'.tr,
            ),
            if (controller.couponDiscount.value > 0) ...[
              SizedBox(height: 6.h),
              _PriceRow(
                label: 'auto_key_159'.tr,
                value:
                    'auto_key_505'.tr,
                isDiscount: true,
              ),
            ],
            if (controller.offerDiscount.value > 0) ...[
              SizedBox(height: 6.h),
              _PriceRow(
                label: 'auto_key_506'.tr,
                value:
                    'auto_key_507'.tr,
                isDiscount: true,
              ),
            ],
            if (controller.customerDiscount.value > 0) ...[
              SizedBox(height: 6.h),
              _PriceRow(
                label: 'auto_key_157'.tr,
                value:
                    'auto_key_508'.tr,
                isDiscount: true,
              ),
            ],
            if (controller.earnedPoints.value > 0) ...[
              SizedBox(height: 6.h),
              _PriceRow(
                label: 'auto_key_509'.tr,
                value: controller.earnedPoints.value.toStringAsFixed(2),
              ),
            ],
            Divider(color: cs.outlineVariant.withValues(alpha: 0.5)),
            _PriceRow(
              label: 'auto_key_162'.tr,
              value: 'auto_key_510'.tr,
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
                  'auto_key_511'.tr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  'auto_key_510'.tr,
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
