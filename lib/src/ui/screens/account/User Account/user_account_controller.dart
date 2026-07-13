import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserAccountController extends GetxController {
  final firstNameController = TextEditingController(text: 'محمد');
  final lastNameController = TextEditingController(text: 'عبيد');
  final emailController = TextEditingController(text: 'muhameeda@gmail.com');
  final birthDate = '08-06-1982'.obs;
  final selectedGender = 'ذكر'.obs;

  final formKey = GlobalKey<FormState>();

  void selectGender(String gender) => selectedGender.value = gender;

  void pickBirthDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime(1982, 6, 8),
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      final year = picked.year.toString();
      birthDate.value = '$day-$month-$year';
    }
  }

  void save() {
    if (formKey.currentState?.validate() ?? false) {
      // TODO: Save to API
      Get.back();
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
