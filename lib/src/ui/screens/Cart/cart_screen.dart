import 'package:easy_date_timeline/easy_date_timeline.dart';
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

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      image: DecorationImage(image: AssetImage(item.imageUrl)),
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
                            Image.asset(c.icon, width: 30, height: 30),
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
                  : controller.selectedCoupon.value == 'قسيمة الشحن'
                  ? 'شحن مجاني مدة 7 أيام'
                  : 'خصومات على المطاعم و الفنادق و مراكز التسوق',
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
                                'حجز الآن',
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'استلام فوري',
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
                                'جدولة الطلب',
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSurface,
                                ),
                              ),
                              Text(
                                'اختر وقت و تاريخ مناسب',
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

// ── Scheduled Delivery Bottom Sheet ──
class _ScheduledDeliverySheet extends StatelessWidget {
  final CartController controller;

  const _ScheduledDeliverySheet({required this.controller});

  static const _arabicMonths = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  static const _weekdaySymbols = ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'];

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
                  'جدولة الطلب',
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
                    'تم',
                    'تم جدولة الطلب في ${controller.scheduledSlotLabel}',
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
                  'تأكيد الموعد',
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
            'اختر الوقت المناسب',
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

class _CalendarCell extends StatelessWidget {
  final int? day;
  final bool isSelected;
  final bool isToday;
  final ColorScheme cs;
  final VoidCallback? onTap;

  const _CalendarCell({
    this.day,
    this.isSelected = false,
    this.isToday = false,
    required this.cs,
    this.onTap,
  });

  const _CalendarCell.empty()
    : day = null,
      isSelected = false,
      isToday = false,
      cs = const ColorScheme.light(),
      onTap = null;

  @override
  Widget build(BuildContext context) {
    if (day == null) return const Expanded(child: SizedBox());

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(2.r),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary : Colors.transparent,
            shape: BoxShape.circle,
            border: isToday && !isSelected
                ? Border.all(color: cs.primary, width: 1.5)
                : null,
          ),
          padding: EdgeInsets.all(8.r),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected || isToday
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: isSelected
                    ? cs.onPrimary
                    : cs.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
