import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/assets.gen.dart';

class PaymentMethod {
  final String icon;
  final String label;
  final String? subtitle;

  const PaymentMethod({required this.icon, required this.label, this.subtitle});
}

class PaymentController extends GetxController {
  final selectedPayment = 'بطاقة بنكية'.obs;
  final usePoints = false.obs;
  final pointsToUse = 0.0.obs;

  final restaurantName = 'مشاوي الخليج'.obs;
  final deliveryTime = '30-40 دقيقة'.obs;
  final deliveryAddress = 'الدوحة، شارع الريان، مبنى 12'.obs;
  final deliveryManager = 'شركة فلاش غو'.obs;
  final subtotal = 57.00.obs;
  final deliveryFee = 5.00.obs;
  final discount = 8.55.obs;
  final tax = 2.67.obs;
  final availablePoints = 120.obs;

  // ── Address editor ──
  final addressController = TextEditingController();

  double get pointsDiscount => pointsToUse.value / 10;

  double get total =>
      subtotal.value +
      deliveryFee.value -
      discount.value +
      tax.value -
      pointsDiscount;

  final paymentMethods =  <PaymentMethod>[
    PaymentMethod(
      icon: Assets.images.payVisa.path,
      label: 'بطاقة بنكية',
      subtitle: 'Visa, Mastercard',
    ),
    PaymentMethod(
      icon: Assets.images.payGoogle.path,
      label: 'المحفظة الإلكترونية',
      subtitle: 'Apple Pay, Google Pay',
    ),
    PaymentMethod(icon: Assets.images.paypal.path, label: 'الدفع عبر الإنترنت' , subtitle: 'PayPal , Mada',),
    PaymentMethod(icon: Assets.images.payOnDeliver.path, label: 'الدفع عند الاستلام'),
  ];

  void selectPayment(String method) => selectedPayment.value = method;

  void updateAddress() {
    final text = addressController.text.trim();
    if (text.isNotEmpty) {
      deliveryAddress.value = text;
      addressController.clear();
      Get.back();
      Get.snackbar('تم', 'تم تحديث عنوان التوصيل بنجاح');
    }
  }

  void payNow() {
    Get.snackbar('تم', 'جاري معالجة الدفع...');
  }

  @override
  void onInit() {
    super.onInit();
    pointsToUse.value = availablePoints.value.toDouble();
    addressController.text = deliveryAddress.value;
  }

  @override
  void onClose() {
    addressController.dispose();
    super.onClose();
  }
}
