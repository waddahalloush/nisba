import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'recharge_wallet_controller.dart';

class RechargeWalletScreen extends GetView<RechargeWalletController> {
  const RechargeWalletScreen({super.key});

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
            'شحن الرصيد',
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
              SizedBox(height: 8.h),

              // ── Amount input ──
              _buildAmountInput(theme),

              SizedBox(height: 8.h),

              // ── Min amount hint ──
              _buildMinAmountHint(theme),

              SizedBox(height: 24.h),

              // ── Preset amount grid ──
              _buildPresetGrid(theme),

              SizedBox(height: 24.h),

              // ── Payment method section ──
              _buildPaymentMethodSection(theme),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInput(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المبلغ',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: 10.h),
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
            controller: controller.amountController,
            keyboardType: TextInputType.number,
            onChanged: controller.onAmountChanged,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: cs.onSurface,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: cs.primary.withAlpha(15),
              hintText: 'أدخل المبلغ 0.00 (ر.ق)',
              hintStyle: TextStyle(
                color: cs.onSurface.withValues(alpha: 0.3),
                fontSize: 14.sp,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              suffixIcon: Container(
                margin: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Iconsax.wallet_2, color: cs.primary, size: 20.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMinAmountHint(ThemeData theme) {
    final cs = theme.colorScheme;

    return Row(
      children: [
        Icon(Iconsax.info_circle, color: cs.onSurface, size: 14.sp),
        SizedBox(width: 6.w),
        Text(
          'الحد الأدنى للشحن: ${controller.minAmount.toInt()} (ر.ق)',
          style: TextStyle(fontSize: 11.sp, color: cs.onSurface),
        ),
      ],
    );
  }

  Widget _buildPresetGrid(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        children: controller.presetAmounts.map((amount) {
          final isSelected = controller.selectedAmount.value == amount;
          final fraction =
              0.5 - (controller.presetAmounts.indexOf(amount) * 0.12);

          return SizedBox(
            width: (Get.width - 32.w - 20.w) / 3,
            child: _PresetCard(
              amount: amount.toInt(),
              isSelected: isSelected,
              onTap: () => controller.selectAmount(amount),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentMethodSection(ThemeData theme) {
    final cs = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الشحن من خلال',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(14.r),
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
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Iconsax.card, color: cs.primary, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'اختر طريقة الشحن المناسبة لك',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              Icon(
                Iconsax.arrow_left_2,
                color: cs.onSurface.withValues(alpha: 0.3),
                size: 18.sp,
              ),
            ],
          ),
        ),
      ],
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

class _PresetCard extends StatelessWidget {
  final int amount;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetCard({
    required this.amount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: isSelected ? cs.primary.withValues(alpha: 0.06) : cs.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? cs.primary
                : cs.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.12),

                shape: BoxShape.circle,
              ),
              child: isSelected
                  ? Icon(Iconsax.tick_circle, color: cs.primary, size: 24.sp)
                  : Icon(Iconsax.dollar_square, color: cs.primary, size: 22.sp),
            ),
            SizedBox(height: 8.h),

            // Amount
            Text(
              '(ر.ق) $amount',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? cs.primary : cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
