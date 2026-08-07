import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import '../../../../configs/api_response.dart';
import '../../../../data/local/get_storage_helper.dart';
import '../../../../data/models/Auth/profile_model.dart';
import '../../../../data/repository.dart';
import '../../../../utils/app_snackbar.dart';
import '../../../../utils/dio_error_util.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  final selectedGender = ''.obs;
  final selectedDate = Rx<DateTime?>(null);

  String get formattedDate {
    final date = selectedDate.value;
    if (date == null) return '';
    return '${date.day} / ${date.month} / ${date.year}';
  }

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      selectedDate.value = date;
    }
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.onClose();
  }

  // Connect with api
  Repository repository = Get.find();
  // // PushNotificationService pushNotificationService = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  GetStorageHelper storageHelper = Get.find();
  Rx<ApiResponse<ProfileUpdateResponse>> registerResponse =
      ApiResponse<ProfileUpdateResponse>.init().obs;

  Future<void> completeAccountFunc() async {
    if (!formKey.currentState!.validate()) return;
    if (selectedGender.value.isEmpty) {
      AppSnackbar.showError(message: 'please_select_gender'.tr);

      return;
    }
    if (selectedDate.value == null) {
      AppSnackbar.showError(message: 'please_enter_birthday'.tr);
      return;
    }

    registerResponse.value = ApiResponse<ProfileUpdateResponse>.loading('');
    if (await connectionChecker.hasConnection) {
      try {
        var res = await repository.completeAccount(
          data: {
            "f_name": firstNameController.text.trim(),
            "l_name": lastNameController.text.trim(),
            "email": emailController.text.trim(),
            "birthday":
                '${selectedDate.value!.year}-'
                '${selectedDate.value!.month.toString().padLeft(2, '0')}-'
                '${selectedDate.value!.day.toString().padLeft(2, '0')}',
            "gender": selectedGender.value,
          },
        );

        if (res != null) {
          registerResponse.value = ApiResponse<ProfileUpdateResponse>.completed(
            res,
          );
          storageHelper.saveUser(registerResponse.value.data.user);
          Get.offAllNamed(AppRoutesNames.dashboard);
        }
      } on DioException catch (error) {
        log(error.response!.data['message'].toString());
        registerResponse.value = ApiResponse<ProfileUpdateResponse>.error(
          DioErrorUtil.handleError(error),
        );
        AppSnackbar.showError(message: registerResponse.value.message);
      }
    } else {
      registerResponse.value = ApiResponse<ProfileUpdateResponse>.error(
        "check_connection".tr,
      );
      AppSnackbar.showError(message: registerResponse.value.message);
    }
  }
}
