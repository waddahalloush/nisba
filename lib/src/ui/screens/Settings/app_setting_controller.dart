// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import '../../../../generated/assets.gen.dart';

/// نموذج المكافأة
class RewardModel {
  final String title;
  final String subtitle;
  final bool isPoints;
  final String buttonLabel;
  final Color bgColor;
  final String icon;

  const RewardModel({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.bgColor,
    required this.icon,
    this.isPoints = false,
  });
}

/// نموذج عنصر الإعدادات
class SettingsItem {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const SettingsItem({required this.title, required this.icon, this.onTap});
}

class AppSettingController extends GetxController {
  final _storage = Get.find<GetStorageHelper>();

  // ---- بيانات البروفايل ----
  String get userName {
    final user = _storage.getUser;
    if (user == null) return '';
    return user.name ?? '${user.fName ?? ''} ${user.lName ?? ''}'.trim();
  }

  String get userPhone {
    final user = _storage.getUser;
    return user?.phone ?? '';
  }

  String get userImage {
    final user = _storage.getUser;
    return user?.image ?? '';
  }

  final walletPoints = 0;
  final appVersion = '1.0.0';
  final appName = 'nisba_app_name'.tr;
  final selectedPaymentMethod = 'wallet'.tr.obs;
  final myPoints = 0.obs;

  // ---- إجراءات سريعة ----
  final quickActions = [
    QuickAction(
      label: 'rewards'.tr,
      icon: Iconsax.gift,
      onTap: () {
        Get.toNamed(AppRoutesNames.points);
      },
    ),
    QuickAction(
      label: 'coupons'.tr,
      icon: Iconsax.card,
      onTap: () {
        Get.toNamed(AppRoutesNames.coupon);
      },
    ),
    QuickAction(
      label: 'favorite'.tr,
      icon: Iconsax.heart,
      onTap: () {
        Get.toNamed(AppRoutesNames.favorite);
      },
    ),
    QuickAction(
      label: 'my_cars'.tr,
      icon: Iconsax.car,
      onTap: () {
        Get.toNamed(AppRoutesNames.myCars);
      },
    ),
    QuickAction(
      label: 'reports'.tr,
      icon: Iconsax.document,
      onTap: () {
        Get.toNamed(AppRoutesNames.report);
      },
    ),
  ];

  // ---- المكافآت ----
  late final List<RewardModel> rewards;

  // ---- عناصر الإعدادات ----
  late final List<SettingsItem> settingsItems;

  @override
  void onInit() {
    super.onInit();
    rewards = _buildRewards();
    settingsItems = _buildSettings();
  }

  List<RewardModel> _buildRewards() {
    return [
      RewardModel(
        title: 'welcome_gift'.tr,
        subtitle: '100',
        isPoints: true,
        buttonLabel: 'use_now'.tr,
        bgColor: const Color(0xff67021e),
        icon: Assets.images.gift.path,
      ),

      RewardModel(
        title: 'cashback'.tr,
        subtitle: '15%',
        buttonLabel: 'use_now'.tr,
        bgColor: Colors.black,
        icon: Assets.images.giftMoney.path,
      ),
      RewardModel(
        title: 'special_discount'.tr,
        subtitle: '25%',
        buttonLabel: 'use_now'.tr,
        bgColor: Colors.black,
        icon: Assets.images.money.path,
      ),
    ];
  }

  List<SettingsItem> _buildSettings() {
    return [
      SettingsItem(
        title: 'help_center'.tr,
        icon: Icons.help_outline_rounded,
        onTap: () {
          Get.toNamed(AppRoutesNames.support);
        },
      ),
      SettingsItem(
        title: 'inbox_messages'.tr,
        icon: Iconsax.message,
        onTap: () {
          Get.toNamed(AppRoutesNames.inbox);
        },
      ),
      SettingsItem(
        title: 'about_app'.tr,
        icon: Icons.info_outline_rounded,
        onTap: () {
          Get.toNamed(AppRoutesNames.about);
        },
      ),
      SettingsItem(
        title: 'terms_and_services'.tr,
        icon: Icons.description_outlined,
        onTap: () {
          Get.toNamed(AppRoutesNames.privacy);
        },
      ),

      SettingsItem(
        title: 'faqs'.tr,
        icon: Icons.quiz_outlined,
        onTap: () {
          Get.toNamed(AppRoutesNames.faq);
        },
      ),
      SettingsItem(title: 'give_feedback'.tr, icon: Icons.rate_review_outlined),
    ];
  }
}

/// نموذج داخلي للإجراءات السريعة
class QuickAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
