import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/BaseService/base_service_controller.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/base_service_mapper.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class CommercialCenterController extends BaseServiceController {
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  GetStorageHelper storageHelper = Get.find();

  final Rx<ApiResponse<dynamic>> centersResponse =
      ApiResponse<dynamic>.init().obs;

  @override
  Future<void> fetchData() async {
    isLoading.value = true;
    errorMessage.value = '';
    centersResponse.value = ApiResponse<dynamic>.loading('');

    categories.assignAll(const [
      ServiceCategory(name: 'الكل', icon: Iconsax.category),
    ]);

    if (!await connectionChecker.hasConnection) {
      centersResponse.value = ApiResponse<dynamic>.error('check_connection'.tr);
      errorMessage.value = centersResponse.value.message;
      isLoading.value = false;
      return;
    }

    try {
      final res = await repository.getCommercialCenters(
        lat: storageHelper.getUserLatitude,
        lng: storageHelper.getUserLongtude,
      );
      final data = ApiResult.ensureSuccess(res);
      centersResponse.value = ApiResponse<dynamic>.completed(res);
      final list = data is Map
          ? data['commercial_centers'] as List? ??
                data['near_from_you'] as List? ??
                const []
          : <dynamic>[];
      if (list.isEmpty) {
        allItems.clear();
        featuredItems.clear();
      } else {
        allItems.assignAll(
          list
              .whereType<Map>()
              .map(
                (e) => BaseServiceMapper.fromMallOrCenter(
                  e,
                  Iconsax.reserve,
                  serviceType: 'commercial_center',
                  category: 'مراكز تجارية',
                  fallbackImage: Assets.images.mall11.path,
                ),
              )
              .where((e) => int.tryParse(e.id) != null)
              .toList(),
        );
        featuredItems.assignAll(allItems.take(3).toList());
      }
    } on DioException catch (error) {
      log(error.response?.data?['message']?.toString() ?? error.toString());
      centersResponse.value = ApiResponse<dynamic>.error(
        DioErrorUtil.handleError(error),
      );
      errorMessage.value = centersResponse.value.message;
      AppSnackbar.showError(message: errorMessage.value);
    } on ApiException catch (e) {
      centersResponse.value = ApiResponse<dynamic>.error(e.message);
      errorMessage.value = e.message;
      AppSnackbar.showError(message: errorMessage.value);
    } catch (e) {
      centersResponse.value = ApiResponse<dynamic>.error(e.toString());
      errorMessage.value = 'حدث خطأ أثناء جلب البيانات: $e';
      AppSnackbar.showError(message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
