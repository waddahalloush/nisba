import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MealContent {
  final String name;
  final IconData icon;

  const MealContent({required this.name, required this.icon});
}

class NutritionInfo {
  final String value;
  final String label;

  const NutritionInfo({required this.value, required this.label});
}

class ProductDetailsController extends GetxController {
  final quantity = 1.obs;
  final isFavorite = false.obs;
  final price = 25.00.obs;

  final contents = const [
    MealContent(name: 'مشروب غازي متوسط', icon: Iconsax.cup),
    MealContent(name: 'بطاطا متوسطة', icon: Iconsax.cake),
    MealContent(name: 'ستربس دجاج حار 3 قطع', icon: Iconsax.hospital),
  ];

  final nutrition = const [
    NutritionInfo(value: '950', label: 'سعر حراري'),
    NutritionInfo(value: '110 غ', label: 'كربوهيدرات'),
    NutritionInfo(value: '45 غ', label: 'بروتين'),
    NutritionInfo(value: '35 غ', label: 'دهون'),
  ];

  void increment() => quantity.value++;
  void decrement() {
    if (quantity.value > 1) quantity.value--;
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  void addToCart() {
    Get.snackbar('تم', 'تمت إضافة المنتج إلى السلة');
  }
}
