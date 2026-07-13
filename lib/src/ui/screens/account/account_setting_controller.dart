import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

class AccountSettingController extends GetxController {
  final userName = 'أحمد محمد'.obs;
  final userPhone = '+966 512 345 678'.obs;
  final memberSince = 'مارس 2024'.obs;

  final quickActions = <QuickAction>[
    QuickAction(
      icon: Iconsax.bag_2,
      label: 'الطلبات',
      badge: '3',
      onTap: () {},
    ),
    QuickAction(
      icon: Iconsax.heart,
      label: 'المفضلة',
      badge: '12',
      onTap: () {},
    ),
    QuickAction(icon: Iconsax.location, label: 'العناوين', onTap: () {}),
  ];

  final settingsItems = <SettingsItem>[
    SettingsItem(
      icon: Iconsax.user,
      title: 'معلومات الحساب',
      subtitle: 'الاسم، البريد الإلكتروني، رقم الهاتف',
      onTap: () {
        Get.toNamed(AppRoutesNames.userAccount);
      },
    ),
    SettingsItem(
      icon: Iconsax.card,
      title: 'إعدادات الدفع',
      subtitle: 'إدارة بطاقات الدفع والمحفظة',
      onTap: () {
        Get.toNamed(AppRoutesNames.paymentSetting);
      },
    ),
    SettingsItem(
      icon: Iconsax.notification,
      title: 'الإشعارات',
      subtitle: 'تفعيل أو إيقاف الإشعارات',
      onTap: () {},
    ),
    SettingsItem(
      icon: Iconsax.language_square,
      title: 'اللغة',
      subtitle: 'العربية',
      trailing: Iconsax.arrow_swap_horizontal,
      onTap: () {},
    ),
    SettingsItem(
      icon: Iconsax.global,
      title: 'الدولة',
      subtitle: 'دولة قطر',
      trailing: Iconsax.arrow_swap_horizontal,
      onTap: () {},
    ),
  ];

  void logout() {
    // TODO: Implement logout
  }
}

class QuickAction {
  final IconData icon;
  final String label;
  final String? badge;
  final VoidCallback onTap;

  QuickAction({
    required this.icon,
    required this.label,
    this.badge,
    required this.onTap,
  });
}

class SettingsItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final IconData? trailing;
  final VoidCallback onTap;

  SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    required this.onTap,
  });
}
