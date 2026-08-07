import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import '../../../../configs/api_response.dart';
import '../../../../data/local/get_storage_helper.dart';
import '../../../../data/models/Auth/user_model.dart';
import '../../../../data/repository.dart';
import '../../../../utils/app_snackbar.dart';
import '../../../../utils/dio_error_util.dart';
import '../../../../utils/notification/fcm_helper.dart';

class OtpVerifyController extends GetxController {
  final otpCode = ''.obs;
  final resendSeconds = 45.obs;
  final canResend = false.obs;
  final isResending = false.obs;

  late final String username;
  late final String key;
  late final String fullPhoneNumber;
  Timer? _resendTimer;

  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  GetStorageHelper storageHelper = Get.find();
  Rx<ApiResponse<AuthResponse>> verifyOtpResponse =
      ApiResponse<AuthResponse>.init().obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, String>? ?? {};
    username = args['username'] ?? '';
    key = args['key'] ?? '';
    fullPhoneNumber = args['full_phone_number'] ?? '+974 5000 0000';
    _startResendTimer();
  }

  String get formattedTime {
    final minutes = (resendSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (resendSeconds.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<void> resendOtp() async {
    if (!canResend.value || isResending.value) return;

    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    canResend.value = false;
    isResending.value = true;
    _resendTimer?.cancel();

    try {
      final res = await repository.sendVerificationCode(
        data: {
          'username_type': 'phone',
          'username': username,
          'key': key,
        },
      );
      if (res?.toString() == 'success' || res != null) {
        AppSnackbar.showSuccess(
          message: 'snackbar_otp_resent'
              .trParams({'phone': fullPhoneNumber}),
        );
      }
      _startResendTimer();
    } on DioException catch (error) {
      canResend.value = true;
      AppSnackbar.showError(message: DioErrorUtil.handleError(error));
    } catch (e) {
      canResend.value = true;
      AppSnackbar.showError(message: e.toString());
    } finally {
      isResending.value = false;
    }
  }

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

  Future<void> verifyOtpCodeFunc() async {
    if (otpCode.value.length < 6) return;
    verifyOtpResponse.value = ApiResponse<AuthResponse>.loading('');
    if (await connectionChecker.hasConnection) {
      try {
        final resolvedCountryId = storageHelper.countryId.isNotEmpty
            ? storageHelper.countryId
            : '1';
        var res = await repository.checkVerificationCode(
          data: {
            'username_type': 'phone',
            'username': username,
            'key': key,
            'code': otpCode.value,
            'fcm': FcmHelper.firebaseToken,
            'country_id': resolvedCountryId,
          },
        );

        if (res != null) {
          verifyOtpResponse.value = ApiResponse<AuthResponse>.completed(res);
          if (verifyOtpResponse.value.data.user.name == null) {
            storageHelper.saveAuthToken(verifyOtpResponse.value.data.token);
            Get.toNamed(AppRoutesNames.register);
          } else {
            storageHelper.saveAuthToken(verifyOtpResponse.value.data.token);
            storageHelper.saveUser(verifyOtpResponse.value.data.user);
            Get.offAllNamed(AppRoutesNames.dashboard);
          }
        }
      } on DioException catch (error) {
        log(error.response!.data['message'].toString());
        verifyOtpResponse.value = ApiResponse<AuthResponse>.error(
          DioErrorUtil.handleError(error),
        );
        AppSnackbar.showError(message: verifyOtpResponse.value.message);
      }
    } else {
      verifyOtpResponse.value = ApiResponse<AuthResponse>.error(
        'check_connection'.tr,
      );
      AppSnackbar.showError(message: verifyOtpResponse.value.message);
    }
  }
}
