import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/ui/screens/Settings/widgets/app_footer.dart';
import 'package:nisba_app/src/ui/screens/Settings/widgets/profile_header.dart';
import 'package:nisba_app/src/ui/screens/Settings/widgets/quick_actions_row.dart';
import 'package:nisba_app/src/ui/screens/Settings/widgets/rewards_section.dart';
import 'package:nisba_app/src/ui/screens/Settings/widgets/section_card.dart';
import 'package:nisba_app/src/ui/screens/Settings/widgets/settings_list.dart';
import 'package:nisba_app/src/ui/screens/Settings/widgets/wallet_orders_card.dart';

import 'app_setting_controller.dart';

class AppSettingScreen extends GetView<AppSettingController> {
  const AppSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        body: CustomScrollView(
          slivers: [
            // 1. هيدر + قسم المكافآت متراكبين
            SliverToBoxAdapter(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // الطبقة السفلية: الهيدر
                  ProfileHeader(
                    userName: controller.userName,
                    userPhone: controller.userPhone,
                    onSettingsTap: () {
                      Get.toNamed(AppRoutesNames.accountSetting);
                    },
                  ),
                  // الطبقة العلوية: قسم المكافآت يتراكب أسفل الهيدر
                  Positioned(
                    bottom: -85.h,
                    left: 16.w,
                    right: 16.w,
                    child: SectionCard(
                      margin: const EdgeInsets.all(0),
                      padding: EdgeInsets.all(8.h),

                      child: RewardsSection(rewards: controller.rewards),
                    ),
                  ),
                ],
              ),
            ),

            // 2. باقي المحتوى
            SliverList(
              delegate: SliverChildListDelegate([
                // مسافة لتعويض التداخل
                SizedBox(height: 100.h),

                // --- الإجراءات السريعة ---
                Transform.translate(
                  offset: Offset(0, -12.h),
                  child: SectionCard(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.r,
                      vertical: 6.h,
                    ),
                    child: QuickActionsRow(actions: controller.quickActions),
                  ),
                ),

                // --- المحفظة + الطلبات السابقة ---
                Transform.translate(
                  offset: Offset(0, -10.h),
                  child: SectionCard(
                    padding: EdgeInsets.all(12.r),
                    child: WalletOrdersCard(
                      walletPoints: controller.walletPoints,
                    ),
                  ),
                ),

                // --- قائمة الإعدادات ---
                Transform.translate(
                  offset: Offset(0, -10.h),
                  child: SectionCard(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    child: SettingsList(items: controller.settingsItems),
                  ),
                ),

                // --- فوتر التطبيق ---
                AppFooter(
                  appName: controller.appName,
                  appVersion: controller.appVersion,
                ),
                SizedBox(height: 24.h),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
