// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
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
  // ---- بيانات البروفايل ----
  final userName = 'محمد عبيد';
  final userPhone = '196151974179';
  final walletPoints = 0;
  final appVersion = '1.0.0';
  final appName = 'تطبيق نسبة';
  final selectedPaymentMethod = 'المحفظة'.obs;
  final myPoints = 0.obs;

  // ---- إجراءات سريعة ----
  final quickActions = [
    QuickAction(
      label: 'مكافآت',
      icon: Iconsax.gift,
      onTap: () {
        Get.toNamed(AppRoutesNames.points);
      },
    ),
    QuickAction(
      label: 'القسائم والعروض',
      icon: Iconsax.card,
      onTap: () {
        Get.toNamed(AppRoutesNames.coupon);
      },
    ),
    QuickAction(
      label: 'المفضلة',
      icon: Iconsax.heart,
      onTap: () {
        Get.toNamed(AppRoutesNames.favorite);
      },
    ),
    QuickAction(
      label: 'سيارتي',
      icon: Iconsax.car,
      onTap: () {
        Get.toNamed(AppRoutesNames.myCars);
      },
    ),
    QuickAction(
      label: 'التقارير',
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
        title: 'هدية ترحيبية',
        subtitle: '100',
        isPoints: true,
        buttonLabel: 'استخدم الآن',
        bgColor: const Color(0xff67021e),
        icon: Assets.images.gift.path,
      ),

      RewardModel(
        title: 'استرجاع نقدي',
        subtitle: '15%',
        buttonLabel: 'استخدم الآن',
        bgColor: Colors.black,
        icon: Assets.images.giftMoney.path,
      ),
      RewardModel(
        title: 'خصم خاص',
        subtitle: '25%',
        buttonLabel: 'استخدم الآن',
        bgColor: Colors.black,
        icon: Assets.images.money.path,
      ),
    ];
  }

  List<SettingsItem> _buildSettings() {
    return [
     
      SettingsItem(
        title: 'مركز المساعدة',
        icon: Icons.help_outline_rounded,
        onTap: () {
          Get.toNamed(AppRoutesNames.support);
        },
      ),
      SettingsItem(
        title: 'عن التطبيق',
        icon: Icons.info_outline_rounded,
        onTap: () {
          Get.toNamed(AppRoutesNames.about);
        },
      ),
      SettingsItem(
        title: 'الشروط والخدمات',
        icon: Icons.description_outlined,
        onTap: () {
          Get.toNamed(AppRoutesNames.privacy);
        },
      ),

      SettingsItem(
        title: 'الأسئلة الشائعة',
        icon: Icons.quiz_outlined,
        onTap: () {
          Get.toNamed(AppRoutesNames.faq);
        },
      ),
      const SettingsItem(title: 'أبدِ رأيك', icon: Icons.rate_review_outlined),
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


