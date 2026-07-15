import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RechargeWalletController extends GetxController {
  final amountController = TextEditingController();
  final selectedAmount = 0.0.obs;

  final presetAmounts = <double>[500, 200, 100, 5000, 1000, 2000];
  final minAmount = 100.0;

  void selectAmount(double amount) {
    selectedAmount.value = amount;
    amountController.text = amount.toStringAsFixed(0);
  }

  void onAmountChanged(String value) {
    final parsed = double.tryParse(value);
    selectedAmount.value = parsed ?? 0;
  }

  void proceed() {
    final amount = double.tryParse(amountController.text.trim());
    if (amount == null || amount < minAmount) {
      Get.snackbar('خطأ', 'الحد الأدنى للشحن هو ${minAmount.toInt()} ر.ق');
      return;
    }
    // TODO: Navigate to payment method selection
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
