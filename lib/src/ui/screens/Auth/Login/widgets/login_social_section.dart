import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import '../login_controller.dart';
import 'login_social_button.dart';

/// Email / Google / Facebook social login buttons.
class LoginSocialSection extends StatelessWidget {
  final LoginController controller;

  const LoginSocialSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        LoginSocialButton(
          text: 'continue_with_email'.tr,
          icon: Icon(Icons.mail_outline_rounded, color: primaryColor, size: 26),
          onTap: controller.loginWithEmail,
        ),
        SizedBox(height: 16.h),
        LoginSocialButton(
          text: 'continue_with_google'.tr,
          icon: Assets.images.googleLogo.image(height: 24.h, width: 24.w),
          onTap: controller.loginWithGoogle,
        ),
        SizedBox(height: 16.h),
        LoginSocialButton(
          text: 'continue_with_facebook'.tr,
          icon: const Icon(
            Icons.facebook,
            color: AppColors.facebookColor,
            size: 26,
          ),
          onTap: controller.loginWithFacebook,
        ),
      ],
    );
  }
}
