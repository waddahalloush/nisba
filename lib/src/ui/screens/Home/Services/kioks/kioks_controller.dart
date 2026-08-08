import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/base_service_mapper.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

import '../BaseService/base_service_controller.dart';

/// Kiosk list: `GET /kiosks` (fallback `/kioks`) → `near_from_you`.
/// Card tap → [MarketTypeRouter] → restorant details (product order).
class KioskController extends BaseServiceController {
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  GetStorageHelper storageHelper = Get.find();

  Section? section;

  final Rx<ApiResponse<dynamic>> kioksResponse =
      ApiResponse<dynamic>.init().obs;

  String get sectionName => section?.name ?? 'auto_key_383'.tr;

  @override
  void onInit() {
    _readArgs();
    super.onInit();
  }

  void _readArgs() {
    final args = Get.arguments;
    if (args is Map && args['section'] is Section) {
      section = args['section'] as Section;
    }
  }

  @override
  Future<void> fetchData() async {
    _readArgs();
    isLoading.value = true;
    errorMessage.value = '';
    kioksResponse.value = ApiResponse<dynamic>.loading('');
    allItems.clear();
    featuredItems.clear();
    categories.assignAll([
      ServiceCategory(name: 'all'.tr, icon: Iconsax.category),
    ]);

    if (!await connectionChecker.hasConnection) {
      kioksResponse.value =
          ApiResponse<dynamic>.error('check_connection'.tr);
      errorMessage.value = kioksResponse.value.message;
      isLoading.value = false;
      return;
    }

    try {
      final res = await repository.getKioks(
        lat: storageHelper.getUserLatitude,
        lng: storageHelper.getUserLongtude,
        sectionId: section?.id,
      );
      final data = ApiResult.ensureSuccess(res);
      kioksResponse.value = ApiResponse<dynamic>.completed(res);
      final list = data is Map
          ? data['near_from_you'] as List? ?? const []
          : const <dynamic>[];

      final items = list
          .whereType<Map>()
          .map(
            (e) => BaseServiceMapper.fromMarket(
              e,
              serviceType: 'kioks',
              fallbackImage: Assets.images.kiosk1.path,
            ),
          )
          .where((e) => int.tryParse(e.id) != null)
          .toList();

      allItems.assignAll(items);
      featuredItems.assignAll(allItems.take(3).toList());

      final labels = items
          .map((e) => e.category)
          .where((c) => c.isNotEmpty)
          .toSet();
      if (labels.length > 1) {
        categories.assignAll([
          ServiceCategory(name: 'all'.tr, icon: Iconsax.category),
          ...labels.map(
            (name) => ServiceCategory(name: name, icon: Iconsax.shop),
          ),
        ]);
      }
    } on DioException catch (error) {
      log(error.response?.data?.toString() ?? error.toString());
      kioksResponse.value = ApiResponse<dynamic>.error(
        DioErrorUtil.handleError(error),
      );
      errorMessage.value = kioksResponse.value.message;
      AppSnackbar.showError(message: errorMessage.value);
    } on ApiException catch (e) {
      kioksResponse.value = ApiResponse<dynamic>.error(e.message);
      errorMessage.value = e.message;
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      kioksResponse.value = ApiResponse<dynamic>.error(e.toString());
      errorMessage.value = e.toString();
      AppSnackbar.showError(message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
