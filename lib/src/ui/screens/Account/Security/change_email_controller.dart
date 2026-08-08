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

class ChangeEmailController extends GetxController {
  /// 0 = send OTP, 1 = enter code + new email
  final otpStep = 0.obs;

  final codeController = TextEditingController();
  final emailController = TextEditingController();

  final isSubmitting = false.obs;
  final isSendingOtp = false.obs;

  final formKey = GlobalKey<FormState>();

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();
  final GetStorageHelper storageHelper = Get.find();

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

  Future<void> sendOtp() async {
    final identity = _otpIdentity();
    if (identity == null) return;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isSendingOtp.value = true;
    try {
      final res = await repository.sendCodeForEmailChange(data: identity);
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

  Future<void> changeEmail() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final identity = _otpIdentity();
    if (identity == null) return;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isSubmitting.value = true;
    try {
      final res = await repository.changeEmailByOtp(
        data: {
          ...identity,
          'code': codeController.text.trim(),
          'new_email': emailController.text.trim(),
        },
      );
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'auto_key_90'.tr,
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
    codeController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
