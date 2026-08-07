import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/configs/theme_extensions.dart';

class AppSnackbar {
  static void showSuccess({required String message}) {
    final ctx = Get.context!;
    final success = ctx.zatheExtras.success;
    _showSnackbar(
      title: 'snackbar_success'.tr,
      message: message,
      backgroundColor: success.withOpacity(0.1),
      textColor: success,
      icon: Icons.check_circle_outline,
    );
  }

  static void showError({required String message, String? title}) {
    final theme = Theme.of(Get.context!);
    _showSnackbar(
      title: title ?? 'snackbar_error'.tr,
      message: message,
      backgroundColor: theme.colorScheme.error.withOpacity(0.1),
      textColor: theme.colorScheme.error,
      icon: Icons.cancel_outlined,
    );
  }

  static void showInfo({required String message, String? title}) {
    _showSnackbar(
      title: title ?? 'snackbar_info'.tr,
      message: message,
      backgroundColor: Colors.orangeAccent.withOpacity(0.1),
      textColor: Colors.orange,
      icon: Icons.info_outline,
    );
  }

  static void _showSnackbar({
    required String message,
    required String title,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    final theme = Theme.of(Get.context!);

    Get.snackbar(
      '',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: backgroundColor,
      colorText: textColor,
      icon: Icon(icon, color: textColor, size: 26.r),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      borderRadius: 40.r,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      shouldIconPulse: false,
      forwardAnimationCurve: Curves.easeOutBack,
      titleText: const SizedBox.shrink(),
      messageText: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: textColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
