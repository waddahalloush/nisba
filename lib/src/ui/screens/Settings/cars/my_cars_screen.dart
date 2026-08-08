import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'my_cars_controller.dart';

class MyCarsScreen extends GetView<MyCarsController> {
  const MyCarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surfaceContainerHighest,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.showAddCarBottomSheet();
        },
        backgroundColor: cs.onPrimary,
        child: Icon(Icons.add, color: cs.primary),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(backIconData(context), color: cs.primary),
        ),
        title: Text(
          'auto_key_580'.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Body ──
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  // ── Existing cars list ──
                  _buildCarsList(theme),

                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ],
        ),
      ),
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
}
