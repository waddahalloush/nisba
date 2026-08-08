import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'cart_controller.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(backIconData(context), color: cs.primary),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'auto_key_147'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            GetBuilder<CartController>(
              builder: (_) => Text(
                'auto_key_148'.tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            padding: EdgeInsets.all(10.r),
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cs.onPrimary,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 2),
                  color: Colors.grey.shade300,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Icon(Iconsax.trash, color: cs.primary, size: 20.sp),
          ),
        ],
      ),
      bottomNavigationBar: GetBuilder<CartController>(
        builder: (_) => controller.items.isNotEmpty
            ? _buildBottomBar(theme)
            : const SizedBox.shrink(),
      ),
      body: GetBuilder<CartController>(
        builder: (_) {
          if (controller.items.isEmpty) {
            return _buildEmptyCart(theme);
          }
          return SingleChildScrollView(
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

                // ── Delivery type (backend delivery_type) ──
                _buildDeliveryTypeSection(theme),

                SizedBox(height: 16.h),

                // ── Schedule (now / later) ──
                _buildDeliveryOptions(theme),

                SizedBox(height: 16.h),
              ],
            ),
          );
        },
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
                  Container(
                    width: 70.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(item.imageUrl),
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
                          'auto_key_149'.tr,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
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
            'auto_key_150'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          Obx(() {
            final applied = controller.appliedCouponCode.value.isNotEmpty;
            if (!applied) {
              return Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.couponController,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'enter_coupon_code'.tr,
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
                      onPressed: controller.isApplyingCoupon.value
                          ? null
                          : controller.applyCouponCode,
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
                        controller.isApplyingCoupon.value ? '...' : 'auto_key_151'.tr,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: cs.primary.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Icon(Iconsax.ticket, color: cs.primary, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.appliedCouponName.value.isNotEmpty
                              ? controller.appliedCouponName.value
                              : 'auto_key_152'.tr,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: cs.onSurface,
                          ),
                        ),
                        Text(
                          'auto_key_153'.tr,
                          style: TextStyle(fontSize: 11.sp, color: cs.primary),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: controller.clearCoupon,
                    child: Text(
                      'auto_key_154'.tr,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: cs.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
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
              'order_summary'.tr,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 10.h),
            _SummaryRow(
              label: 'subtotal'.tr,
              value: 'auto_key_155'.tr,
            ),
            SizedBox(height: 6.h),
            _SummaryRow(
              label: 'delivery_fee'.tr,
              value: 'auto_key_156'.tr,
            ),
            if (controller.customerDiscount > 0) ...[
              SizedBox(height: 6.h),
              _SummaryRow(
                label: 'auto_key_157'.tr,
                value:
                    'auto_key_158'.tr,
              ),
            ],
            if (controller.couponValue.value > 0) ...[
              SizedBox(height: 6.h),
              _SummaryRow(
                label: 'auto_key_159'.tr,
                value:
                    'auto_key_160'.tr,
              ),
            ],
            if (controller.earnedPoints > 0) ...[
              SizedBox(height: 6.h),
              _SummaryRow(
                label: 'auto_key_161'.tr,
                value: controller.earnedPoints.toStringAsFixed(2),
              ),
            ],
            Divider(color: cs.outlineVariant.withValues(alpha: 0.5)),
            _SummaryRow(
              label: 'auto_key_162'.tr,
              value: 'auto_key_163'.tr,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTypeSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(() {
      final types = controller.availableDeliveryTypes;
      if (types.isEmpty) return const SizedBox.shrink();

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
              'auto_key_164'.tr,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
            ),
            SizedBox(height: 10.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: types.map((key) {
                final selected = controller.deliveryType.value == key;
                return GestureDetector(
                  onTap: () => controller.setDeliveryType(key),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? cs.primary.withValues(alpha: 0.1)
                          : cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: selected
                            ? cs.primary
                            : cs.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      controller.deliveryTypeLabel(key),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: selected ? cs.primary : cs.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
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
            'auto_key_165'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          Obx(
            () => Row(
              children: [
                // Order Now
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectDeliveryMethod(
                      DeliveryMethod.orderNow,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color:
                            controller.deliveryMethod.value ==
                                DeliveryMethod.orderNow
                            ? cs.primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color:
                              controller.deliveryMethod.value ==
                                  DeliveryMethod.orderNow
                              ? cs.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Iconsax.truck_fast,
                            color: cs.primary,
                            size: 22.sp,
                          ),
                          Column(
                            children: [
                              Text(
                                'auto_key_166'.tr,
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'auto_key_167'.tr,
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.normal,
                                  color: cs.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                // Order Later
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.selectDeliveryMethod(
                        DeliveryMethod.orderLater,
                      );
                      _showScheduledDeliverySheet();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        color:
                            controller.deliveryMethod.value ==
                                DeliveryMethod.orderLater
                            ? cs.primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color:
                              controller.deliveryMethod.value ==
                                  DeliveryMethod.orderLater
                              ? cs.primary
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Iconsax.calendar_1,
                            color: cs.primary,
                            size: 22.sp,
                          ),
                          Column(
                            children: [
                              Text(
                                'auto_key_168'.tr,
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'auto_key_169'.tr,
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 8.sp,
                                  color: cs.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
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

  // ── Scheduled Delivery Bottom Sheet ──
  void _showScheduledDeliverySheet() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ScheduledDeliverySheet(controller: controller),
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
              borderRadius: BorderRadius.circular(25.r),
            ),
          ),
          child: Text(
            'checkout'.tr,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCart(ThemeData theme) {
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Iconsax.shopping_cart,
              size: 80.sp,
              color: cs.onSurface.withValues(alpha: 0.15),
            ),
            SizedBox(height: 20.h),
            Text(
              'auto_key_170'.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'auto_key_171'.tr,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.35),
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => Get.back(),
              icon: const Icon(Iconsax.shop),
              label: Text('auto_key_172'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              ),
            ),
          ],
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

// ── Scheduled Delivery Bottom Sheet ──
class _ScheduledDeliverySheet extends StatelessWidget {
  final CartController controller;

  const _ScheduledDeliverySheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
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
                  'auto_key_173'.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(width: 22),
              ],
            ),
          ),
          // Calendar
          _buildCalendar(theme, cs),
          SizedBox(height: 16.h),
          // Time slots
          _buildTimeSlots(theme, cs),
          SizedBox(height: 16.h),
          // Confirm button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar(
                    'auto_key_102'.tr,
                    'auto_key_174'.tr,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'auto_key_175'.tr,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 12.h),
        ],
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme, ColorScheme cs) {
    // حساب التواريخ السابقة لتعطيلها (مثلاً: آخر 90 يوم قبل اليوم الحالي)
    final today = DateTime.now();
    final disabledDates = List<DateTime>.generate(
      90,
      (index) => DateTime(today.year, today.month, today.day - (index + 1)),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Obx(
        () => EasyDateTimeLine(
          initialDate: controller.selectedDate.value,
          locale: "ar",
          disabledDates:
              disabledDates, // تمرير قائمة التواريخ المراد تعطيلها هنا
          headerProps: EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            selectedDateStyle: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          dayProps: EasyDayProps(
            dayStructure: DayStructure.dayStrDayNum,
            height: 70.h,
            width: 48.w,
            // تصميم الأيام المعطلة (قبل اليوم الحالي)
            disabledDayStyle: DayStyle(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              dayNumStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: cs.onSurface.withValues(
                  alpha: 0.25,
                ), // لون باهت للدلالة على التعطيل
                decoration: TextDecoration.lineThrough, // خط فوق الرقم اختياري
              ),
              dayStrStyle: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: cs.onSurface.withValues(alpha: 0.2),
              ),
            ),
            // تصميم اليوم النشط/المحدد
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              dayNumStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: cs.onPrimary,
              ),
              dayStrStyle: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: cs.onPrimary,
              ),
            ),
            // تصميم الأيام العادية المتاحة
            inactiveDayStyle: DayStyle(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12.r),
              ),
              dayNumStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
              dayStrStyle: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
          onDateChange: (selectedDate) {
            controller.selectScheduledDate(selectedDate);
          },
        ),
      ),
    );
  }

  Widget _buildTimeSlots(ThemeData theme, ColorScheme cs) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'auto_key_176'.tr,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 10.h),
          Obx(
            () => Column(
              children: controller.timeSlots.map((slot) {
                final isSelected = controller.selectedTimeSlot.value == slot;
                return GestureDetector(
                  onTap: () => controller.selectTimeSlot(slot),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 6.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cs.primary.withValues(alpha: 0.08)
                          : cs.surface,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isSelected
                            ? cs.primary
                            : cs.outlineVariant.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          slot,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? cs.primary
                                : cs.onSurface.withValues(alpha: 0.7),
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
                                  : cs.outlineVariant.withValues(alpha: 0.6),
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10.w,
                                    height: 10.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: cs.primary,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
