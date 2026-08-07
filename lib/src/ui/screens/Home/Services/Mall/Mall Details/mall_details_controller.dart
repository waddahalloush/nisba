import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/ui/screens/Home/BaseService/market_type_router.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

/// Data model for a featured restaurant / store card inside a mall.
class MallVendorCard {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  final String marketType;

  const MallVendorCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.marketType,
  });

  factory MallVendorCard.fromMarketMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final mt = map['market_type'];
    final typeValue = mt is Map
        ? mt['value']?.toString() ?? 'store'
        : mt?.toString() ?? 'store';
    return MallVendorCard(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      imageUrl:
          map['main_image']?.toString() ?? map['image']?.toString() ?? '',
      rating: double.tryParse(map['rating']?.toString() ?? '') ?? 0,
      marketType: typeValue.isNotEmpty ? typeValue : 'store',
    );
  }

  BaseServiceItem toServiceItem() => BaseServiceItem(
        id: '$id',
        name: name,
        subTitle: '',
        imageUrl: imageUrl,
        address: '',
        rating: rating,
        reviewsCount: 0,
        distance: '',
        category: marketType,
        serviceType: marketType,
        aboutText: '',
      );
}

class MallDetailsController extends GetxController {
  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();
  final GetStorageHelper storageHelper = Get.find();

  final selectedTab = 'نظرة عامة'.obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  int? mallId;
  final mallImage = ''.obs;
  final mallName = ''.obs;
  final address = ''.obs;
  final locationDetail = ''.obs;
  final rating = 0.0.obs;
  final stars = 5.obs;
  final workingHours = ''.obs;
  final storesCount = '0'.obs;
  final hasFreeParking = true.obs;
  final aboutText = ''.obs;

  final tabs = <String>[
    'نظرة عامة',
    'المتاجر',
    'المطاعم',
  ];

  final infoCards = <_InfoCard>[].obs;
  final actions = <String>[
    'خدمة العملاء',
    'خريطة المول',
    'العروض والفعاليات',
    'الوصول للمول',
  ];

  final featuredRestaurants = <MallVendorCard>[].obs;
  final featuredStores = <MallVendorCard>[].obs;
  final facilities = <String>[
    'مصاعد',
    'منطقة أطفال',
    'واي فاي مجاني',
    'غرفة صلاة',
    'دورات مياه',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _resolveArgs();
    if (mallId != null && mallId! > 0) {
      fetchMallDetail();
    } else {
      errorMessage.value = 'معرّف المول غير صالح';
    }
  }

  void _resolveArgs() {
    final args = Get.arguments;
    if (args is int) {
      mallId = args;
    } else if (args is BaseServiceItem) {
      mallId = int.tryParse(args.id);
      mallName.value = args.name;
      mallImage.value = args.imageUrl;
      if (args.address.isNotEmpty) address.value = args.address;
      if (args.aboutText.isNotEmpty) aboutText.value = args.aboutText;
      rating.value = args.rating;
    } else if (args is Map) {
      final map = Map<String, dynamic>.from(args);
      mallId = int.tryParse(map['id']?.toString() ?? '');
      mallName.value = map['name']?.toString() ?? '';
      mallImage.value =
          map['image']?.toString() ?? map['imageUrl']?.toString() ?? '';
    }
  }

  Future<void> fetchMallDetail() async {
    final id = mallId;
    if (id == null || id <= 0) return;
    if (!await connectionChecker.hasConnection) {
      errorMessage.value = 'check_connection'.tr;
      AppSnackbar.showError(message: errorMessage.value);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await repository.getMallDetail(id);
      final data = ApiResult.ensureSuccess(res);
      if (data is! Map) return;

      final mall = data['mall'];
      if (mall is Map) {
        mallName.value = mall['name']?.toString() ?? mallName.value;
        mallImage.value = mall['image']?.toString() ?? mallImage.value;
        final loc = mall['location']?.toString() ?? '';
        if (loc.isNotEmpty) {
          address.value = loc;
          locationDetail.value = loc;
        }
        rating.value =
            double.tryParse(mall['rating']?.toString() ?? '') ?? rating.value;
        aboutText.value =
            mall['description']?.toString() ?? aboutText.value;
        final open = mall['opening_time']?.toString() ?? '';
        final close = mall['close_time']?.toString() ?? '';
        if (open.isNotEmpty || close.isNotEmpty) {
          workingHours.value = '$open - $close'.trim();
        } else if (mall['is_open'] == true) {
          workingHours.value = 'مفتوح الآن';
        } else if (mall['is_open'] == false) {
          workingHours.value = 'مغلق الآن';
        }
        hasFreeParking.value = mall['has_parking'] != false;
      }

      final fromSections = <Map<String, dynamic>>[];
      final sections = data['mall_sections'] as List? ?? [];
      for (final section in sections.whereType<Map>()) {
        // Official key is `markets`; `market` kept as temporary alias from API.
        final markets = section['markets'] as List? ??
            section['market'] as List? ??
            const [];
        fromSections.addAll(
          markets.whereType<Map>().map(Map<String, dynamic>.from),
        );
      }

      var markets = fromSections;
      if (markets.isEmpty) {
        markets = await _fetchMarketsByMallId(id);
      }
      _applyVendors(markets);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      errorMessage.value = DioErrorUtil.handleError(e);
      AppSnackbar.showError(message: errorMessage.value);
    } catch (e) {
      log('fetchMallDetail: $e');
      errorMessage.value = e.toString();
      AppSnackbar.showError(message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Map<String, dynamic>>> _fetchMarketsByMallId(int id) async {
    try {
      final res = await repository.getMarkets(
        lat: storageHelper.getUserLatitude,
        lng: storageHelper.getUserLongtude,
        mallId: id,
        radiusKm: 50000,
      );
      final data = ApiResult.ensureSuccess(res);
      if (data is! Map) return const [];
      final list = data['stores'] as List? ?? const [];
      return list.whereType<Map>().map(Map<String, dynamic>.from).toList();
    } catch (e) {
      log('_fetchMarketsByMallId: $e');
      return const [];
    }
  }

  void _applyVendors(List<Map<String, dynamic>> markets) {
    final cards = markets
        .map(MallVendorCard.fromMarketMap)
        .where((c) => c.id > 0)
        .toList();

    final stores = cards
        .where(
          (c) =>
              c.marketType == 'store' ||
              c.marketType == 'kioks' ||
              c.marketType == 'service',
        )
        .toList();
    final restaurants = cards
        .where((c) => c.marketType == 'store')
        .toList();

    // Prefer typed split; if everything is store, show all in stores + restaurants.
    featuredStores.assignAll(stores.isNotEmpty ? stores : cards);
    featuredRestaurants.assignAll(
      restaurants.isNotEmpty ? restaurants : cards,
    );

    storesCount.value = '${cards.length}';
    infoCards.assignAll([
      _InfoCard(
        title: 'المتاجر',
        value: '${cards.length}',
        iconLabel: 'تسوق',
      ),
      if (mallImage.value.isNotEmpty)
        const _InfoCard(
          title: 'المول',
          value: 'مفتوح',
          iconLabel: 'مول',
        ),
    ]);
  }

  void selectTab(String tab) => selectedTab.value = tab;

  void openVendor(MallVendorCard card) {
    if (card.id <= 0) return;
    MarketTypeRouter.open(
      card.marketType,
      arguments: card.toServiceItem(),
    );
  }
}

class _InfoCard {
  final String title;
  final String value;
  final String iconLabel;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.iconLabel,
  });
}
