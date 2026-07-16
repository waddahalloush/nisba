import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/add_car_form.dart';

class CarModel {
  final String plateNumber;
  final String brand;
  final String category;
  final String color;
  final String imageUrl;

  const CarModel({
    required this.plateNumber,
    required this.brand,
    required this.category,
    required this.color,
    required this.imageUrl,
  });
}

class MyCarsController extends GetxController {
  final plateController = TextEditingController();
  final selectedBrand = ''.obs;
  final selectedCategory = ''.obs;
  final selectedColor = ''.obs;

  final brands = <String>[
    'مرسيدس',
    'بي إم دبليو',
    'أودي',
    'تويوتا',
    'نيسان',
    'هيونداي',
    'لكزس',
  ];

  final categories = <String>[
    'خليجية',
    'سيدان',
    'دفع رباعي',
    'كوبيه',
    'هاتشباك',
  ];

  final colors = <String>['أحمر', 'أبيض', 'أسود', 'فضي', 'أزرق', 'رمادي'];

  final cars = <CarModel>[
    const CarModel(
      plateNumber: '255455855',
      brand: 'مرسيدس',
      category: 'خليجية',
      color: 'أحمر',
      imageUrl: '',
    ),
  ].obs;

  void addCar() {
    if (plateController.text.trim().isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال رقم اللوحة');
      return;
    }
    if (selectedBrand.value.isEmpty) {
      Get.snackbar('خطأ', 'يرجى اختيار الماركة');
      return;
    }
    cars.add(
      CarModel(
        plateNumber: plateController.text.trim(),
        brand: selectedBrand.value,
        category: selectedCategory.value,
        color: selectedColor.value,
        imageUrl: '',
      ),
    );
    plateController.clear();
    selectedBrand.value = '';
    selectedCategory.value = '';
    selectedColor.value = '';
    Get.back();
    Get.snackbar('نجاح', 'تمت إضافة السيارة بنجاح');
  }

  void deleteCar(int index) {
    cars.removeAt(index);
  }

  void selectBrand(String brand) => selectedBrand.value = brand;
  void selectCategory(String cat) => selectedCategory.value = cat;
  void selectColor(String color) => selectedColor.value = color;

  void showAddCarBottomSheet() => Get.bottomSheet(
    const AddCarForm(),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );

  void showBrandPicker() => _showPicker('الماركة', brands, selectBrand);
  void showCategoryPicker() => _showPicker('الفئة', categories, selectCategory);
  void showColorPicker() => _showPicker('اللون', colors, selectColor);

  void _showPicker(
    String title,
    List<String> options,
    Function(String) onSelect,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...options.map(
              (o) => ListTile(
                title: Text(o),
                onTap: () {
                  onSelect(o);
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    plateController.dispose();
    super.onClose();
  }
}
