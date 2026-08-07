import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

import 'widgets/add_car_form.dart';

class CarOption {
  final int id;
  final String name;

  const CarOption({required this.id, required this.name});

  factory CarOption.fromMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return CarOption(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
    );
  }
}

class CarModel {
  final int? id;
  final String plateNumber;
  final String brand;
  final String category;
  final String color;
  final String imageUrl;

  const CarModel({
    this.id,
    required this.plateNumber,
    required this.brand,
    required this.category,
    required this.color,
    required this.imageUrl,
  });

  factory CarModel.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    String nameOf(dynamic v) {
      if (v is Map) return v['name']?.toString() ?? '';
      return v?.toString() ?? '';
    }

    return CarModel(
      id: int.tryParse(map['id']?.toString() ?? ''),
      plateNumber: map['plate_number']?.toString() ?? '',
      brand: nameOf(map['carBrand'] ?? map['car_brand']),
      category: nameOf(map['carClass'] ?? map['car_class']),
      color: nameOf(map['carColor'] ?? map['car_color']),
      imageUrl: map['image']?.toString() ?? '',
    );
  }
}

class MyCarsController extends GetxController {
  final plateController = TextEditingController();
  final selectedBrand = ''.obs;
  final selectedCategory = ''.obs;
  final selectedColor = ''.obs;
  final selectedBrandId = RxnInt();
  final selectedCategoryId = RxnInt();
  final selectedColorId = RxnInt();
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final brands = <CarOption>[].obs;
  final categories = <CarOption>[].obs;
  final colors = <CarOption>[].obs;
  final cars = <CarModel>[].obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchCars();
    fetchCarsInfo();
  }

  Future<void> fetchCars() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getUserCars();
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map
          ? (data['cars'] as List? ?? [])
          : <dynamic>[];
      cars.assignAll(
        list.whereType<Map>().map(CarModel.fromApiMap).toList(),
      );
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

  Future<void> fetchCarsInfo() async {
    try {
      final res = await repository.userCarsInfo();
      final data = ApiResult.ensureSuccess(res);
      if (data is! Map) return;
      brands.assignAll(
        (data['brands'] as List? ?? [])
            .whereType<Map>()
            .map(CarOption.fromMap)
            .toList(),
      );
      categories.assignAll(
        (data['classes'] as List? ?? [])
            .whereType<Map>()
            .map(CarOption.fromMap)
            .toList(),
      );
      colors.assignAll(
        (data['colors'] as List? ?? [])
            .whereType<Map>()
            .map(CarOption.fromMap)
            .toList(),
      );
    } catch (_) {
      // Keep empty option lists; user can still view cars.
    }
  }

  Future<void> addCar() async {
    if (plateController.text.trim().isEmpty) {
      AppSnackbar.showError(message: 'يرجى إدخال رقم اللوحة');
      return;
    }
    if (selectedBrandId.value == null) {
      AppSnackbar.showError(message: 'يرجى اختيار الماركة');
      return;
    }
    if (selectedCategoryId.value == null) {
      AppSnackbar.showError(message: 'يرجى اختيار الفئة');
      return;
    }
    if (selectedColorId.value == null) {
      AppSnackbar.showError(message: 'يرجى اختيار اللون');
      return;
    }
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    isSubmitting.value = true;
    try {
      final res = await repository.storeUserCar(
        data: {
          'plate_number': plateController.text.trim(),
          'car_brand_id': selectedBrandId.value,
          'car_class_id': selectedCategoryId.value,
          'car_color_id': selectedColorId.value,
        },
      );
      ApiResult.ensureSuccess(res);
      plateController.clear();
      selectedBrand.value = '';
      selectedCategory.value = '';
      selectedColor.value = '';
      selectedBrandId.value = null;
      selectedCategoryId.value = null;
      selectedColorId.value = null;
      Get.back();
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'تمت إضافة السيارة بنجاح',
      );
      await fetchCars();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<void> deleteCar(int index) async {
    if (index < 0 || index >= cars.length) return;
    final car = cars[index];
    final id = car.id;
    if (id == null) {
      cars.removeAt(index);
      return;
    }
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.deleteUserCar(id);
      ApiResult.ensureSuccess(res);
      cars.removeAt(index);
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'تم حذف السيارة',
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  void selectBrand(CarOption brand) {
    selectedBrand.value = brand.name;
    selectedBrandId.value = brand.id;
  }

  void selectCategory(CarOption cat) {
    selectedCategory.value = cat.name;
    selectedCategoryId.value = cat.id;
  }

  void selectColor(CarOption color) {
    selectedColor.value = color.name;
    selectedColorId.value = color.id;
  }

  void showAddCarBottomSheet() => Get.bottomSheet(
        const AddCarForm(),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
      );

  void showBrandPicker() =>
      _showPicker('الماركة', brands, selectBrand);
  void showCategoryPicker() =>
      _showPicker('الفئة', categories, selectCategory);
  void showColorPicker() => _showPicker('اللون', colors, selectColor);

  void _showPicker(
    String title,
    List<CarOption> options,
    void Function(CarOption) onSelect,
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
            if (options.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('لا توجد خيارات'),
              )
            else
              ...options.map(
                (o) => ListTile(
                  title: Text(o.name),
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
