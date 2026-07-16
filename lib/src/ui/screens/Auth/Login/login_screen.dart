import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../widgets/app_primary_button.dart';
import 'login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Top skip & color picker row ──
                Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: controller.skipLogin,
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        child: Text(
                          'skip'.tr,
                          style: textTheme.bodyLarge?.copyWith(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: controller.showColorPallet,
                      //   child: Container(
                      //     width: 30.w,
                      //     height: 30.h,
                      //     decoration: BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: primaryColor,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // ── Logo ──
                Center(
                  child: Assets.images.logo.image(
                    width: 110.w,
                    height: 110.h,
                    color: primaryColor,
                  ),
                ),

                // ── Login title ──
                Text(
                  'login'.tr,
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  'enter_phone_instruction'.tr,
                  style: textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.87),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 36.h),

                // ── Phone field ──
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: IntlPhoneField(
                    controller: controller.phoneController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: 'phone_number_hint'.tr,
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.45,
                        ),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(color: primaryColor, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(color: primaryColor, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                      ),
                    ),
                    initialCountryCode: 'QA',
                    disableLengthCheck: true,
                    dropdownIconPosition: IconPosition.trailing,
                    dropdownIcon: Icon(
                      Icons.keyboard_arrow_down,
                      color: theme.colorScheme.onSurface,
                    ),
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    onChanged: (phone) {
                      controller.phoneNumber.value = phone.completeNumber;
                    },
                  ),
                ),
                SizedBox(height: 28.h),

                // ── Next button ──
                Obx(
                  () => AppPrimaryButton(
                    label: 'next'.tr,
                    onPressed: controller.sendOtp,
                    isLoading: controller.isLoading.value,
                  ),
                ),
                SizedBox(height: 32.h),

                // ── "Or" divider ──
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.outline,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'or'.tr,
                        style: textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: theme.colorScheme.outline,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                // ── Social login buttons ──
                _SocialLargeButton(
                  text: 'continue_with_email'.tr,
                  icon: Icon(
                    Icons.mail_outline_rounded,
                    color: primaryColor,
                    size: 26,
                  ),
                  onTap: controller.loginWithEmail,
                ),
                SizedBox(height: 16.h),
                _SocialLargeButton(
                  text: 'continue_with_google'.tr,
                  icon: Assets.images.googleLogo.image(
                    height: 24.h,
                    width: 24.w,
                  ),
                  onTap: controller.loginWithGoogle,
                ),
                SizedBox(height: 16.h),
                _SocialLargeButton(
                  text: 'continue_with_facebook'.tr,
                  icon: const Icon(
                    Icons.facebook,
                    color: AppColors.facebookColor,
                    size: 26,
                  ),
                  onTap: controller.loginWithFacebook,
                ),
                SizedBox(height: 40.h),

                // ── Bottom: don't have account? create one ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'dont_have_account'.tr,
                      style: textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.navigateToRegister,
                      child: Text(
                        'create_account'.tr,
                        style: textTheme.bodyMedium?.copyWith(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Large rectangular social login button.
class _SocialLargeButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialLargeButton({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.03),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Row(
            children: [
              icon,
              Expanded(
                child: Text(
                  text,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
