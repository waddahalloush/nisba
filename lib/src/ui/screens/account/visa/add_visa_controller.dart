import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddVisaController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();

  final isCardNumberMasked = true.obs;
  final isCvvMasked = true.obs;

  void toggleCardMask() => isCardNumberMasked.value = !isCardNumberMasked.value;
  void toggleCvvMask() => isCvvMasked.value = !isCvvMasked.value;

  String maskCardNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\s'), '');
    if (digits.length < 4) return input;
    final last4 = digits.substring(digits.length - 4);
    return '•••• •••• •••• $last4';
  }

  void addCard() {
    if (formKey.currentState?.validate() ?? false) {
      Get.back();
      Get.snackbar('تم', 'تمت إضافة البطاقة بنجاح');
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
