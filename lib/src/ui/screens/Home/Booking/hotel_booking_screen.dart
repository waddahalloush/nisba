import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'hotel_booking_controller.dart';

class HotelBookingScreen extends GetView<HotelBookingController> {
  const HotelBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // ─── 1. صورة الفندق مع أزرار التراكب ───
                _buildHeroImage(cs),

                // ─── 2. معلومات الفندق ───
                _buildHotelInfo(theme, cs),

                // ─── 3. المرافق ───
                _buildAmenities(theme, cs),

                // ─── 4. الغرف ───
                _buildRoomsSection(theme, cs),

                // ─── 5. التواريخ ───
                _buildDatesSection(theme, cs),

                // ─── 6. عدد الضيوف ───
                _buildGuestsSection(theme, cs),

                // ─── 7. الرمز الترويجي ───
                _buildPromoSection(theme, cs),

                // ─── 8. طريقة الدفع ───
                _buildPaymentSection(theme, cs),

                // ─── 9. ملخص الحجز ───
                _buildBookingSummary(theme, cs),

                // ─── 10. الفوتر ───
                _buildFooter(theme),
              ],
            ),
            // Loading overlay — isolated Obx scope
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }

  // ─────────────────── 1. صورة الفندق ───────────────────
  Widget _buildHeroImage(ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          // الصورة
          SizedBox(
            height: 260.h,
            width: double.infinity,
            child: Obx(() {
              final images = controller.hotelImages;
              if (images.isEmpty) {
                return Container(color: cs.surfaceContainerHighest);
              }
              return PageView.builder(
                itemCount: images.length,
                onPageChanged: (i) => controller.currentImageIndex.value = i,
                itemBuilder: (_, i) => CachedNetworkImage(
                  imageUrl: images[i],
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: cs.surfaceContainerHighest),
                  errorWidget: (_, __, ___) =>
                      Container(color: cs.surfaceContainerHighest),
                ),
              );
            }),
          ),
          // تدرج أسفل الصورة
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                ),
              ),
            ),
          ),
          // زر الرجوع
          Positioned(
            top: MediaQuery.of(Get.context!).padding.top + 8.h,
            right: 8.w,
            child: _iconCircle(Iconsax.arrow_right_1, onTap: () => Get.back()),
          ),
          // أزرار المفضلة والمشاركة
          // Positioned(
          //   top: MediaQuery.of(Get.context!).padding.top + 8.h,
          //   left: 8.w,
          //   child: Row(
          //     children: [
          //       _iconCircle(Iconsax.heart, onTap: () {}),
          //       SizedBox(width: 8.w),
          //       _iconCircle(Iconsax.share, onTap: () {}),
          //     ],
          //   ),
          // ),
          // عداد الصور
          Positioned(
            bottom: 12.h,
            right: 12.w,
            child: Obx(() {
              final total = controller.hotelImages.length;
              if (total <= 1) return const SizedBox.shrink();
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  '${controller.currentImageIndex.value + 1}/$total',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _iconCircle(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20.sp, color: Colors.black87),
      ),
    );
  }

  // ─────────────────── 2. معلومات الفندق ───────────────────
  Widget _buildHotelInfo(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                controller.hotelName.value,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
            ),
            SizedBox(height: 6.h),
            Obx(
              () => Row(
                children: [
                  Icon(Iconsax.star1, size: 16.sp, color: AppColors.star),
                  SizedBox(width: 4.w),
                  Text(
                    '${controller.hotelRating.value.toStringAsFixed(1)} (${controller.hotelReviews.value} تقييم)',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: cs.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            Obx(
              () => Text(
                controller.hotelAddress.value,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Divider(height: 1, color: cs.outlineVariant),
          ],
        ),
      ),
    );
  }

  // ─────────────────── 3. المرافق ───────────────────
  Widget _buildAmenities(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Obx(() {
        final features = controller.hotelFeatures;
        if (features.isEmpty) return const SizedBox.shrink();
        final displayFeatures = features.take(4).toList();
        final remaining = features.length - 4;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: [
              if (remaining > 0)
                _amenityChip(cs, Iconsax.more, '+$remaining المزيد'),
              ...displayFeatures.map((f) => _amenityChip(cs, f.icon, f.label)),
            ],
          ),
        );
      }),
    );
  }

  Widget _amenityChip(ColorScheme cs, IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18.sp, color: cs.primary),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: cs.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ─────────────────── 4. الغرف ───────────────────
  Widget _buildRoomsSection(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            child: Text('الغرف', style: theme.textTheme.titleMedium),
          ),
          SizedBox(
            height: 175.h,
            child: Obx(() {
              if (controller.resources.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد غرف متاحة',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                );
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.resources.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (_, i) {
                  final r = controller.resources[i];
                  final id = int.tryParse(r['id']?.toString() ?? '') ?? 0;
                  final selected = controller.selectedResourceId.value == id;
                  return _buildRoomCard(theme, cs, r, selected, id);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(
    ThemeData theme,
    ColorScheme cs,
    Map<String, dynamic> room,
    bool selected,
    int id,
  ) {
    final name = room['name']?.toString() ?? '';
    final desc = room['description']?.toString() ?? '';
    final priceStr = room['base_price']?.toString() ?? '0';
    final image = room['image']?.toString() ?? '';

    return GestureDetector(
      onTap: () => controller.selectResource(id),
      child: Container(
        width: 280.w,
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // صورة الغرفة
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              child: SizedBox(
                width: 110.w,
                height: double.infinity,
                child: image.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: image,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: cs.surfaceContainerHighest),
                        errorWidget: (_, __, ___) =>
                            Container(color: cs.surfaceContainerHighest),
                      )
                    : Container(color: cs.surfaceContainerHighest),
              ),
            ),
            // تفاصيل الغرفة
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Expanded(
                      child: Text(
                        desc,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: cs.onSurface.withValues(alpha: 0.6),
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      '$priceStr ر.ق',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: cs.primary,
                      ),
                    ),
                    Text(
                      'شامل الضرائب والرسوم',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: cs.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── 5. التواريخ ───────────────────
  Widget _buildDatesSection(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _dateField(
                    cs,
                    'من تاريخ',
                    controller.dateFromController,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _dateField(
                    cs,
                    'إلى تاريخ',
                    controller.dateToController,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Obx(
              () => Text(
                '${controller.nightCount} ${controller.nightCount == 1 ? 'ليلة' : 'ليالي'}',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: cs.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateField(
    ColorScheme cs,
    String label,
    TextEditingController textCtrl,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: cs.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: Get.context!,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              final formatted = date.toIso8601String().split('T').first;
              textCtrl.text = formatted;
              // Sync reactive mirrors
              if (textCtrl == controller.dateFromController) {
                controller.dateFrom.value = formatted;
              } else {
                controller.dateTo.value = formatted;
              }
              controller.available.value = null;
              controller.price.value = null;
              controller.onDatesChanged();
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: cs.outlineVariant),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(Iconsax.calendar_1, size: 16.sp, color: cs.primary),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    textCtrl.text,
                    style: TextStyle(fontSize: 14.sp, color: cs.onSurface),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ─────────────────── 6. عدد الضيوف ───────────────────
  Widget _buildGuestsSection(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('عدد الضيوف', style: theme.textTheme.titleMedium),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                border: Border.all(color: cs.outlineVariant),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _guestButton(Iconsax.minus, controller.decrementGuests),
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        '${controller.guests.value}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: cs.onSurface,
                        ),
                      ),
                    ),
                  ),
                  _guestButton(Iconsax.add, controller.incrementGuests),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _guestButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor.withValues(alpha: 0.1),
        ),
        child: Icon(icon, size: 16.sp, color: AppColors.primaryColor),
      ),
    );
  }

  // ─────────────────── 7. الرمز الترويجي ───────────────────
  Widget _buildPromoSection(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => controller.showPromoInput.toggle(),
              child: Row(
                children: [
                  Icon(Iconsax.discount_shape, size: 20.sp, color: cs.primary),
                  SizedBox(width: 8.w),
                  Text(
                    'لديك رمز ترويجي؟',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Obx(
                    () => Icon(
                      controller.showPromoInput.value
                          ? Iconsax.arrow_up_2
                          : Iconsax.arrow_down_1,
                      size: 18.sp,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            Obx(() {
              if (!controller.showPromoInput.value)
                return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.promoCodeController,
                        decoration: InputDecoration(
                          hintText: 'أدخل الرمز',
                          hintStyle: TextStyle(
                            fontSize: 13.sp,
                            color: cs.onSurface.withValues(alpha: 0.4),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: cs.outlineVariant),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(color: cs.outlineVariant),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cs.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'تطبيق',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: cs.onPrimary,
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
      ),
    );
  }

  // ─────────────────── 8. طريقة الدفع ───────────────────
  Widget _buildPaymentSection(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('طريقة الدفع', style: theme.textTheme.titleMedium),
            SizedBox(height: 8.h),
            Obx(() {
              final methods = controller.checkout.value.paymentMethods;
              final allMethods = methods.isNotEmpty
                  ? methods
                  : <String>['wallet', 'cash'];
              // Ensure Apple Pay & Google Pay are displayed
              final extendedMethods = <String>[...allMethods];
              if (!extendedMethods.contains('apple_pay')) {
                extendedMethods.add('apple_pay');
              }
              if (!extendedMethods.contains('google_pay')) {
                extendedMethods.add('google_pay');
              }
              final sel = controller.selectedPayment.value;
              return Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: extendedMethods.map((m) {
                  final isSelected = sel == m;
                  return _paymentChip(cs, m, isSelected, () {
                    controller.selectedPayment.value = m;
                  });
                }).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _paymentChip(
    ColorScheme cs,
    String method,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final (IconData icon, String label) = switch (method) {
      'cash' => (Iconsax.moneys, 'نقداً'),
      'wallet' => (Iconsax.wallet_2, 'المحفظة'),
      'card' => (Iconsax.card, 'بطاقة'),
      'apple_pay' => (Iconsax.wallet, 'Apple Pay'),
      'google_pay' => (Iconsax.money, 'Google Pay'),
      _ => (Iconsax.wallet_2, method),
    };

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withValues(alpha: 0.1) : cs.surface,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected
                  ? cs.primary
                  : cs.onSurface.withValues(alpha: 0.6),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── 9. ملخص الحجز ───────────────────
  Widget _buildBookingSummary(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.all(16.w),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: cs.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // السعر
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  final tp = controller.totalPrice;
                  if (tp == null) {
                    final selected = controller.resources.firstWhereOrNull(
                      (r) =>
                          int.tryParse(r['id']?.toString() ?? '') ==
                          controller.selectedResourceId.value,
                    );
                    final base = selected?['base_price']?.toString() ?? '—';
                    return Text(
                      '$base ر.ق',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: cs.onSurface,
                      ),
                    );
                  }
                  return Text(
                    '${tp.toStringAsFixed(2)} ر.ق',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: cs.onSurface,
                    ),
                  );
                }),
              ],
            ),
            SizedBox(height: 4.h),
            Text(
              'الإجمالي شامل الضرائب',
              style: TextStyle(
                fontSize: 12.sp,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
            SizedBox(height: 16.h),
            // زر التأكيد
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'تأكيد الحجز',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.information,
                  size: 14.sp,
                  color: cs.onSurface.withValues(alpha: 0.4),
                ),
                SizedBox(width: 4.w),
                Text(
                  'لن يتم خصم أي مبلغ الآن',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: cs.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── 10. الفوتر ───────────────────
  Widget _buildFooter(ThemeData theme) {
    final cs = theme.colorScheme;
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _footerItem(
              cs,
              Iconsax.close_circle,
              'إلغاء مجاني',
              'حتى 24 ساعة قبل الوصول',
            ),
            _footerItem(
              cs,
              Iconsax.shield_tick,
              'دفع آمن',
              'تشفير وحماية عالية',
            ),
            _footerItem(
              cs,
              Iconsax.discount_shape,
              'أفضل سعر مضمون',
              'تحصل على أفضل الأسعار',
            ),
          ],
        ),
      ),
    );
  }

  Widget _footerItem(
    ColorScheme cs,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 22.sp, color: AppColors.primaryColor),
          SizedBox(height: 4.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              color: cs.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
