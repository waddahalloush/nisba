import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/locale_extensions.dart';

import 'package:nisba_app/src/services/locale_service.dart';

import 'package:iconsax/iconsax.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'change_account_password_controller.dart';

class ChangeAccountPasswordScreen
    extends GetView<ChangeAccountPasswordController> {
  const ChangeAccountPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Directionality(
      textDirection: Get.find<LocaleService>().textDirection,
      child: Scaffold(
        backgroundColor: cs.surfaceContainerHighest,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(backIconData(context), color: cs.primary),
          ),
          title: Text(
            'auto_key_79'.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Obx(() {
            if (controller.otpStep.value == 0) {
              return _buildSendStep(theme);
            }
            return _buildVerifyStep(theme);
          }),
        ),
      ),
    );
  }

  Widget _buildSendStep(ThemeData theme) {
    final cs = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(Iconsax.sms, color: cs.primary, size: 40.sp),
          SizedBox(height: 12.h),
          Text(
            'auto_key_80'.tr,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: cs.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed:
                  controller.isSendingOtp.value ? null : controller.sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35.r),
                ),
              ),
              child: controller.isSendingOtp.value
                  ? SizedBox(
                      width: 22.w,
                      height: 22.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.onPrimary,
                      ),
                    )
                  : Text(
                      'auto_key_81'.tr,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyStep(ThemeData theme) {
    final cs = theme.colorScheme;

    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 8.h),
          _InputCard(
            label: 'auto_key_82'.tr,
            controller: controller.codeController,
            icon: Iconsax.password_check,
            keyboardType: TextInputType.number,
            maxLength: 6,
            validator: (v) {
              if (v == null || v.trim().length != 6) {
                return 'auto_key_83'.tr;
              }
              return null;
            },
          ),
          SizedBox(height: 12.h),
          _PasswordCard(
            label: 'auto_key_84'.tr,
            controller: controller.newPasswordController,
            obscure: controller.obscureNew,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'auto_key_85'.tr;
              if (v.trim().length < 8) return 'auto_key_86'.tr;
              return null;
            },
          ),
          SizedBox(height: 12.h),
          _PasswordCard(
            label: 'auto_key_87'.tr,
            controller: controller.confirmPasswordController,
            obscure: controller.obscureConfirm,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'auto_key_85'.tr;
              return null;
            },
          ),
          SizedBox(height: 12.h),
          Obx(
            () => TextButton(
              onPressed:
                  controller.isSendingOtp.value ? null : controller.sendOtp,
              child: Text(
                'auto_key_88'.tr,
                style: TextStyle(color: cs.primary, fontSize: 13.sp),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Obx(
            () => SizedBox(
              height: 52.h,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : controller.changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.r),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? SizedBox(
                        width: 22.w,
                        height: 22.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: cs.onPrimary,
                        ),
                      )
                    : Text(
                        'auto_key_89'.tr,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? Function(String?)? validator;

  const _InputCard({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.maxLength,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: cs.primary, size: 18.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              validator: validator,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: cs.onSurface, fontSize: 12.sp),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordCard extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final RxBool obscure;
  final String? Function(String?)? validator;

  const _PasswordCard({
    required this.label,
    required this.controller,
    required this.obscure,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Iconsax.lock_1, color: cs.primary, size: 18.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: TextFormField(
                controller: controller,
                obscureText: obscure.value,
                validator: validator,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(color: cs.onSurface, fontSize: 12.sp),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
            IconButton(
              onPressed: () => obscure.value = !obscure.value,
              icon: Icon(
                obscure.value ? Iconsax.eye_slash : Iconsax.eye,
                color: cs.onSurface.withValues(alpha: 0.45),
                size: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
