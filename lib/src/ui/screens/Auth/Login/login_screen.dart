import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/services/locale_service.dart';

import 'package:nisba_app/src/configs/dimensions.dart';

import '../../../../configs/api_response.dart';
import '../widgets/app_primary_button.dart';
import 'login_controller.dart';
import 'widgets/login_header.dart';
import 'widgets/login_or_divider.dart';
import 'widgets/login_phone_field.dart';
import 'widgets/login_social_section.dart';
import 'widgets/login_top_bar.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Directionality(
          textDirection: Get.find<LocaleService>().textDirection,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LoginTopBar(controller: controller),
                SizedBox(height: 20.h),
                const LoginHeader(),
                SizedBox(height: 36.h),
                LoginPhoneField(controller: controller),
                SizedBox(height: 28.h),
                Obx(
                  () => AppPrimaryButton(
                    label: 'next'.tr,
                    onPressed: controller.sendCodeFunc,
                    isLoading:
                        controller.sendOtpResponse.value.status ==
                        Status.loading,
                  ),
                ),
                SizedBox(height: 32.h),
                const LoginOrDivider(),
                SizedBox(height: 24.h),
                LoginSocialSection(controller: controller),
                SizedBox(height: 40.h),
                // LoginBottomRegister(controller: controller),
                // SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
