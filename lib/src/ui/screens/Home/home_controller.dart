import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class HomeController extends GetxController {
  // متغير تفاعلي للتحكم في البانر النشط وتحديث الـ Dots Indicator بداخل الكارد
  final RxInt currentBannerIndex = 0.obs;

  // متحكم السكرول لتتبع موضع التمرير لأعلى
  late final ScrollController scrollController;

  // قيمة تفاعلية لموضع السكرول الحالي (تُستخدم لحساب التلاشي التدريجي)
  final RxDouble scrollOffset = 0.0.obs;

  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  GetStorageHelper storageHelper = Get.find();

  Rx<ApiResponse<HomeResponse>> homeResponse =
      ApiResponse<HomeResponse>.init().obs;
  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    fetchHome();
  }

  List<BannerItem> get banners => homeResponse.value.data.data.banners;
  List<Section> get marketSections =>
      homeResponse.value.data.data.marketSections;
  List<Section> get serviceSections =>
      homeResponse.value.data.data.serviceSections;
  List<Market> get brands => homeResponse.value.data.data.popularBrand;
  List<Market> get nearFromYou => homeResponse.value.data.data.nearFromYou;
  List<Offer> get offers => homeResponse.value.data.data.offers;

  Future<void> fetchHome() async {
    homeResponse.value = ApiResponse<HomeResponse>.loading('');
    if (!await connectionChecker.hasConnection) {
      homeResponse.value = ApiResponse<HomeResponse>.error(
        'check_connection'.tr,
      );
      return;
    }
    try {
      final res = await repository.getHome(
        lat: storageHelper.getUserLatitude,
        lng: storageHelper.getUserLongtude,
      );
      if (res.status != 'success' && res.status != 'ue') {
        homeResponse.value = ApiResponse<HomeResponse>.error(
          res.message.isNotEmpty ? res.message : 'Request failed',
        );
        AppSnackbar.showError(message: homeResponse.value.message);
        return;
      }
      homeResponse.value = ApiResponse<HomeResponse>.completed(res);
    } on ApiException catch (e) {
      homeResponse.value = ApiResponse<HomeResponse>.error(e.message);
      AppSnackbar.showError(message: e.message);
    } on DioException catch (error) {
      log(error.response?.data?['message']?.toString() ?? error.toString());
      homeResponse.value = ApiResponse<HomeResponse>.error(
        DioErrorUtil.handleError(error),
      );
      AppSnackbar.showError(message: homeResponse.value.message);
    } catch (e) {
      log(e.toString());
      homeResponse.value = ApiResponse<HomeResponse>.error(e.toString());
    }
  }

  void _onScroll() {
    scrollOffset.value = scrollController.hasClients
        ? scrollController.offset
        : 0.0;
  }

  void changeBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
