import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/configs/app_enums.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/base_service_mapper.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

import '../BaseService/base_service_controller.dart';

/// Booking / health service vendors for a home section.
///
/// Contract: `GET /api/v1/services?section_id=&type=&latitude=&longitude=`
/// Card tap → [MarketTypeRouter] (hotel/cinema/entertainment booking or place details).
class ServiceSectionController extends BaseServiceController {
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  GetStorageHelper storageHelper = Get.find();

  Section? section;

  /// Optional MarketType filter from `route_key` / args (`hotel`, `cinema`, …).
  String? marketTypeFilter;

  final Rx<ApiResponse<dynamic>> servicesResponse =
      ApiResponse<dynamic>.init().obs;

  String get sectionName => section?.name ?? 'auto_key_294'.tr;

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
    final fromArgs = args is Map ? args['market_type']?.toString() : null;
    final fromSection = section?.routeKey;
    final candidate = (fromArgs ?? fromSection ?? '').trim().toLowerCase();
    if (AppEnums.sectionBookingRouteKeys.contains(candidate)) {
      marketTypeFilter = candidate;
    } else {
      marketTypeFilter = null;
    }
  }

  @override
  Future<void> fetchData() async {
    _readArgs();
    isLoading.value = true;
    errorMessage.value = '';
    servicesResponse.value = ApiResponse<dynamic>.loading('');
    allItems.clear();
    featuredItems.clear();
    categories.assignAll([
      ServiceCategory(name: 'all'.tr, icon: Iconsax.category),
    ]);

    if (section == null) {
      servicesResponse.value = ApiResponse<dynamic>.error('auto_key_401'.tr);
      errorMessage.value = servicesResponse.value.message;
      isLoading.value = false;
      return;
    }

    if (!await connectionChecker.hasConnection) {
      servicesResponse.value =
          ApiResponse<dynamic>.error('check_connection'.tr);
      errorMessage.value = servicesResponse.value.message;
      isLoading.value = false;
      return;
    }

    try {
      final res = await repository.getServices(
        lat: storageHelper.getUserLatitude,
        lng: storageHelper.getUserLongtude,
        sectionId: section!.id > 0 ? section!.id : null,
        type: marketTypeFilter,
      );
      final data = ApiResult.ensureSuccess(res);
      servicesResponse.value = ApiResponse<dynamic>.completed(res);

      final list = data is Map
          ? data['near_from_you'] as List? ?? const []
          : const <dynamic>[];

      final fallbackType = marketTypeFilter ?? AppEnums.marketService;
      final items = list
          .whereType<Map>()
          .map(
            (e) => BaseServiceMapper.fromMarket(
              e,
              serviceType: fallbackType,
            ),
          )
          .toList();

      allItems.assignAll(items);
      featuredItems.assignAll(allItems.take(3).toList());

      final typeLabels = items
          .map((e) => e.category)
          .where((c) => c.isNotEmpty)
          .toSet();
      if (typeLabels.length > 1) {
        categories.assignAll([
          ServiceCategory(name: 'all'.tr, icon: Iconsax.category),
          ...typeLabels.map(
            (name) => ServiceCategory(name: name, icon: Iconsax.shop),
          ),
        ]);
      }
    } on DioException catch (error) {
      log(error.response?.data?.toString() ?? error.toString());
      servicesResponse.value = ApiResponse<dynamic>.error(
        DioErrorUtil.handleError(error),
      );
      errorMessage.value = servicesResponse.value.message;
      AppSnackbar.showError(message: errorMessage.value);
    } on ApiException catch (e) {
      servicesResponse.value = ApiResponse<dynamic>.error(e.message);
      errorMessage.value = e.message;
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      servicesResponse.value = ApiResponse<dynamic>.error(e.toString());
      errorMessage.value = e.toString();
      AppSnackbar.showError(message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
