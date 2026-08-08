import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/ui/screens/Home/BaseService/market_type_router.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/booking_order_submit.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

import '../../../../../../data/models/service_model.dart';

class PlaceDetailsController extends GetxController {
  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  final Rxn<BaseServiceItem> _item = Rxn<BaseServiceItem>();
  BaseServiceItem get item =>
      _item.value ??
      const BaseServiceItem(
        id: '',
        name: '',
        subTitle: '',
        imageUrl: '',
        address: '',
        rating: 0,
        reviewsCount: 0,
        distance: '',
        category: '',
        serviceType: 'service',
        aboutText: '',
      );

  final isFavorite = false.obs;
  final currentImageIndex = 1.obs;
  final totalImages = 1.obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final errorMessage = ''.obs;

  final selectedItems = <String, int>{}.obs;
  final totalPrice = 0.0.obs;
  final selectedCount = 0.obs;

  /// From `GET /services/{id}` store payload.
  final deliveryTypes = <String>[].obs;
  final paymentMethods = <String>[].obs;
  String selectedDeliveryType = 'at_provider';
  String selectedPaymentMethod = 'wallet';

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  void _bootstrap() {
    final args = Get.arguments;
    if (args is BaseServiceItem) {
      _item.value = args;
      totalImages.value = args.images.isNotEmpty ? args.images.length : 1;
      fetchDetails();
      return;
    }
    if (args is Map) {
      final id = args['id']?.toString() ?? args['market_id']?.toString() ?? '';
      if (id.isNotEmpty) {
        _item.value = BaseServiceItem(
          id: id,
          name: args['name']?.toString() ?? '',
          subTitle: args['subTitle']?.toString() ?? '',
          imageUrl: args['imageUrl']?.toString() ??
              args['main_image']?.toString() ??
              '',
          address: args['address']?.toString() ?? '',
          rating: double.tryParse(args['rating']?.toString() ?? '') ?? 0,
          reviewsCount: 0,
          distance: '',
          category: args['category']?.toString() ?? '',
          serviceType: args['serviceType']?.toString() ??
              args['market_type']?.toString() ??
              'service',
          aboutText: args['aboutText']?.toString() ?? '',
        );
        fetchDetails();
        return;
      }
    }
    if (args is int) {
      _item.value = BaseServiceItem(
        id: '$args',
        name: '',
        subTitle: '',
        imageUrl: '',
        address: '',
        rating: 0,
        reviewsCount: 0,
        distance: '',
        category: '',
        serviceType: 'service',
        aboutText: '',
      );
      fetchDetails();
      return;
    }
    errorMessage.value = 'auto_key_296'.tr;
  }

  bool get _isCommercialCenter =>
      item.serviceType.toLowerCase() == 'commercial_center';

  Future<void> fetchDetails() async {
    final id = int.tryParse(item.id);
    if (id == null || id <= 0) {
      errorMessage.value = 'auto_key_297'.tr;
      return;
    }
    if (!await connectionChecker.hasConnection) {
      errorMessage.value = 'check_connection'.tr;
      AppSnackbar.showError(message: errorMessage.value);
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';
    try {
      if (_isCommercialCenter) {
        await _fetchCommercialCenterDetail(id);
      } else {
        await _fetchServiceDetail(id);
      }
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      errorMessage.value = DioErrorUtil.handleError(e);
      AppSnackbar.showError(message: errorMessage.value);
    } catch (e) {
      log('PlaceDetailsController.fetchDetails: $e');
      errorMessage.value = e.toString();
      AppSnackbar.showError(message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchServiceDetail(int id) async {
    final res = await repository.getServiceDetails(id);
    final data = ApiResult.ensureSuccess(res);
    if (data is! Map) return;

    final store = data['store'];
    final categories = data['categories'] as List? ?? [];

    final subItems = <ServiceSubItem>[];
    for (final cat in categories.whereType<Map>()) {
      final products = cat['products'] as List? ?? [];
      for (final p in products.whereType<Map>()) {
        subItems.add(
          ServiceSubItem(
            id: p['id']?.toString() ?? '',
            name: p['name']?.toString() ?? '',
            description: cat['name']?.toString() ?? '',
            price: double.tryParse(p['price']?.toString() ?? '') ?? 0,
            imageUrl: p['image']?.toString() ?? '',
          ),
        );
      }
    }

    if (store is Map) {
      _applyStoreMethods(store);
      final images = <String>[
        if (store['main_image'] != null) store['main_image'].toString(),
        ...((store['slider'] as List? ?? [])
            .whereType<Map>()
            .map((f) => f['file']?.toString() ?? f['image']?.toString() ?? '')
            .where((s) => s.isNotEmpty)),
      ];
      isFavorite.value = store['is_fav'] == true;
      _item.value = BaseServiceItem(
        id: store['id']?.toString() ?? item.id,
        name: store['name']?.toString() ?? item.name,
        subTitle: store['location_title']?.toString() ?? item.subTitle,
        imageUrl: images.isNotEmpty ? images.first : item.imageUrl,
        images: images.isNotEmpty ? images : item.images,
        address: store['location_title']?.toString() ?? item.address,
        rating: double.tryParse(store['rating']?.toString() ?? '') ?? item.rating,
        reviewsCount: item.reviewsCount,
        distance: item.distance,
        category: item.category,
        serviceType: item.serviceType.isNotEmpty ? item.serviceType : 'service',
        aboutText: store['description']?.toString() ?? item.aboutText,
        currency: item.currency.isNotEmpty ? item.currency : 'currency_qar'.tr,
        hours: store['is_open'] == true ? 'auto_key_280'.tr : 'auto_key_281'.tr,
        productsOrServices:
            subItems.isNotEmpty ? subItems : item.productsOrServices,
      );
      totalImages.value =
          _item.value!.images.isNotEmpty ? _item.value!.images.length : 1;
    } else if (subItems.isNotEmpty) {
      _item.value = BaseServiceItem(
        id: item.id,
        name: item.name,
        subTitle: item.subTitle,
        imageUrl: item.imageUrl,
        images: item.images,
        address: item.address,
        rating: item.rating,
        reviewsCount: item.reviewsCount,
        distance: item.distance,
        category: item.category,
        serviceType: item.serviceType,
        aboutText: item.aboutText,
        currency: item.currency,
        hours: item.hours,
        productsOrServices: subItems,
      );
    }
  }

  void _applyStoreMethods(Map store) {
    String enumValue(dynamic raw) {
      if (raw is Map) return raw['value']?.toString() ?? '';
      return raw?.toString() ?? '';
    }

    final dts = (store['delivery_types'] as List? ?? [])
        .map(enumValue)
        .where((e) => e.isNotEmpty)
        .toList();
    final pms = (store['payment_methods'] as List? ?? [])
        .map(enumValue)
        .where((e) => e.isNotEmpty)
        .toList();
    deliveryTypes.assignAll(dts);
    paymentMethods.assignAll(pms);
    if (dts.contains('at_provider')) {
      selectedDeliveryType = 'at_provider';
    } else if (dts.isNotEmpty) {
      selectedDeliveryType = dts.first;
    }
    if (pms.contains('wallet')) {
      selectedPaymentMethod = 'wallet';
    } else if (pms.contains('cash')) {
      selectedPaymentMethod = 'cash';
    } else if (pms.isNotEmpty) {
      selectedPaymentMethod = pms.first;
    }
  }

  Future<void> _fetchCommercialCenterDetail(int id) async {
    final res = await repository.getCommercialCenterDetail(id);
    final data = ApiResult.ensureSuccess(res);
    if (data is! Map) return;

    final center = data['commercial_center'];
    final sections = data['commercial_center_sections'] as List? ?? [];
    final highlights = sections
        .whereType<Map>()
        .map((s) => s['name']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

    // Official store list: GET /markets?commercial_center_id=
    final vendors = await _fetchMarketsByCommercialCenter(id);

    if (center is Map) {
      final image = center['image']?.toString() ?? item.imageUrl;
      _item.value = BaseServiceItem(
        id: item.id,
        name: center['name']?.toString() ?? item.name,
        subTitle: item.subTitle,
        imageUrl: image,
        images: image.isNotEmpty ? [image] : item.images,
        address: item.address,
        rating: item.rating,
        reviewsCount: item.reviewsCount,
        distance: item.distance,
        category: item.category,
        serviceType: item.serviceType,
        aboutText: item.aboutText,
        currency: item.currency,
        hours: item.hours,
        highlights: highlights.isNotEmpty ? highlights : item.highlights,
        productsOrServices: vendors.isNotEmpty ? vendors : item.productsOrServices,
      );
    }
  }

  Future<List<ServiceSubItem>> _fetchMarketsByCommercialCenter(int id) async {
    try {
      final res = await repository.getMarkets(
        lat: Get.find<GetStorageHelper>().getUserLatitude,
        lng: Get.find<GetStorageHelper>().getUserLongtude,
        commercialCenterId: id,
        radiusKm: 50000,
      );
      final data = ApiResult.ensureSuccess(res);
      if (data is! Map) return const [];
      final list = data['stores'] as List? ?? const [];
      return list.whereType<Map>().map((m) {
        final mt = m['market_type'];
        final typeValue = mt is Map
            ? mt['value']?.toString() ?? 'store'
            : mt?.toString() ?? 'store';
        return ServiceSubItem(
          id: m['id']?.toString() ?? '',
          name: m['name']?.toString() ?? '',
          // description holds market_type for navigation.
          description: typeValue.isNotEmpty ? typeValue : 'store',
          price: 0,
          imageUrl: m['main_image']?.toString() ?? m['image']?.toString() ?? '',
        );
      }).toList();
    } catch (e) {
      log('_fetchMarketsByCommercialCenter: $e');
      return const [];
    }
  }

  Future<void> toggleFavorite() async {
    if (_isCommercialCenter) return;
    final id = int.tryParse(item.id);
    if (id == null || id <= 0) return;
    try {
      final res = await repository.favMarket(id);
      ApiResult.ensureSuccess(res);
      isFavorite.value = !isFavorite.value;
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  /// Product select, or open vendor when browsing a commercial center.
  void onSubItemTap(String itemId, double price) {
    if (_isCommercialCenter) {
      final sub = item.productsOrServices
          ?.firstWhereOrNull((s) => s.id == itemId);
      if (sub == null || int.tryParse(sub.id) == null) return;
      MarketTypeRouter.open(
        sub.description,
        arguments: BaseServiceItem(
          id: sub.id,
          name: sub.name,
          subTitle: '',
          imageUrl: sub.imageUrl,
          address: '',
          rating: 0,
          reviewsCount: 0,
          distance: '',
          category: sub.description,
          serviceType: sub.description,
          aboutText: '',
        ),
      );
      return;
    }
    toggleItemSelection(itemId, price);
  }

  void nextImage() {
    if (currentImageIndex.value < totalImages.value) currentImageIndex.value++;
  }

  void previousImage() {
    if (currentImageIndex.value > 1) currentImageIndex.value--;
  }

  void toggleItemSelection(String itemId, double price) {
    if (selectedItems.containsKey(itemId)) {
      selectedItems.remove(itemId);
    } else {
      selectedItems[itemId] = 1;
    }
    _recalculateTotal(priceOverride: price);
  }

  void incrementQuantity(String itemId, double price) {
    selectedItems[itemId] = (selectedItems[itemId] ?? 0) + 1;
    _recalculateTotal(priceOverride: price);
  }

  void decrementQuantity(String itemId, double price) {
    if (selectedItems.containsKey(itemId)) {
      if (selectedItems[itemId]! > 1) {
        selectedItems[itemId] = selectedItems[itemId]! - 1;
      } else {
        selectedItems.remove(itemId);
      }
      _recalculateTotal(priceOverride: price);
    }
  }

  int getQuantity(String itemId) => selectedItems[itemId] ?? 0;

  final _selectedRx = <String, RxBool>{};

  RxBool isSelected(String itemId) {
    _selectedRx.putIfAbsent(
      itemId,
      () => RxBool(selectedItems.containsKey(itemId)),
    );
    return _selectedRx[itemId]!;
  }

  void _syncSelectionRx() {
    for (final key in _selectedRx.keys) {
      _selectedRx[key]?.value = selectedItems.containsKey(key);
    }
  }

  void _recalculateTotal({double? priceOverride}) {
    double total = 0;
    int count = 0;
    final allSubItems = <ServiceSubItem>[
      if (item.productsOrServices != null) ...item.productsOrServices!,
    ];

    for (final entry in selectedItems.entries) {
      final subItem = allSubItems.firstWhereOrNull((s) => s.id == entry.key);
      if (subItem != null) {
        total += subItem.price * entry.value;
        count += entry.value;
      } else {
        total += (priceOverride ?? 0) * entry.value;
        count += entry.value;
      }
    }

    totalPrice.value = total;
    selectedCount.value = count;
    _syncSelectionRx();
  }

  void clearSelections() {
    selectedItems.clear();
    totalPrice.value = 0;
    selectedCount.value = 0;
    _syncSelectionRx();
  }

  /// Creates order via `POST /orders/store` (ServiceOrderStrategy products path).
  Future<void> submitOrder() async {
    if (_isCommercialCenter) {
      AppSnackbar.showInfo(message: 'auto_key_298'.tr);
      return;
    }
    final marketId = int.tryParse(item.id);
    if (marketId == null || marketId <= 0) {
      AppSnackbar.showError(message: 'auto_key_299'.tr);
      return;
    }
    if (selectedItems.isEmpty) {
      AppSnackbar.showError(message: 'auto_key_300'.tr);
      return;
    }
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    isSubmitting.value = true;
    try {
      final products = selectedItems.entries
          .map(
            (e) => {
              'product_id': int.tryParse(e.key) ?? e.key,
              'quantity': e.value,
            },
          )
          .toList();
      final body = {
        'market_id': marketId,
        'date': DateTime.now().toIso8601String().split('T').first,
        'delivery_type': selectedDeliveryType,
        'payment_method': selectedPaymentMethod,
        'products': products,
      };
      final ok = await BookingOrderSubmit.storeAndSettle(
        repository: repository,
        body: body,
        successFallback: 'auto_key_146'.tr,
      );
      if (ok) clearSelections();
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
}
