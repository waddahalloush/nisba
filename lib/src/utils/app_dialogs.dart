import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/configs/theme_extensions.dart';

enum DialogsType { success, error, hint }

class AppDialogs {
  static void generalDialog({
    String? title,
    Widget? content,
    required String message,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    DialogsType type = DialogsType.hint,
   
  }) {
    // جلب الثيم الحالي للتطبيق باستخدام Get.context
    final theme = Theme.of(Get.context!);

    // تحديد اللون الأساسي للنافذة بناءً على نوعها
    Color getDialogColor() {
      final extras = Get.context!.zatheExtras;
      switch (type) {
        case DialogsType.success:
          return extras.success;
        case DialogsType.error:
          return theme.colorScheme.error;
        case DialogsType.hint:
          return theme.colorScheme.primary;
      }
    }

    final dialogColor = getDialogColor();

    Get.defaultDialog(
      title: title ?? _getDefaultTitle(type),
      titleStyle: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: dialogColor,
        fontSize: 18.sp,
      ),
      middleText: message,
      middleTextStyle: theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: theme.colorScheme.onSurface,
        fontSize: 14.sp,
      ),
      content: content,
      radius: 12.r, // زوايا متجاوبة
      titlePadding: EdgeInsets.only(top: 20.h, bottom: 10.h),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),

      // زر التأكيد
      confirm: InkWell(
        onTap: onConfirm,
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          alignment: Alignment.center,
          width: 60.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: dialogColor,
          ),
          child: Text(
            'yes'.tr,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimary, // لون النص بناءً على الثيم
              fontSize: 14.sp,
            ),
          ),
        ),
      ),

      // زر الإلغاء
      cancel: InkWell(
        onTap: onCancel ?? () => Get.back(),
        borderRadius: BorderRadius.circular(6.r),
        child: Container(
          alignment: Alignment.center,
          width: 60.w,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: Colors.transparent,
            border: Border.all(color: dialogColor, width: 1.5.w),
          ),
          child: Text(
            'no'.tr,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: dialogColor,
              fontSize: 14.sp,
            ),
          ),
        ),
      ),
    );
  }

  static String _getDefaultTitle(DialogsType type) {
    switch (type) {
      case DialogsType.success:
        return 'dialog_success'.tr;
      case DialogsType.error:
        return 'dialog_error'.tr;
      case DialogsType.hint:
        return 'dialog_alert'.tr;
    }
  }
}
