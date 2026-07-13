import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PaymentMethod {
  final IconData icon;
  final String label;
  final String? subtitle;

  const PaymentMethod({required this.icon, required this.label, this.subtitle});
}

class PaymentController extends GetxController {
  final selectedPayment = 'بطاقة بنكية'.obs;
  final usePoints = false.obs;
  final pointsToUse = 0.0.obs;

  final restaurantName = 'مطعم البيت'.obs;
  final deliveryTime = '30-40 دقيقة'.obs;
  final deliveryAddress = 'الدوحة، شارع الريان، مبنى 12'.obs;
  final subtotal = 57.00.obs;
  final deliveryFee = 5.00.obs;
  final discount = 8.55.obs;
  final tax = 2.67.obs;
  final total = 56.12.obs;
  final availablePoints = 120.obs;

  final paymentMethods = const <PaymentMethod>[
    PaymentMethod(
      icon: Iconsax.card,
      label: 'بطاقة بنكية',
      subtitle: 'Visa, Mastercard',
    ),
    PaymentMethod(
      icon: Iconsax.wallet_2,
      label: 'المحفظة الإلكترونية',
      subtitle: 'Apple Pay, Google Pay',
    ),
    PaymentMethod(icon: Iconsax.global, label: 'الدفع عبر الإنترنت'),
    PaymentMethod(icon: Iconsax.moneys, label: 'الدفع عند الاستلام'),
  ];

  void selectPayment(String method) => selectedPayment.value = method;

  void payNow() {
    Get.snackbar('تم', 'جاري معالجة الدفع...');
  }

  @override
  void onInit() {
    super.onInit();
    pointsToUse.value = availablePoints.value.toDouble();
  }
}
