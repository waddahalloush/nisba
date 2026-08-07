import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../configs/app_colors.dart';
import '../data/local/get_storage_helper.dart';

/// Persists and applies light/dark [ThemeMode] via GetX + [GetStorageHelper].
class ThemeService extends GetxService {
  static const Color fallbackPrimaryColor = AppColors.primaryColor;

  final RxBool isDarkMode = false.obs;
  final Rx<Color> primaryColor = fallbackPrimaryColor.obs;

  GetStorageHelper get _storage => Get.find<GetStorageHelper>();

  @override
  void onInit() {
    super.onInit();
    // Restore persisted preference on cold start (matches GetMaterialApp themeMode).
    isDarkMode.value = _storage.isDarkMode;
    primaryColor.value =
        colorFromHex(_storage.appColor) ?? fallbackPrimaryColor;
  }

  /// Updates storage, reactive flag, and GetX theme mode.
  void setDarkMode(bool enabled) {
    _storage.changeBrightnessToDark(enabled);
    isDarkMode.value = enabled;
  }

  void setAppColor(String hexColor) {
    final parsedColor = colorFromHex(hexColor);
    if (parsedColor == null) return;

    _storage.saveAppColor(hexColor);
    primaryColor.value = parsedColor;
  }

  static Color? colorFromHex(String? hexColor) {
    if (hexColor == null) return null;

    final normalized = hexColor.trim().replaceFirst('#', '');
    if (!RegExp(r'^[0-9A-Fa-f]{6}$').hasMatch(normalized)) return null;

    return Color(int.parse('FF$normalized', radix: 16));
  }
}
