import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../../generated/assets.gen.dart';
import 'gift_credit_controller.dart';

class GiftCreditScreen extends GetView<GiftCreditController> {
  const GiftCreditScreen({super.key});

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
            'إهداء رصيد',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomButton(theme),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Tab bar ──
              _buildTabBar(theme),

              SizedBox(height: 20.h),

              // ── Tab content ──
              Obx(() {
                if (controller.selectedTab.value == 1) {
                  return _buildQRCodeTab(theme);
                }
                return _buildPhoneTab(theme);
              }),

              SizedBox(height: 24.h),

              // ── Notice ──
              _buildNotice(theme),

              SizedBox(height: 20.h),

              // ── Preset amounts ──
              _buildAmountsSection(theme),

              SizedBox(height: 20.h),

              // ── Note field ──
              _buildNoteField(theme),

              SizedBox(height: 16.h),

              // ── Security reassurance ──
              _buildSecurityLine(theme),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Obx(
        () => Row(
          children: [
            _TabChip(
              label: 'رقم الهاتف',
              icon: Icons.mobile_screen_share,
              isSelected: controller.selectedTab.value == 0,
              onTap: () => controller.selectTab(0),
            ),
            SizedBox(width: 4.w),
            _TabChip(
              label: 'QR Code',
              icon: Icons.qr_code,
              isSelected: controller.selectedTab.value == 1,
              onTap: () => controller.selectTab(1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQRCodeTab(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
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
          Assets.images.qrCode.image(width: 50, height: 50),
          SizedBox(height: 12.h),
          Text(
            'اطلب من المستلم مسح الرمز',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneTab(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: IntlPhoneField(
          controller: controller.phoneController,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: 'phone_number_hint'.tr,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            filled: true,
            fillColor: theme.colorScheme.surface,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: cs.primary, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: cs.primary, width: 2.0),
            ),
          ),
          initialCountryCode: 'QA',
          disableLengthCheck: true,
          dropdownIconPosition: IconPosition.trailing,
          dropdownIcon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.colorScheme.onSurface,
          ),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          onChanged: (phone) {
            controller.phoneNumber.value = phone.completeNumber;
          },
        ),
      ),
    );
  }

  Widget _buildNotice(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Iconsax.info_circle, color: cs.primary, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'سيتم إرسال رسالة للمستلم تحتوي على رصيد الإهداء',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountsSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر المبلغ',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              ...controller.presetAmounts.map(
                (amount) => _AmountChip(
                  label: '${amount.toInt()} ر.ق',
                  isSelected: controller.selectedAmount.value == amount,
                  onTap: () => controller.selectAmount(amount),
                ),
              ),
              // _AmountChip(
              //   label: 'مبلغ آخر',
              //   isSelected: controller.selectedAmount.value == 0,
              //   onTap: controller.clearAmount,
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoteField(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملاحظة (اختياري)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: cs.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: cs.shadow.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller.noteController,
            maxLength: controller.maxNoteLength,
            maxLines: 2,
            style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
            decoration: InputDecoration(
              hintText: 'اكتب ملاحظة للمستلم...',
              hintStyle: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.35),
                fontSize: 12.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(14.r),
              counterStyle: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.35),
                fontSize: 10.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityLine(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Assets.images.privacy.image(width: 35.w, height: 35.h),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'عملية آمنة و سريعة \n رصيد الإهداء يصل فورا للمستلم',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      color: cs.surfaceContainerHighest,
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: controller.proceed,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          child: Text(
            'التالي',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? cs.primary.withAlpha(30) : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15.sp,
                color: isSelected
                    ? cs.primary
                    : cs.onSurface.withValues(alpha: 0.5),
              ),
              SizedBox(width: 8.w),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected
                      ? cs.primary
                      : cs.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AmountChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary : cs.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? cs.onPrimary : cs.onSurface,
          ),
        ),
      ),
    );
  }
}
