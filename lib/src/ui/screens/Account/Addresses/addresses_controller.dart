import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class AddressModel {
  final int? id;
  final String name;
  final String info;
  final String street;
  final String phone;
  final String type;

  const AddressModel({
    this.id,
    required this.name,
    required this.info,
    required this.street,
    required this.phone,
    required this.type,
  });

  factory AddressModel.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final typeRaw = map['type'];
    final typeDesc = typeRaw is Map
        ? typeRaw['desc']?.toString() ?? typeRaw['value']?.toString() ?? ''
        : typeRaw?.toString() ?? '';
    return AddressModel(
      id: int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
      info: map['info']?.toString() ?? '',
      street: map['street']?.toString() ?? '',
      phone: [
        map['country_key']?.toString() ?? '',
        map['phone']?.toString() ?? '',
      ].where((e) => e.isNotEmpty).join(' '),
      type: typeDesc,
    );
  }
}

class AddressesController extends GetxController {
  final addresses = <AddressModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  final nameController = TextEditingController();
  final buildingController = TextEditingController();
  final apartmentController = TextEditingController();
  final floorController = TextEditingController();
  final streetController = TextEditingController();
  final infoController = TextEditingController();
  final phoneController = TextEditingController();
  final selectedType = 'house'.obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();
  final GetStorageHelper storageHelper = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchAddresses();
  }

  Future<void> fetchAddresses() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getAddresses();
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map
          ? (data['addresses'] as List? ?? [])
          : (data is List ? data : []);
      addresses.assignAll(
        list.whereType<Map>().map(AddressModel.fromApiMap).toList(),
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

  void showAddDialog() {
    nameController.clear();
    buildingController.clear();
    apartmentController.clear();
    floorController.clear();
    streetController.clear();
    infoController.clear();
    phoneController.clear();
    selectedType.value = 'house';

    Get.dialog(
      AlertDialog(
        title: Text('auto_key_16'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'auto_key_17'.tr),
              ),
              TextField(
                controller: buildingController,
                decoration: InputDecoration(labelText: 'auto_key_18'.tr),
              ),
              TextField(
                controller: apartmentController,
                decoration: InputDecoration(labelText: 'auto_key_19'.tr),
              ),
              TextField(
                controller: floorController,
                decoration: InputDecoration(labelText: 'auto_key_20'.tr),
              ),
              TextField(
                controller: streetController,
                decoration: InputDecoration(labelText: 'auto_key_21'.tr),
              ),
              TextField(
                controller: infoController,
                decoration: InputDecoration(labelText: 'auto_key_22'.tr),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'auto_key_23'.tr),
              ),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: selectedType.value,
                  decoration: InputDecoration(labelText: 'auto_key_24'.tr),
                  items: [
                    DropdownMenuItem(value: 'house', child: Text('auto_key_25'.tr)),
                    DropdownMenuItem(
                      value: 'apartment',
                      child: Text('auto_key_26'.tr),
                    ),
                    DropdownMenuItem(value: 'office', child: Text('auto_key_27'.tr)),
                  ],
                  onChanged: (v) {
                    if (v != null) selectedType.value = v;
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          Obx(
            () => TextButton(
              onPressed: isSubmitting.value ? null : storeAddress,
              child: isSubmitting.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('save'.tr),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> storeAddress() async {
    if (nameController.text.trim().isEmpty ||
        buildingController.text.trim().isEmpty ||
        streetController.text.trim().isEmpty) {
      AppSnackbar.showError(message: 'auto_key_28'.tr);
      return;
    }
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    isSubmitting.value = true;
    try {
      final user = storageHelper.getUser;
      final res = await repository.storeAddress(
        data: {
          'name': nameController.text.trim(),
          'building_name': buildingController.text.trim(),
          'apartment_number': apartmentController.text.trim().isEmpty
              ? '1'
              : apartmentController.text.trim(),
          'floor_number': floorController.text.trim().isEmpty
              ? '1'
              : floorController.text.trim(),
          'street': streetController.text.trim(),
          'info': infoController.text.trim().isEmpty
              ? nameController.text.trim()
              : infoController.text.trim(),
          'country_key': user?.key ?? '+974',
          'phone': phoneController.text.trim().isEmpty
              ? (user?.phone ?? '00000000')
              : phoneController.text.trim(),
          'latitude': storageHelper.getUserLatitude.toString(),
          'longitude': storageHelper.getUserLongtude.toString(),
          'type': selectedType.value,
        },
      );
      ApiResult.ensureSuccess(res);
      Get.back();
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'auto_key_29'.tr,
      );
      await fetchAddresses();
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

  Future<void> deleteAddress(AddressModel address) async {
    final id = address.id;
    if (id == null) return;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.deleteAddress(id);
      ApiResult.ensureSuccess(res);
      addresses.removeWhere((a) => a.id == id);
      AppSnackbar.showSuccess(
        message: (res is Map ? res['message'] : null)?.toString() ??
            'auto_key_30'.tr,
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    buildingController.dispose();
    apartmentController.dispose();
    floorController.dispose();
    streetController.dispose();
    infoController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}
