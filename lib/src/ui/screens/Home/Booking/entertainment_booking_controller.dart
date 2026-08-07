import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/booking_checkout_options.dart';
import 'package:nisba_app/src/utils/booking_order_submit.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class EntertainmentBookingController extends GetxController {
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();

  // ── Venue info (parsed from navigation argument) ──
  final venueName = ''.obs;
  final venueRating = 0.0.obs;
  final venueReviews = 0.obs;
  final venueAddress = ''.obs;
  final venueImages = <String>[].obs;
  final venueFeatures = <ServiceFeature>[].obs;
  final currentImageIndex = 0.obs;

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final slots = <Map<String, dynamic>>[].obs;
  final selectedSlotId = RxnInt();
  final guests = 1.obs;
  final title = 'حجز تذاكر'.obs;

  final checkout = BookingCheckoutOptions().obs;
  final selectedPayment = 'wallet'.obs;
  final selectedDelivery = 'at_provider'.obs;

  late int marketId;

  /// السعر الإجمالي = سعر التذكرة × عدد التذاكر
  double? get totalPrice {
    final slot = selectedSlot;
    if (slot == null) return null;
    final p = double.tryParse(slot['price']?.toString() ?? '');
    if (p == null) return null;
    return p * guests.value;
  }

  /// الموعد المحدد حالياً
  Map<String, dynamic>? get selectedSlot {
    if (selectedSlotId.value == null) return null;
    return slots.firstWhereOrNull(
      (s) => int.tryParse(s['id']?.toString() ?? '') == selectedSlotId.value,
    );
  }

  @override
  void onInit() {
    super.onInit();
    marketId = _resolveMarketId();
    loadSlots();
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
      _parseVenueInfo(args);
      return int.tryParse(args.id) ?? 0;
    }
    if (args is Map) {
      title.value = args['name']?.toString() ?? title.value;
      venueName.value = title.value;
      return int.tryParse(
            args['market_id']?.toString() ?? args['id']?.toString() ?? '',
          ) ??
          0;
    }
    if (args is int) return args;
    return 0;
  }

  void _parseVenueInfo(BaseServiceItem item) {
    title.value = item.name;
    venueName.value = item.name;
    venueRating.value = item.rating;
    venueReviews.value = item.reviewsCount;
    venueAddress.value = item.address;
    venueImages.value = item.images.isNotEmpty ? item.images : [item.imageUrl];
    venueFeatures.value = item.features ?? [];
  }

  Future<void> loadSlots() async {
    if (marketId <= 0) {
      AppSnackbar.showError(message: 'معرّف السوق غير صالح');
      return;
    }
    isLoading.value = true;
    try {
      if (!await connectionChecker.hasConnection) {
        AppSnackbar.showError(message: 'check_connection'.tr);
        return;
      }
      final res = await repository.getBookingSlots(marketId);
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map ? data['slots'] as List? ?? [] : <dynamic>[];
      slots.assignAll(
        list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
      );
      if (slots.isNotEmpty) {
        selectedSlotId.value = int.tryParse(
          slots.first['id']?.toString() ?? '',
        );
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

  void selectSlot(int id) => selectedSlotId.value = id;

  void incrementGuests() => guests.value++;

  void decrementGuests() {
    if (guests.value > 1) guests.value--;
  }

  Future<void> submit() async {
    if (selectedSlotId.value == null) {
      AppSnackbar.showError(message: 'اختر موعداً أولاً');
      return;
    }
    isSubmitting.value = true;
    try {
      if (!await connectionChecker.hasConnection) {
        AppSnackbar.showError(message: 'check_connection'.tr);
        return;
      }
      final selected = slots.firstWhereOrNull(
        (s) => int.tryParse(s['id']?.toString() ?? '') == selectedSlotId.value,
      );
      final body = {
        'market_id': marketId,
        'date':
            selected?['date']?.toString() ??
            DateTime.now().toIso8601String().split('T').first,
        'delivery_type': selectedDelivery.value,
        'payment_method': selectedPayment.value,
        'booking': {
          if (selected?['booking_resource_id'] != null)
            'booking_resource_id': selected!['booking_resource_id'],
          'booking_slot_id': selectedSlotId.value,
          'guests': guests.value,
        },
      };
      await BookingOrderSubmit.storeAndSettle(
        repository: repository,
        body: body,
        successFallback: 'تم حجز التذاكر بنجاح',
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
}
