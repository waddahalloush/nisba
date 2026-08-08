// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';
import 'package:nisba_app/src/configs/api_response.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/ui/screens/Home/BaseService/market_type_router.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

/// نموذج بيانات المطعم/الشريك
class PartnerModel {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  final String location;
  final String promotion;
  final double distanceKm;
  final double latitude;
  final double longitude;
  final String marketType;
  final bool isFavorite;

  const PartnerModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.promotion,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.marketType,
    this.isFavorite = false,
  });

  String get typeLabel {
    switch (marketType) {
      case 'store':
        return 'auto_key_533'.tr;
      case 'service':
        return 'auto_key_534'.tr;
      case 'cinema':
        return 'auto_key_535'.tr;
      case 'hotel':
        return 'auto_key_301'.tr;
      case 'entertainment':
        return 'auto_key_386'.tr;
      case 'transport':
        return 'auto_key_536'.tr;
      case 'kioks':
        return 'auto_key_537'.tr;
      case 'mall':
        return 'auto_key_320'.tr;
      default:
        return marketType.isEmpty ? 'auto_key_538'.tr : marketType;
    }
  }

  PartnerModel copyWith({bool? isFavorite}) => PartnerModel(
    id: id,
    name: name,
    imageUrl: imageUrl,
    rating: rating,
    location: location,
    promotion: promotion,
    distanceKm: distanceKm,
    latitude: latitude,
    longitude: longitude,
    marketType: marketType,
    isFavorite: isFavorite ?? this.isFavorite,
  );

  factory PartnerModel.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final typeRaw = map['market_type'];
    String marketType = '';
    if (typeRaw is Map) {
      marketType = typeRaw['value']?.toString() ?? '';
    } else {
      marketType = typeRaw?.toString() ?? '';
    }

    final distanceRaw = map['distance'];
    double distanceKm = 0;
    if (distanceRaw is num) {
      distanceKm = distanceRaw.toDouble();
    } else {
      distanceKm = double.tryParse(distanceRaw?.toString() ?? '') ?? 0;
    }

    return PartnerModel(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      imageUrl:
          map['main_image']?.toString() ??
          map['image']?.toString() ??
          map['logo']?.toString() ??
          '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      location: map['location']?.toString() ?? '',
      promotion: map['preparation_time']?.toString().isNotEmpty == true
          ? '${'auto_key_539'.tr} ${map['preparation_time']}'
          : '',
      distanceKm: distanceKm,
      latitude: double.tryParse(map['latitude']?.toString() ?? '') ?? 0,
      longitude: double.tryParse(map['longitude']?.toString() ?? '') ?? 0,
      marketType: marketType,
      isFavorite: map['is_fav'] == true || map['is_fav'] == 1,
    );
  }
}

class SearchhController extends GetxController {
  static final _serviceDiscoveryTypes = [
    'service',
    'cinema',
    'hotel',
    'entertainment',
    'transport',
  ];

  static final storeSubLabels = [
    'auto_key_540'.tr,
    'auto_key_541'.tr,
    'auto_key_542'.tr,
    'auto_key_387'.tr,
  ];
  static final serviceSubLabels = [
    'auto_key_534'.tr,
    'auto_key_535'.tr,
    'auto_key_543'.tr,
    'auto_key_386'.tr,
  ];
  static const serviceSubTypes = [
    'service',
    'cinema',
    'hotel',
    'entertainment',
  ];

  final isMapView = false.obs;
  final selectedMainTab = 0.obs;

  /// -1 = بدون تبويب فرعي
  final selectedSubTab = (-1).obs;
  final selectedSort = 'auto_key_544'.tr.obs;
  final keyword = ''.obs;
  final searchTextController = TextEditingController();

  final partners = <PartnerModel>[].obs;
  final mapPartners = <PartnerModel>[].obs;
  final pageStatus = Status.init.obs;
  final mapStatus = Status.init.obs;
  final errorMessage = ''.obs;

  final userLat = 25.197576984594022.obs;
  final userLng = 51.43304057768011.obs;
  final mapCenter = const LatLng(25.197576984594022, 51.43304057768011).obs;

  /// Viewport used when calling /map (updated on camera move).
  final northEast = const LatLng(25.35, 51.60).obs;
  final southWest = const LatLng(25.05, 51.25).obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();
  final GetStorageHelper storageHelper = Get.find();

  Timer? _searchDebounce;
  Timer? _mapDebounce;

  List<String> get subTabLabels =>
      selectedMainTab.value == 2 ? serviceSubLabels : storeSubLabels;

  List<PartnerModel> get filteredPartners => partners.toList();

  List<PartnerModel> get nearbyPartners {
    final list = (isMapView.value ? mapPartners : partners).toList();
    list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    return list.take(12).toList();
  }

  @override
  void onInit() {
    super.onInit();
    userLat.value = storageHelper.getUserLatitude;
    userLng.value = storageHelper.getUserLongtude;
    mapCenter.value = LatLng(userLat.value, userLng.value);
    _setDefaultBoundsAroundUser();
    fetchList();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    _mapDebounce?.cancel();
    searchTextController.dispose();
    super.onClose();
  }

  void _setDefaultBoundsAroundUser({double radiusKm = 20}) {
    final lat = userLat.value;
    final lng = userLng.value;
    final deltaLat = radiusKm / 111.0;
    final cosLat = math.max(0.01, math.cos(lat * math.pi / 180.0).abs());
    final deltaLng = radiusKm / (111.0 * cosLat);
    northEast.value = LatLng(lat + deltaLat, lng + deltaLng);
    southWest.value = LatLng(lat - deltaLat, lng - deltaLng);
  }

  String get _sortParam =>
      selectedSort.value == 'auto_key_545'.tr ? 'desc' : 'asc';

  Map<String, dynamic> _buildFilters() {
    final main = selectedMainTab.value;
    final sub = selectedSubTab.value;
    String? type;
    List<String>? types;
    String? extraKeyword;

    if (main == 1) {
      type = 'store';
      if (sub >= 0 && sub < storeSubLabels.length) {
        extraKeyword = storeSubLabels[sub];
      }
    } else if (main == 2) {
      if (sub >= 0 && sub < serviceSubTypes.length) {
        type = serviceSubTypes[sub];
      } else {
        types = List<String>.from(_serviceDiscoveryTypes);
      }
    } else {
      if (sub >= 0 && sub < storeSubLabels.length) {
        extraKeyword = storeSubLabels[sub];
      }
    }

    final parts = <String>[];
    final typed = keyword.value.trim();
    if (typed.isNotEmpty) parts.add(typed);
    // لا تُرسل كلمة التبويب الفرعي إن كان البحث اليدوي موجوداً
    if (typed.isEmpty && extraKeyword != null && extraKeyword.isNotEmpty) {
      // للتبويب 'auto_key_387'.tr ضمن الكل لا نقيّد بالكلمة فقط — نستخدم type=store
      if (main == 0 && extraKeyword == 'auto_key_387'.tr) {
        type = 'store';
      } else if (main == 1 && extraKeyword == 'auto_key_387'.tr) {
        // type already store
      } else if (!(main == 1 && extraKeyword == 'auto_key_387'.tr)) {
        parts.add(extraKeyword);
      }
    }

    return {
      'type': type,
      'types': types,
      'keyword': parts.isEmpty ? null : parts.join(' '),
    };
  }

  Future<void> fetchList({int page = 1}) async {
    pageStatus.value = Status.loading;
    if (!await connectionChecker.hasConnection) {
      pageStatus.value = Status.error;
      errorMessage.value = 'check_connection'.tr;
      AppSnackbar.showError(message: errorMessage.value);
      return;
    }
    try {
      final filters = _buildFilters();
      final res = await repository.getMarkets(
        lat: userLat.value,
        lng: userLng.value,
        type: filters['type'] as String?,
        types: (filters['types'] as List?)?.cast<String>(),
        keyword: filters['keyword'] as String?,
        sort: _sortParam,
        page: page,
      );
      final data = ApiResult.ensureSuccess(res);
      final map = data is Map
          ? Map<String, dynamic>.from(data)
          : <String, dynamic>{};
      final stores = map['stores'] as List? ?? [];
      partners.assignAll(
        stores.whereType<Map>().map(PartnerModel.fromApiMap).toList(),
      );
      pageStatus.value = Status.completed;
    } on ApiException catch (e) {
      pageStatus.value = Status.error;
      errorMessage.value = e.message;
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      pageStatus.value = Status.error;
      errorMessage.value = DioErrorUtil.handleError(e);
      AppSnackbar.showError(message: errorMessage.value);
    } catch (e) {
      pageStatus.value = Status.error;
      errorMessage.value = e.toString();
      AppSnackbar.showError(message: errorMessage.value);
    }
  }

  Future<void> fetchMap() async {
    mapStatus.value = Status.loading;
    if (!await connectionChecker.hasConnection) {
      mapStatus.value = Status.error;
      errorMessage.value = 'check_connection'.tr;
      return;
    }
    try {
      final filters = _buildFilters();
      final query = <String, dynamic>{
        'latitude': userLat.value,
        'longitude': userLng.value,
        'northEastLat': northEast.value.latitude,
        'northEastLng': northEast.value.longitude,
        'southWestLat': southWest.value.latitude,
        'southWestLng': southWest.value.longitude,
        'sort': _sortParam,
        'type': filters['type'],
        'keyword': filters['keyword'],
      };
      final types = filters['types'] as List<String>?;
      if (types != null && types.isNotEmpty) {
        query['types'] = types;
      }

      final res = await repository.getMapMarkets(query: query);
      final data = ApiResult.ensureSuccess(res);
      final map = data is Map
          ? Map<String, dynamic>.from(data)
          : <String, dynamic>{};
      final stores = map['stores'] as List? ?? [];
      mapPartners.assignAll(
        stores.whereType<Map>().map(PartnerModel.fromApiMap).toList(),
      );
      mapStatus.value = Status.completed;
    } on ApiException catch (e) {
      mapStatus.value = Status.error;
      errorMessage.value = e.message;
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      mapStatus.value = Status.error;
      errorMessage.value = DioErrorUtil.handleError(e);
      AppSnackbar.showError(message: errorMessage.value);
    } catch (e) {
      mapStatus.value = Status.error;
      errorMessage.value = e.toString();
      AppSnackbar.showError(message: errorMessage.value);
    }
  }

  void toggleMapView() {
    isMapView.toggle();
    if (isMapView.value) {
      fetchMap();
    } else {
      fetchList();
    }
  }

  void setMapView(bool value) {
    if (isMapView.value == value) return;
    isMapView.value = value;
    if (value) {
      fetchMap();
    } else {
      fetchList();
    }
  }

  void setSort(String value) {
    selectedSort.value = value;
    _reloadCurrent();
  }

  void selectMainTab(int index) {
    selectedMainTab.value = index;
    selectedSubTab.value = -1;
    _reloadCurrent();
  }

  void selectSubTab(int index) {
    // إعادة الضغط تلغي الفلتر الفرعي
    selectedSubTab.value = selectedSubTab.value == index ? -1 : index;
    _reloadCurrent();
  }

  void onSearchChanged(String value) {
    keyword.value = value;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 450), _reloadCurrent);
  }

  void onSearchSubmitted(String value) {
    keyword.value = value.trim();
    _reloadCurrent();
  }

  void onMapBoundsChanged({
    required LatLng ne,
    required LatLng sw,
    required LatLng center,
  }) {
    northEast.value = ne;
    southWest.value = sw;
    mapCenter.value = center;
    _mapDebounce?.cancel();
    _mapDebounce = Timer(const Duration(milliseconds: 500), fetchMap);
  }

  void recenterMap() {
    mapCenter.value = LatLng(userLat.value, userLng.value);
    _setDefaultBoundsAroundUser();
    fetchMap();
  }

  Future<void> toggleFavorite(int index) async {
    if (index < 0 || index >= partners.length) return;
    final partner = partners[index];
    if (partner.id <= 0) return;
    try {
      final res = await repository.favMarket(partner.id);
      ApiResult.ensureSuccess(res);
      partners[index] = partner.copyWith(isFavorite: !partner.isFavorite);
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  void openPartner(PartnerModel partner) {
    if (partner.id <= 0) return;
    MarketTypeRouter.open(
      partner.marketType,
      arguments: {
        'id': partner.id,
        'market_id': partner.id,
        'name': partner.name,
        'image': partner.imageUrl,
        'type': partner.marketType,
      },
    );
  }

  void _reloadCurrent() {
    if (isMapView.value) {
      fetchMap();
    } else {
      fetchList();
    }
  }
}
