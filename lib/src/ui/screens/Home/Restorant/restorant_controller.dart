import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

import '../../../../data/models/Home/home_model.dart';
import '../../../../data/models/restorant_model.dart';
import '../../../../data/models/section_details_model.dart';

class RestorantController extends GetxController {
  final restaurants = <RestorantModel>[].obs;
  final offersStrip = <Map<String, dynamic>>[].obs;

  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  GetStorageHelper storageHelper = Get.find();

  final Rx<ApiResponse<SectionDetailsResponse>> sectionResponse =
      ApiResponse<SectionDetailsResponse>.init().obs;

  final Section args = Get.arguments['section'] as Section;

  /// Maps API tags to the format expected by [RestorantScreen._buildCategoryIcons].
  List<Map<String, String>> get categories {
    if (sectionResponse.value.status != Status.completed) return [];
    final data = sectionResponse.value.data.data;
    if (data == null) return [];
    return data.tags.map((t) => {'icon': t.image, 'label': t.name}).toList();
  }

  /// Title for the restaurant grid section.
  final RxString restorantTitle = ''.obs;
  @override
  void onInit() {
    super.onInit();

    fetchSectionDetails(args.id);
  }

  /// Fetches a section's stores/popular stores/tags/offers and adapts them
  /// to this screen's existing widgets.
  Future<void> fetchSectionDetails(int id) async {
    sectionResponse.value = ApiResponse<SectionDetailsResponse>.loading('');
    if (!await connectionChecker.hasConnection) {
      sectionResponse.value = ApiResponse<SectionDetailsResponse>.error(
        'check_connection'.tr,
      );
      return;
    }
    try {
      final res = await repository.getSectionDetails(id);
      sectionResponse.value = ApiResponse<SectionDetailsResponse>.completed(
        res,
      );
      _applySectionData(res.data);
    } on DioException catch (error) {
      log(error.response?.data?['message']?.toString() ?? error.toString());
      sectionResponse.value = ApiResponse<SectionDetailsResponse>.error(
        DioErrorUtil.handleError(error),
      );
      AppSnackbar.showError(message: sectionResponse.value.message);
    } catch (e) {
      sectionResponse.value = ApiResponse<SectionDetailsResponse>.error(
        e.toString(),
      );
    }
  }

  void _applySectionData(SectionData? data) {
    if (data == null) return;
    restorantTitle.value = args.name;

    // Map stores + popular stores → RestorantModel list
    final allStores = [...data.popularStores, ...data.stores];
    restaurants.assignAll(
      allStores.map(
        (m) => RestorantModel(
          id: m.id,
          name: m.name,
          rating: m.rating.toDouble(),
          deliveryTime: 'auto_key_259'.tr,
          distance: m.distance?.toStringAsFixed(1) ?? '',
          imagePath: m.mainImage,
          isFavorite: m.isFav,
        ),
      ),
    );
  }
}
