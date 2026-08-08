import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/AllServices/all_home_services_controller.dart';

class AllHomeServicesScreen extends GetView<AllHomeServicesController> {
  const AllHomeServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(backIconData(context), color: cs.primary),
        ),
        title: Text(
          'auto_key_294'.tr,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.homeServiceList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.homeServiceList.isEmpty) {
          return Center(
            child: TextButton(
              onPressed: controller.loadSections,
              child: Text('auto_key_243'.tr),
            ),
          );
        }
        return GridView.builder(
          padding: EdgeInsets.all(4.w),
          itemCount: controller.homeServiceList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 4.w,
            crossAxisSpacing: 4.w,
            childAspectRatio: 9 / 12,
          ),
          itemBuilder: (context, index) {
            final item = controller.homeServiceList[index];
            return GestureDetector(
              onTap: item.onTap,
              child: Container(
                width: 81.w,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                child: Column(
                  children: [
                    Container(
                      height: 75.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(18.r),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.shadow
                                .withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: item.isNetworkIcon
                          ? CachedNetworkImage(
                              imageUrl: item.catIcon,
                              fit: BoxFit.cover,
                              errorWidget: (_, __, ___) => Icon(
                                Iconsax.category,
                                color: cs.primary,
                              ),
                            )
                          : Image.asset(item.catIcon, fit: BoxFit.contain),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      item.catName,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.87),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
