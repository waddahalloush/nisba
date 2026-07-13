import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'my_cars_controller.dart';

class MyCarsScreen extends GetView<MyCarsController> {
  const MyCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header banner ──
              _buildHeaderBanner(theme),

              // ── Body ──
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    // ── Existing cars list ──
                    _buildCarsList(theme),

                    SizedBox(height: 16.h),

                    // ── Add car form ──
                    _buildAddCarForm(theme),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner(ThemeData theme) {
    final cs = theme.colorScheme;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 28.h),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(36.r),
              bottomRight: Radius.circular(36.r),
            ),
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.only(top: 8.h),
              child: Text(
                'سياراتي',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 44.h,
          right: 8.w,
          child: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Iconsax.arrow_right_1, color: cs.onPrimary),
            style: IconButton.styleFrom(
              backgroundColor: cs.onPrimary.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarsList(ThemeData theme) {
    final cs = theme.colorScheme;

    return Obx(
      () => Column(
        children: List.generate(controller.cars.length, (index) {
          final car = controller.cars[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Container(
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
              child: Row(
                children: [
                  // Car photo
                  Container(
                    width: 64.w,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Iconsax.car, color: cs.primary, size: 28.sp),
                  ),
                  SizedBox(width: 12.w),

                  // Plate + brand info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.plateNumber,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${car.brand} - ${car.category}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          car.color,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: cs.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Delete button
                  GestureDetector(
                    onTap: () => controller.deleteCar(index),
                    child: Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(
                        Iconsax.trash,
                        color: cs.primary,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddCarForm(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24.r),
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
            'إضافة سيارة',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
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
              controller: controller.plateController,
              style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface),
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
              onPressed: controller.addCar,
              icon: Icon(Iconsax.add_circle, size: 20.sp),
              label: Text(
                'إضافة سيارة',
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
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
