import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          icon: Icon(Iconsax.arrow_right_1, color: cs.primary),
        ),
        title: Text(
          "الخدمات",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(4.w),
        itemCount: controller.homeServiceList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 4.w,
          crossAxisSpacing: 4.w,
          childAspectRatio: 9 / 12,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: controller.homeServiceList[index].onTap,
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
                        color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(
                        controller.homeServiceList[index].catIcon,
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  controller.homeServiceList[index].catName,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.87),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
