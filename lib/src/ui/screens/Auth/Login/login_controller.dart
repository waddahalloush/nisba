import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/services/theme_service.dart';
import 'package:nisba_app/src/ui/widgets/color_palette_sheet.dart';

class LoginController extends GetxController {
  final phoneController = TextEditingController();
  final phoneNumber = ''.obs;
  final isLoading = false.obs;

  ThemeService get _themeService => Get.find<ThemeService>();

  /// Validates phone and sends OTP
  Future<void> sendOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;

    // Format: remove leading zero, prepend country code +963
    final formattedPhone = phone.startsWith('0')
        ? '+963${phone.substring(1)}'
        : '+963$phone';

    isLoading.value = true;
    phoneNumber.value = formattedPhone;

    try {
      // TODO: Call OTP API
      await Future.delayed(const Duration(seconds: 1));
      Get.toNamed(AppRoutesNames.otpVerification, arguments: formattedPhone);
    } finally {
      isLoading.value = false;
    }
  }

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
}
