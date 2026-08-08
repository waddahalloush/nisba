import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class ChangePaymentPasswordController extends GetxController {
  /// 0 = with old password, 1 = forgot via OTP
  final selectedTab = 0.obs;

  /// OTP flow: 0 = send code, 1 = enter code + new password
  final otpStep = 0.obs;

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpCodeController = TextEditingController();
  final otpNewPasswordController = TextEditingController();
  final otpConfirmPasswordController = TextEditingController();

  final obscureOld = true.obs;
  final obscureNew = true.obs;
  final obscureConfirm = true.obs;
  final obscureOtpNew = true.obs;
  final obscureOtpConfirm = true.obs;

  final isSubmitting = false.obs;
  final isSendingOtp = false.obs;

  final formKeyOld = GlobalKey<FormState>();
  final formKeyOtp = GlobalKey<FormState>();

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();
  final GetStorageHelper storageHelper = Get.find();

  void selectTab(int index) {
    selectedTab.value = index;
    if (index == 1) otpStep.value = 0;
  }

  Map<String, dynamic>? _otpIdentity() {
    final user = storageHelper.getUser;
    if (user == null) {
      AppSnackbar.showError(message: 'auto_key_75'.tr);
      return null;
    }
    return {
      'username': user.phone,
      'username_type': 'phone',
      'key': user.key,
    };
  }

  Future<void> changeWithOldPassword() async {
    if (!(formKeyOld.currentState?.validate() ?? false)) return;
    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      AppSnackbar.showError(message: 'auto_key_77'.tr);
      return;
    }
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isSubmitting.value = true;
    try {
      final res = await repository.changePaymentPassword(
        data: {
          'old_password': oldPasswordController.text.trim(),
          'new_password': newPasswordController.text.trim(),
        },
      );
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'auto_key_94'.tr,
      );
      Get.back();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> sendOtp() async {
    final identity = _otpIdentity();
    if (identity == null) return;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isSendingOtp.value = true;
    try {
      final res = await repository.sendCodeForChangePayment(data: identity);
      ApiResult.ensureSuccess(res);
      otpStep.value = 1;
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'auto_key_76'.tr,
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSendingOtp.value = false;
    }
  }

  Future<void> changeByOtp() async {
    if (!(formKeyOtp.currentState?.validate() ?? false)) return;
    if (otpNewPasswordController.text.trim() !=
        otpConfirmPasswordController.text.trim()) {
      AppSnackbar.showError(message: 'auto_key_77'.tr);
      return;
    }
    final identity = _otpIdentity();
    if (identity == null) return;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isSubmitting.value = true;
    try {
      final res = await repository.changePaymentPasswordByOtp(
        data: {
          ...identity,
          'code': otpCodeController.text.trim(),
          'new_password': otpNewPasswordController.text.trim(),
        },
      );
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'auto_key_94'.tr,
      );
      Get.back();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    otpCodeController.dispose();
    otpNewPasswordController.dispose();
    otpConfirmPasswordController.dispose();
    super.onClose();
  }
}
