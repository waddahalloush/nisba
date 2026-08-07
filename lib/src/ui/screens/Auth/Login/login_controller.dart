import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/services/theme_service.dart';
import 'package:nisba_app/src/ui/widgets/color_palette_sheet.dart';

import '../../../../configs/api_response.dart';
import '../../../../data/repository.dart';
import '../../../../utils/app_snackbar.dart';
import '../../../../utils/dio_error_util.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final phoneNumber = ''.obs;
  final countryCode = '974'.obs;

  ThemeService get _themeService => Get.find<ThemeService>();

  void skipLogin() {
    Get.toNamed(AppRoutesNames.dashboard);
  }

  void loginWithEmail() {
    // TODO: Implement email login
  }

  /// Opens the color palette picker. When the user selects a color,
  /// the app's primary color is updated reactively across all screens.
  Future<void> showColorPallet() async {
    final selectedHex = await ColorPaletteSheet.show(Get.context!);
    if (selectedHex != null) {
      _themeService.setAppColor(selectedHex);
    }
  }

  void loginWithGoogle() {
    // TODO: Implement google login
  }

  void loginWithFacebook() {
    // TODO: Implement facebook login
  }

  void navigateToRegister() {
    // TODO: Implement navigate to signup screen
    // Get.toNamed(AppRoutesNames.register);
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  // Connect with api
  Repository repository = Get.find();
  // // PushNotificationService pushNotificationService = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  Rx<ApiResponse<String>> sendOtpResponse = ApiResponse<String>.init().obs;

  Future<void> sendCodeFunc() async {
    sendOtpResponse.value = ApiResponse<String>.loading('');
    if (await connectionChecker.hasConnection) {
      try {
        var res = await repository.sendVerificationCode(
          data: {
            "username_type": "phone",
            "username": phoneNumber.value.replaceFirst(RegExp(r'^0+'), ''),
            "key": countryCode.value,
          },
        );

        if (res != null) {
          sendOtpResponse.value = ApiResponse<String>.completed(res);
          if (sendOtpResponse.value.data == "success") {
            Get.toNamed(
              AppRoutesNames.otpVerification,
              arguments: {
                "username": phoneNumber.value.replaceFirst(RegExp(r'^0+'), ''),
                "key": countryCode.value,
                "full_phone_number":
                    '+$countryCode${phoneNumber.value.replaceFirst(RegExp(r'^0+'), '')}',
              },
            );
          }
        }
      } on DioException catch (error) {
        log(error.response!.data['message'].toString());
        sendOtpResponse.value = ApiResponse<String>.error(
          DioErrorUtil.handleError(error),
        );
        AppSnackbar.showError(message: sendOtpResponse.value.message);
      }
    } else {
      sendOtpResponse.value = ApiResponse<String>.error("check_connection".tr);
      AppSnackbar.showError(message: sendOtpResponse.value.message);
    }
  }
}
