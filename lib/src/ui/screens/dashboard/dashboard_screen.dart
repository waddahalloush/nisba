import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/ui/screens/scanner/scanner_screen.dart';

import '../Home/home_screen.dart';
import '../Order/order_screen.dart';
import '../Settings/app_setting_screen.dart';
import '../search/search_screen.dart';
import 'dashboard_controller.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  static final List<Widget> _tabs = [
    const HomeScreen(), // 0: الرئيسية
    const OrderScreen(), // 1: الطلبات
    const ScannerScreen(), // 2: الأوسط
    const SearchScreen(), // 3: بحث
    const AppSettingScreen(), // 4: المزيد
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() => _tabs[controller.currentIndex.value]),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(top: 50.h),
          child: GestureDetector(
            onTap: () => controller.changeTabIndex(2),
            child: Container(
              width: 50.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Iconsax.scan4,
                color: theme.colorScheme.onPrimary,
                size: 26.sp,
              ),
            ),
          ),
        ),

        bottomNavigationBar: Theme(
          data: context.theme.copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: Container(
            height: 60.h,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
              child: BottomAppBar(
                padding: const EdgeInsets.all(0),
                color: theme.colorScheme.surface,
                elevation: 0,
                notchMargin: 10.r,
                shape: const CircularNotchedRectangle(),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTabItem(
                      context,
                      index: 0,
                      label: 'الرئيسية',
                      icon: Iconsax.home_1,
                    ),
                    _buildTabItem(
                      context,
                      index: 1,
                      label: 'الطلبات',
                      icon: Iconsax.bag_24,
                    ),
                    SizedBox(width: 45.w),
                    _buildTabItem(
                      context,
                      index: 3,
                      label: 'بحث',
                      icon: Iconsax.search_normal_14,
                    ),
                    _buildTabItem(
                      context,
                      index: 4,
                      label: 'المزيد',
                      icon: Icons.more_horiz_rounded,
                      onTap: () => Get.toNamed(AppRoutesNames.appSetting),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(
    BuildContext context, {
    required int index,
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final inactiveColor = theme.colorScheme.onSurface.withValues(alpha: 0.55);

    return InkWell(
      onTap: onTap ?? () => controller.changeTabIndex(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: 60.w,
        child: Obx(() {
          final bool isSelected = controller.currentIndex.value == index;
          final color = isSelected ? primaryColor : inactiveColor;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22.sp),
              SizedBox(height: 3.h),
              Text(
                label,
                style: context.theme.textTheme.labelSmall?.copyWith(
                  color: color,
                  fontSize: 10.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
