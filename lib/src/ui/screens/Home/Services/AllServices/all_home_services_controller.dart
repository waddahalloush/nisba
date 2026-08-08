import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/data/models/home_category_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/service_section_navigator.dart';
import 'package:nisba_app/src/ui/screens/Home/home_controller.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

/// "All services" grid driven by home `service_sections` / `GET /sections?type=service`.
class AllHomeServicesController extends GetxController {
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  final isLoading = false.obs;
  final RxList<HomeCategoryModel> homeServiceList = <HomeCategoryModel>[].obs;

  static const _fallbackIcons = [
    'serv1',
    'serv2',
    'serv3',
    'serv5',
    'serv6',
    'serv7',
    'serv8',
    'serv9',
  ];

  @override
  void onInit() {
    super.onInit();
    loadSections();
  }

  Future<void> loadSections() async {
    isLoading.value = true;
    try {
      // Prefer already-loaded home sections when available.
      if (Get.isRegistered<HomeController>()) {
        final home = Get.find<HomeController>();
        final fromHome = home.serviceSections;
        if (fromHome.isNotEmpty) {
          _applySections(fromHome);
          return;
        }
      }

      if (!await connectionChecker.hasConnection) {
        AppSnackbar.showError(message: 'check_connection'.tr);
        _applyFallbackTiles();
        return;
      }

      final res = await repository.getSections(type: 'service');
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map ? data['sections'] as List? ?? [] : <dynamic>[];
      final sections = list
          .whereType<Map>()
          .map((e) => Section.fromJson(Map<String, dynamic>.from(e)))
          .where((s) => s.id > 0)
          .toList();

      if (sections.isEmpty) {
        _applyFallbackTiles();
      } else {
        _applySections(sections);
      }
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
      _applyFallbackTiles();
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
      _applyFallbackTiles();
    } catch (e) {
      log(e.toString());
      _applyFallbackTiles();
    } finally {
      isLoading.value = false;
    }
  }

  void _applySections(List<Section> sections) {
    homeServiceList.assignAll(
      sections.asMap().entries.map((entry) {
        final i = entry.key;
        final section = entry.value;
        final hasNet = section.image.startsWith('http');
        return HomeCategoryModel(
          catName: section.name,
          catIcon: hasNet ? section.image : _assetFallback(i),
          isNetworkIcon: hasNet,
          onTap: () => ServiceSectionNavigator.open(section),
        );
      }),
    );
  }

  String _assetFallback(int index) {
    final key = _fallbackIcons[index % _fallbackIcons.length];
    switch (key) {
      case 'serv1':
        return Assets.images.serv1.path;
      case 'serv2':
        return Assets.images.serv2.path;
      case 'serv3':
        return Assets.images.serv3.path;
      case 'serv5':
        return Assets.images.serv5.path;
      case 'serv6':
        return Assets.images.serv6.path;
      case 'serv7':
        return Assets.images.serv7.path;
      case 'serv8':
        return Assets.images.serv8.path;
      case 'serv9':
        return Assets.images.serv9.path;
      default:
        return Assets.images.serv1.path;
    }
  }

  /// Offline / empty API: keep navigable tiles via empty Section + route_key.
  void _applyFallbackTiles() {
    final tiles = <({String name, String key, String icon})>[
      (
        name: 'auto_key_386'.tr,
        key: 'entertainment',
        icon: Assets.images.serv1.path,
      ),
      (name: 'tourism'.tr, key: 'tourism', icon: Assets.images.serv2.path),
      (name: 'gifts'.tr, key: 'gifts', icon: Assets.images.serv6.path),
      (name: 'auto_key_543'.tr, key: 'hotel', icon: Assets.images.serv5.path),
      (name: 'auto_key_535'.tr, key: 'cinema', icon: Assets.images.serv3.path),
      (
        name: 'auto_key_536'.tr,
        key: 'transport',
        icon: Assets.images.serv9.path,
      ),
      (name: 'clinics'.tr, key: 'service', icon: Assets.images.serv8.path),
      (name: 'auto_key_388'.tr, key: 'mall', icon: Assets.images.serv7.path),
      (
        name: 'auto_key_379'.tr,
        key: 'commercial_center',
        icon: Assets.images.serv7.path,
      ),
      (name: 'kiosks'.tr, key: 'kioks', icon: Assets.images.serv9.path),
    ];
    homeServiceList.assignAll(
      tiles.map(
        (t) => HomeCategoryModel(
          catName: t.name,
          catIcon: t.icon,
          onTap: () => ServiceSectionNavigator.open(
            Section(
              id: 0,
              name: t.name,
              image: t.icon,
              type: 'service',
              routeKey: t.key,
            ),
          ),
        ),
      ),
    );
  }
}
