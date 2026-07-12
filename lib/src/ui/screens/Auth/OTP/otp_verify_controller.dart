import 'dart:async';
import 'package:get/get.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

class OtpVerifyController extends GetxController {
  final otpCode = ''.obs;
  final isLoading = false.obs;
  final resendSeconds = 45.obs; // تم التعديل إلى 45 ثانية بناءً على الصورة
  final canResend = false.obs;

  late final String phoneNumber;
  Timer? _resendTimer;

  @override
  void onInit() {
    super.onInit();
    phoneNumber = Get.arguments as String? ?? '+974 5000 0000'; // القيمة الافتراضية للمعاينة المتطابقة
    _startResendTimer();
  }

  /// تحويل الثواني إلى صيغة MM:SS (مثال: 00:45)
  String get formattedTime {
    final minutes = (resendSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (resendSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Verifies the entered OTP code
  Future<void> verifyOtp() async {
    if (otpCode.value.length < 6) return;

    isLoading.value = true;
    try {
      // TODO: Call OTP verification API & navigate to home
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed(AppRoutesNames.register);
    } finally {
      isLoading.value = false;
    }
  }

  /// Resends OTP code and restarts the countdown timer
  Future<void> resendOtp() async {
    if (!canResend.value) return;

    canResend.value = false;
    _resendTimer?.cancel();

    try {
      // TODO: Call resend OTP API
      await Future.delayed(const Duration(milliseconds: 500));
      Get.showSnackbar(
        GetSnackBar(
          message: 'snackbar_otp_resent'.trParams({'phone': phoneNumber}),
          duration: const Duration(seconds: 2),
        ),
      );
      _startResendTimer();
    } catch (_) {
      canResend.value = true;
    }
  }

  /// Starts a countdown from [resendSeconds] to 0, then enables resend
  void _startResendTimer() {
    resendSeconds.value = 45;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendSeconds.value > 0) {
        resendSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    super.onClose();
  }
}