// ──────────────────────────────────────────
//  Add‑Car bottom‑sheet form widget
// ──────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../my_cars_controller.dart';

class AddCarForm extends GetView<MyCarsController> {
  const AddCarForm({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: 18.w,
        right: 18.w,
        top: 18.h,
        bottom: 18.h,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle ──
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: cs.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 14.h),

            // ── Title ──
            Align(
              alignment: Alignment.center,
              child: Text(
                'إضافة سيارة',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ── Plate number input ──
            _buildDropdownRow(
              theme,
              isInput: true,
              icon: Iconsax.car,
              hint: 'رقم اللوحة',
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: controller.plateController,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'رقم اللوحة',
                  hintStyle: TextStyle(
                    color: cs.onSurface.withValues(alpha: 0.35),
                    fontSize: 13.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                ),
              ),
            ),

            SizedBox(height: 10.h),

            // ── Brand ──
            _buildDropdownRow(
              theme,
              icon: Iconsax.shield,
              label: 'الماركة',
              value: controller.selectedBrand,
              hint: 'اختر الماركة',
              onTap: controller.showBrandPicker,
            ),

            SizedBox(height: 10.h),

            // ── Category ──
            _buildDropdownRow(
              theme,
              icon: Iconsax.category,
              label: 'الفئة',
              value: controller.selectedCategory,
              hint: 'اختر الفئة',
              onTap: controller.showCategoryPicker,
            ),

            SizedBox(height: 10.h),

            // ── Color ──
            _buildDropdownRow(
              theme,
              icon: Iconsax.colorfilter,
              label: 'اللون',
              value: controller.selectedColor,
              hint: 'اختر اللون',
              onTap: controller.showColorPicker,
            ),

            SizedBox(height: 20.h),

            // ── Add button ──
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton.icon(
                onPressed: () {
                  controller.addCar();
                },
                icon: Icon(Iconsax.add_circle, size: 20.sp),
                label: Text(
                  'إضافة سيارة',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow(
    ThemeData theme, {
    required IconData icon,
    String? label,
    RxString? value,
    String? hint,
    VoidCallback? onTap,
    bool isInput = false,
    Widget? child,
  }) {
    final cs = theme.colorScheme;

    return GestureDetector(
      onTap: isInput ? null : onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w),

        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(icon, color: cs.primary, size: 20.sp),
            SizedBox(width: 10.w),
            if (isInput && child != null)
              Expanded(child: child)
            else ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (label != null)
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: cs.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    Obx(
                      () => Text(
                        value?.value.isNotEmpty == true
                            ? value!.value
                            : hint ?? '',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: value?.value.isNotEmpty == true
                              ? cs.onSurface
                              : cs.onSurface.withValues(alpha: 0.35),
                          fontWeight: value?.value.isNotEmpty == true
                              ? FontWeight.w500
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_left_2,
                color: cs.onSurface.withValues(alpha: 0.3),
                size: 18.sp,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
