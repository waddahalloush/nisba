import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/models/Auth/user_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class UserAccountController extends GetxController {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final birthDate = ''.obs;
  final selectedGender = 'male'.tr.obs;
  final isLoading = false.obs;
  final isSaving = false.obs;

  final formKey = GlobalKey<FormState>();

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();
  final GetStorageHelper storageHelper = Get.find();

  @override
  void onInit() {
    super.onInit();
    _hydrateFromStorage();
    fetchProfile();
  }

  void _hydrateFromStorage() {
    final user = storageHelper.getUser;
    if (user == null) return;
    firstNameController.text = user.fName ?? '';
    lastNameController.text = user.lName ?? '';
    emailController.text = user.email ?? '';
    birthDate.value = user.birthday ?? '';
    final g = user.gender.value.toLowerCase();
    selectedGender.value = g == 'female' ? 'female'.tr : 'male'.tr;
  }

  Future<void> fetchProfile() async {
    if (!await connectionChecker.hasConnection) return;
    isLoading.value = true;
    try {
      final res = await repository.getProfile();
      final data = ApiResult.ensureSuccess(res);
      final user = data is Map ? data['user'] : null;
      if (user is Map) {
        final map = Map<String, dynamic>.from(user);
        firstNameController.text = map['f_name']?.toString() ?? '';
        lastNameController.text = map['l_name']?.toString() ?? '';
        emailController.text = map['email']?.toString() ?? '';
        birthDate.value = map['birthday']?.toString() ?? '';
        final gender = map['gender'];
        final genderValue = gender is Map
            ? gender['value']?.toString() ?? ''
            : gender?.toString() ?? '';
        selectedGender.value =
            genderValue.toLowerCase() == 'female' ? 'female'.tr : 'male'.tr;
        try {
          storageHelper.saveUser(User.fromJson(map));
        } catch (_) {}
      }
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectGender(String gender) => selectedGender.value = gender;

  Future<void> pickBirthDate() async {
    DateTime initial = DateTime(1990, 1, 1);
    try {
      if (birthDate.value.contains('-')) {
        final parts = birthDate.value.split('-');
        if (parts.length == 3) {
          initial = DateTime(
            int.parse(parts[0].length == 4 ? parts[0] : parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0].length == 4 ? parts[2] : parts[0]),
          );
        }
      }
    } catch (_) {}
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: initial,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      birthDate.value = '$year-$month-$day';
    }
  }

  Future<void> save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isSaving.value = true;
    try {
      final res = await repository.updateProfile(
        data: {
          'f_name': firstNameController.text.trim(),
          'l_name': lastNameController.text.trim(),
          if (emailController.text.trim().isNotEmpty)
            'email': emailController.text.trim(),
          if (birthDate.value.isNotEmpty) 'birthday': birthDate.value,
          'gender': selectedGender.value == 'female'.tr ? 'female' : 'male',
        },
      );
      final data = ApiResult.ensureSuccess(res);
      final user = data is Map ? data['user'] : null;
      if (user is Map) {
        try {
          storageHelper.saveUser(
            User.fromJson(Map<String, dynamic>.from(user)),
          );
        } catch (_) {}
      }
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'auto_key_98'.tr,
      );
      Get.back();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
