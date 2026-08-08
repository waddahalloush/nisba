import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:nisba_app/src/services/locale_service.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'addresses_controller.dart';

class AddressesScreen extends GetView<AddressesController> {
  const AddressesScreen({super.key});

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
            'addresses'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: controller.showAddDialog,
          backgroundColor: cs.primary,
          child: Icon(Iconsax.add, color: cs.onPrimary),
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.addresses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.addresses.isEmpty) {
            return Center(
              child: Text(
                'auto_key_31'.tr,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.6),
                ),
              ),
            );
          }
          return ListView.separated(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 80.h),
            itemCount: controller.addresses.length,
            separatorBuilder: (_, __) => SizedBox(height: 10.h),
            itemBuilder: (context, index) {
              final address = controller.addresses[index];
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
                child: Row(
                  children: [
                    Container(
                      width: 42.w,
                      height: 42.h,
                      decoration: BoxDecoration(
                        color: cs.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Iconsax.location,
                        color: cs.primary,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            address.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            [
                              address.type,
                              address.street,
                              address.info,
                            ].where((e) => e.isNotEmpty).join(' • '),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                          if (address.phone.isNotEmpty)
                            Text(
                              address.phone,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: cs.onSurface.withValues(alpha: 0.55),
                              ),
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.deleteAddress(address),
                      icon: Icon(Iconsax.trash, color: cs.error, size: 20.sp),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
