import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/booking_checkout_options.dart';
import 'package:nisba_app/src/utils/booking_order_submit.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class HotelBookingController extends GetxController {
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  // ── Hotel info (parsed from navigation argument) ──
  final hotelName = ''.obs;
  final hotelRating = 0.0.obs;
  final hotelReviews = 0.obs;
  final hotelAddress = ''.obs;
  final hotelImages = <String>[].obs;
  final hotelFeatures = <ServiceFeature>[].obs;
  final currentImageIndex = 0.obs;

  // ── Booking state ──
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final isChecking = false.obs;
  final resources = <Map<String, dynamic>>[].obs;
  final selectedResourceId = RxnInt();
  final guests = 2.obs;
  final available = RxnBool();
  final price = RxnDouble();
  final title = 'auto_key_224'.tr.obs;

  final checkout = BookingCheckoutOptions().obs;
  final selectedPayment = 'wallet'.obs;
  final selectedDelivery = 'at_provider'.obs;

  final dateFromController = TextEditingController();
  final dateToController = TextEditingController();

  // Reactive mirrors so Obx can track date changes
  final dateFrom = ''.obs;
  final dateTo = ''.obs;

  // ── Promo ──
  final promoCodeController = TextEditingController();
  final showPromoInput = false.obs;

  // Internal trigger for debounced auto-check
  final _checkTrigger = 0.obs;
  Worker? _autoCheckWorker;

  late int marketId;

  /// عدد الليالي المحسوب من التواريخ (reactive via RxString mirrors)
  int get nightCount {
    try {
      final from = DateTime.parse(dateFrom.value.trim());
      final to = DateTime.parse(dateTo.value.trim());
      final diff = to.difference(from).inDays;
      return diff > 0 ? diff : 1;
    } catch (_) {
      return 1;
    }
  }

  /// السعر الإجمالي = سعر الليلة × عدد الليالي
  double? get totalPrice {
    final p = price.value;
    if (p == null) return null;
    return p * nightCount;
  }

  @override
  void onInit() {
    super.onInit();
    marketId = _resolveMarketId();
    final now = DateTime.now();
    final fromDate = now
        .add(const Duration(days: 1))
        .toIso8601String()
        .split('T')
        .first;
    final toDate = now
        .add(const Duration(days: 2))
        .toIso8601String()
        .split('T')
        .first;
    dateFromController.text = fromDate;
    dateToController.text = toDate;
    dateFrom.value = fromDate;
    dateTo.value = toDate;

    // Debounced auto-check: fires 600ms after last trigger change
    _autoCheckWorker = debounce(
      _checkTrigger,
      (_) => _performAutoCheck(),
      time: const Duration(milliseconds: 600),
    );

    loadResources();
    _loadCheckoutOptions();
  }

  Future<void> _loadCheckoutOptions() async {
    final opts = BookingCheckoutOptions();
    await opts.loadFromMarket(repository, marketId);
    checkout.value = opts;
    selectedPayment.value = opts.paymentMethod;
    selectedDelivery.value = opts.deliveryType;
  }

  int _resolveMarketId() {
    final args = Get.arguments;
    if (args is BaseServiceItem) {
      _parseHotelInfo(args);
      return int.tryParse(args.id) ?? 0;
    }
    if (args is Map) {
      title.value = args['name']?.toString() ?? title.value;
      hotelName.value = title.value;
      return int.tryParse(
            args['market_id']?.toString() ?? args['id']?.toString() ?? '',
          ) ??
          0;
    }
    if (args is int) return args;
    return 0;
  }

  void _parseHotelInfo(BaseServiceItem item) {
    title.value = item.name;
    hotelName.value = item.name;
    hotelRating.value = item.rating;
    hotelReviews.value = item.reviewsCount;
    hotelAddress.value = item.address;
    hotelImages.value = item.images.isNotEmpty ? item.images : [item.imageUrl];
    hotelFeatures.value = item.features ?? [];
  }

  Future<void> loadResources() async {
    if (marketId <= 0) {
      AppSnackbar.showError(message: 'auto_key_191'.tr);
      return;
    }
    isLoading.value = true;
    try {
      if (!await connectionChecker.hasConnection) {
        AppSnackbar.showError(message: 'check_connection'.tr);
        return;
      }
      final res = await repository.getBookingResources(marketId);
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map ? data['resources'] as List? ?? [] : <dynamic>[];
      resources.assignAll(
        list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
      );
      if (resources.isNotEmpty) {
        selectedResourceId.value = int.tryParse(
          resources.first['id']?.toString() ?? '',
        );
        _scheduleAutoCheck(); // trigger initial auto-check after resources load
      }
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void selectResource(int id) {
    selectedResourceId.value = id;
    available.value = null;
    price.value = null;
    _scheduleAutoCheck();
  }

  void incrementGuests() {
    guests.value++;
    _scheduleAutoCheck();
  }

  void decrementGuests() {
    if (guests.value > 1) guests.value--;
    _scheduleAutoCheck();
  }

  /// Call this from the UI whenever dates change (already synced via Rx mirrors).
  void onDatesChanged() => _scheduleAutoCheck();

  /// Schedules a debounced availability check.
  void _scheduleAutoCheck() {
    _checkTrigger.value++;
  }

  /// Performs the actual auto-check silently (no error snackbars).
  Future<void> _performAutoCheck() async {
    final resourceId = selectedResourceId.value;
    if (resourceId == null) return;
    final from = dateFrom.value.trim();
    final to = dateTo.value.trim();
    if (from.isEmpty || to.isEmpty) return;

    isChecking.value = true;
    try {
      if (!await connectionChecker.hasConnection) return;
      final res = await repository.checkHotelAvailability(
        marketId,
        params: {
          'booking_resource_id': resourceId,
          'date_from': from,
          'date_to': to,
          'guests': guests.value,
        },
      );
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        available.value = data['available'] == true;
        price.value =
            double.tryParse(data['price']?.toString() ?? '') ??
            double.tryParse(data['base_price']?.toString() ?? '');
      }
    } on DioException catch (_) {
      // Silently ignore auto-check errors
    } on ApiException catch (_) {
      // Silently ignore
    } catch (e) {
      log(e.toString());
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> checkAvailability() async {
    final resourceId = selectedResourceId.value;
    if (resourceId == null) {
      AppSnackbar.showError(message: 'auto_key_225'.tr);
      return;
    }
    isChecking.value = true;
    try {
      final res = await repository.checkHotelAvailability(
        marketId,
        params: {
          'booking_resource_id': resourceId,
          'date_from': dateFromController.text.trim(),
          'date_to': dateToController.text.trim(),
          'guests': guests.value,
        },
      );
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        available.value = data['available'] == true;
        price.value =
            double.tryParse(data['price']?.toString() ?? '') ??
            double.tryParse(data['base_price']?.toString() ?? '');
      }
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } finally {
      isChecking.value = false;
    }
  }

  Future<void> submit() async {
    if (selectedResourceId.value == null) {
      AppSnackbar.showError(message: 'auto_key_225'.tr);
      return;
    }
    if (available.value != true) {
      AppSnackbar.showError(message: 'auto_key_226'.tr);
      return;
    }
    isSubmitting.value = true;
    try {
      if (!await connectionChecker.hasConnection) {
        AppSnackbar.showError(message: 'check_connection'.tr);
        return;
      }
      final body = {
        'market_id': marketId,
        'date': dateFromController.text.trim(),
        'delivery_type': selectedDelivery.value,
        'payment_method': selectedPayment.value,
        'booking': {
          'booking_resource_id': selectedResourceId.value,
          'date_from': dateFromController.text.trim(),
          'date_to': dateToController.text.trim(),
          'guests': guests.value,
        },
      };
      await BookingOrderSubmit.storeAndSettle(
        repository: repository,
        body: body,
        successFallback: 'auto_key_227'.tr,
      );
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    _autoCheckWorker?.dispose();
    dateFromController.dispose();
    dateToController.dispose();
    promoCodeController.dispose();
    super.onClose();
  }
}
