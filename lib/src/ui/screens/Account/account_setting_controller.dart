import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/configs/locale_constants.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/services/locale_service.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class AccountSettingController extends GetxController {
  final GetStorageHelper storageHelper = Get.find();
  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();
  final LocaleService localeService = Get.find();

  final userName = ''.obs;
  final userPhone = ''.obs;
  final memberSince = ''.obs;
  final isLoggingOut = false.obs;
  final isDeleting = false.obs;

  late final List<QuickAction> quickActions;

  List<SettingsItem> get settingsItems => [
        SettingsItem(
          icon: Iconsax.user,
          title: 'معلومات الحساب',
          subtitle: 'الاسم، البريد الإلكتروني، رقم الهاتف',
          onTap: () => Get.toNamed(AppRoutesNames.userAccount),
        ),
        SettingsItem(
          icon: Iconsax.card,
          title: 'إعدادات الدفع',
          subtitle: 'إدارة بطاقات الدفع والمحفظة',
          onTap: () => Get.toNamed(AppRoutesNames.paymentSetting),
        ),
        SettingsItem(
          icon: Iconsax.notification,
          title: 'الإشعارات',
          subtitle: 'تفعيل أو إيقاف الإشعارات',
          onTap: () => Get.toNamed(AppRoutesNames.notification),
        ),
        SettingsItem(
          icon: Iconsax.language_square,
          title: 'اللغة',
          subtitle: localeService.currentLanguageLabel,
          trailing: Iconsax.arrow_swap_horizontal,
          onTap: showLanguageDialog,
        ),
        SettingsItem(
          icon: Iconsax.global,
          title: 'الدولة',
          subtitle: 'دولة قطر',
          trailing: Iconsax.arrow_swap_horizontal,
          onTap: () {},
        ),
        SettingsItem(
          icon: Iconsax.trash,
          title: 'حذف الحساب',
          subtitle: 'حذف الحساب نهائياً',
          onTap: confirmDeleteAccount,
        ),
      ];

  @override
  void onInit() {
    super.onInit();
    quickActions = [
      QuickAction(
        icon: Iconsax.bag_2,
        label: 'الطلبات',
        onTap: () => Get.toNamed(AppRoutesNames.dashboard),
      ),
      QuickAction(
        icon: Iconsax.heart,
        label: 'المفضلة',
        onTap: () => Get.toNamed(AppRoutesNames.favorite),
      ),
      QuickAction(
        icon: Iconsax.location,
        label: 'العناوين',
        onTap: () => Get.toNamed(AppRoutesNames.addresses),
      ),
    ];
    _hydrateFromStorage();
    fetchProfile();
  }

  void _hydrateFromStorage() {
    final user = storageHelper.getUser;
    if (user == null) return;
    userName.value = user.name ??
        [user.fName, user.lName].where((e) => e != null && e.isNotEmpty).join(' ');
    userPhone.value = '${user.key} ${user.phone}';
  }

  Future<void> fetchProfile() async {
    if (!await connectionChecker.hasConnection) return;
    try {
      final res = await repository.getProfile();
      final data = ApiResult.ensureSuccess(res);
      final user = data is Map ? data['user'] : null;
      if (user is Map) {
        final map = Map<String, dynamic>.from(user);
        final name = map['name']?.toString();
        final fName = map['f_name']?.toString() ?? '';
        final lName = map['l_name']?.toString() ?? '';
        userName.value = (name != null && name.isNotEmpty)
            ? name
            : '$fName $lName'.trim();
        final key = map['key']?.toString() ?? '';
        final phone = map['phone']?.toString() ?? '';
        userPhone.value = '$key $phone'.trim();
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('lang_arabic'.tr),
              trailing: localeService.locale.value.languageCode ==
                      LocaleConstants.arabic
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Get.back();
                localeService.setLocaleCode(LocaleConstants.arabic);
                update();
              },
            ),
            ListTile(
              title: Text('lang_english'.tr),
              trailing: localeService.locale.value.languageCode ==
                      LocaleConstants.english
                  ? const Icon(Icons.check)
                  : null,
              onTap: () {
                Get.back();
                localeService.setLocaleCode(LocaleConstants.english);
                update();
              },
            ),
          ],
        ),
      ),
    );
  }

  void confirmDeleteAccount() {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف الحساب'),
        content: const Text(
          'هل أنت متأكد من حذف حسابك نهائياً؟ لا يمكن التراجع عن هذا الإجراء.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('تراجع')),
          TextButton(
            onPressed: () {
              Get.back();
              deleteAccount();
            },
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> deleteAccount() async {
    if (isDeleting.value) return;
    isDeleting.value = true;
    try {
      if (await connectionChecker.hasConnection) {
        try {
          final res = await repository.deleteAccount();
          ApiResult.ensureSuccess(res);
        } catch (_) {
          // Still clear local session.
        }
      }
      await storageHelper.clearStorage();
      Get.offNamedUntil(AppRoutesNames.login, (route) => false);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> logout() async {
    if (isLoggingOut.value) return;
    isLoggingOut.value = true;
    try {
      if (await connectionChecker.hasConnection) {
        try {
          await repository.logout();
        } catch (_) {
          // Still clear local session.
        }
      }
      await storageHelper.clearStorage();
      Get.offNamedUntil(AppRoutesNames.splashScreen, (route) => false);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isLoggingOut.value = false;
    }
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
