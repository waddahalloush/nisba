import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();

  final selectedGender = ''.obs;
  final selectedDate = Rx<DateTime?>(null);
  final isLoading = false.obs;

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

  void onNext() {
    if (!formKey.currentState!.validate()) return;
    if (selectedGender.value.isEmpty) {
      Get.showSnackbar(
        GetSnackBar(
          message: 'please_select_gender'.tr,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    isLoading.value = true;
    try {
      final data = {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'dateOfBirth': formattedDate,
        'gender': selectedGender.value,
      };
      debugPrint('Register data: $data');
      Get.toNamed(AppRoutesNames.dashboard, arguments: data);
    } catch (_) {
      // Handle error
    } finally {
      isLoading.value = false;
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
