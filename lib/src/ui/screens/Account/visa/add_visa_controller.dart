import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class AddVisaController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  final isCardNumberMasked = true.obs;
  final isCvvMasked = true.obs;
  final isSubmitting = false.obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  void toggleCardMask() => isCardNumberMasked.value = !isCardNumberMasked.value;
  void toggleCvvMask() => isCvvMasked.value = !isCvvMasked.value;

  String maskCardNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\s'), '');
    if (digits.length < 4) return input;
    final last4 = digits.substring(digits.length - 4);
    return '•••• •••• •••• $last4';
  }

  Future<void> addCard() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    isSubmitting.value = true;
    try {
      final res = await repository.storeVisa(
        data: {
          'name': nameController.text.trim(),
          'number': cardNumberController.text.replaceAll(RegExp(r'\s'), ''),
          'date': expiryController.text.trim(),
          'code': cvvController.text.trim(),
        },
      );
      ApiResult.ensureSuccess(res);
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'تمت إضافة البطاقة بنجاح',
      );
      Get.back(result: true);
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    super.onClose();
  }
}
