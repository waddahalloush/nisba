import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GiftCreditController extends GetxController {
  final selectedTab = 0.obs; // 0 = QR, 1 = phone
  final phoneController = TextEditingController();
  final noteController = TextEditingController();
  final selectedAmount = 0.0.obs;
  final countryCode = '+974'.obs;

  final presetAmounts = <double>[10, 20, 30, 50, 100];
  final maxNoteLength = 120;

  void selectTab(int index) => selectedTab.value = index;

  void selectAmount(double amount) => selectedAmount.value = amount;

  void clearAmount() => selectedAmount.value = 0;

  void proceed() {
    if (selectedTab.value == 1 && phoneController.text.trim().isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال رقم الهاتف');
      return;
    }
    if (selectedAmount.value <= 0) {
      Get.snackbar('خطأ', 'يرجى اختيار المبلغ');
      return;
    }
    // TODO: Navigate to confirmation screen
  }

  @override
  void onClose() {
    phoneController.dispose();
    noteController.dispose();
    super.onClose();
  }
}
