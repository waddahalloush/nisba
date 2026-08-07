import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'entertainment_booking_controller.dart';

class EntertainmentBookingScreen
    extends GetView<EntertainmentBookingController> {
  const EntertainmentBookingScreen({super.key});

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
                _buildHeroImage(cs),
                _buildVenueInfo(theme, cs),
                _buildFeatures(theme, cs),
                _buildSlotsSection(theme, cs),
                _buildGuestsSection(theme, cs),
                _buildPaymentSection(theme, cs),
                _buildBookingSummary(theme, cs),
                _buildFooter(theme),
              ],
            ),
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

  // ─────────────────── 1. صورة المكان ───────────────────
  Widget _buildHeroImage(ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          SizedBox(
            height: 240.h,
            width: double.infinity,
            child: Obx(() {
              final images = controller.venueImages;
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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.5),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(Get.context!).padding.top + 8.h,
            right: 8.w,
            child: _iconCircle(Iconsax.arrow_right_1, onTap: () => Get.back()),
          ),
          Positioned(
            bottom: 12.h,
            right: 12.w,
            child: Obx(() {
              final total = controller.venueImages.length;
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

  // ─────────────────── 2. معلومات المكان ───────────────────
  Widget _buildVenueInfo(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                controller.venueName.value,
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
                    '${controller.venueRating.value.toStringAsFixed(1)} (${controller.venueReviews.value} تقييم)',
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
                controller.venueAddress.value,
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

  // ─────────────────── 3. المميزات ───────────────────
  Widget _buildFeatures(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Obx(() {
        final features = controller.venueFeatures;
        if (features.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Wrap(
            spacing: 16.w,
            runSpacing: 8.h,
            children: features
                .map(
                  (f) => Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(f.icon, size: 18.sp, color: cs.primary),
                      SizedBox(width: 4.w),
                      Text(
                        f.label,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: cs.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        );
      }),
    );
  }

  // ─────────────────── 4. المواعيد ───────────────────
  Widget _buildSlotsSection(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
            child: Text('المواعيد المتاحة', style: theme.textTheme.titleMedium),
          ),
          SizedBox(
            height: 155.h,
            child: Obx(() {
              if (controller.slots.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد مواعيد متاحة',
                    style: TextStyle(
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                );
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: controller.slots.length,
                separatorBuilder: (_, __) => SizedBox(width: 12.w),
                itemBuilder: (_, i) {
                  final s = controller.slots[i];
                  final id = int.tryParse(s['id']?.toString() ?? '') ?? 0;
                  final selected = controller.selectedSlotId.value == id;
                  return _buildSlotCard(cs, s, selected, id);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSlotCard(
    ColorScheme cs,
    Map<String, dynamic> slot,
    bool selected,
    int id,
  ) {
    final date = slot['date']?.toString() ?? '';
    final start = slot['start_time']?.toString() ?? '';
    final end = slot['end_time']?.toString() ?? '';
    final priceStr = slot['price']?.toString() ?? '—';
    final remaining = slot['remaining']?.toString() ?? '—';

    return GestureDetector(
      onTap: () => controller.selectSlot(id),
      child: Container(
        width: 200.w,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? cs.primary : cs.outlineVariant,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: cs.shadow.withValues(alpha: 0.06),
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
                Icon(Iconsax.calendar_1, size: 16.sp, color: cs.primary),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    date,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Iconsax.clock,
                  size: 16.sp,
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
                SizedBox(width: 6.w),
                Text(
                  '$start - $end',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: cs.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$priceStr ر.ق',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '$remaining متبقي',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────── 5. عدد التذاكر ───────────────────
  Widget _buildGuestsSection(ThemeData theme, ColorScheme cs) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('عدد التذاكر', style: theme.textTheme.titleMedium),
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

  // ─────────────────── 6. طريقة الدفع ───────────────────
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

  // ─────────────────── 7. ملخص الحجز ───────────────────
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  final tp = controller.totalPrice;
                  final priceStr =
                      tp?.toStringAsFixed(2) ??
                      controller.selectedSlot?['price']?.toString() ??
                      '—';
                  return Text(
                    '$priceStr ر.ق',
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

  // ─────────────────── 8. الفوتر ───────────────────
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
              'حتى 24 ساعة قبل الموعد',
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
