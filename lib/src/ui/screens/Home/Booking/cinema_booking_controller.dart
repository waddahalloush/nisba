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

class CinemaSeat {
  final String code;
  final String row;
  final int number;
  final String status; // available | taken

  const CinemaSeat({
    required this.code,
    required this.row,
    required this.number,
    required this.status,
  });

  bool get isTaken => status == 'taken';
  bool get isAvailable => status == 'available';

  factory CinemaSeat.fromMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return CinemaSeat(
      code: map['code']?.toString() ?? '',
      row: map['row']?.toString() ?? '',
      number: int.tryParse(map['number']?.toString() ?? '') ?? 0,
      status: map['status']?.toString() ?? 'available',
    );
  }
}

class CinemaBookingController extends GetxController {
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
  final resources = <Map<String, dynamic>>[].obs;
  final slots = <Map<String, dynamic>>[].obs;
  final seats = <CinemaSeat>[].obs;
  final selectedSeats = <String>[].obs;
  final selectedResourceId = RxnInt();
  final selectedSlotId = RxnInt();
  final seatsPerRow = 8.obs;
  final title = 'auto_key_190'.tr.obs;

  final checkout = BookingCheckoutOptions().obs;
  final selectedPayment = 'wallet'.obs;
  final selectedDelivery = 'at_provider'.obs;

  late int marketId;

  int get guests => selectedSeats.length;

  /// السعر الإجمالي = سعر التذكرة من الموعد × عدد المقاعد المختارة
  double? get totalPrice {
    final slot = selectedSlot;
    if (slot == null) return null;
    final p = double.tryParse(slot['price']?.toString() ?? '');
    if (p == null) return null;
    return p * guests;
  }

  /// الموعد المحدد حالياً
  Map<String, dynamic>? get selectedSlot {
    if (selectedSlotId.value == null) return null;
    return slots.firstWhereOrNull(
      (s) => int.tryParse(s['id']?.toString() ?? '') == selectedSlotId.value,
    );
  }

  /// القاعة المحددة حالياً
  Map<String, dynamic>? get selectedResource {
    if (selectedResourceId.value == null) return null;
    return resources.firstWhereOrNull(
      (r) =>
          int.tryParse(r['id']?.toString() ?? '') == selectedResourceId.value,
    );
  }

  @override
  void onInit() {
    super.onInit();
    marketId = _resolveMarketId();
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
        await loadSlots();
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

  Future<void> loadSlots() async {
    final resourceId = selectedResourceId.value;
    if (resourceId == null) return;
    try {
      final res = await repository.getBookingSlots(
        marketId,
        resourceId: resourceId,
      );
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map ? data['slots'] as List? ?? [] : <dynamic>[];
      slots.assignAll(
        list.whereType<Map>().map((e) => Map<String, dynamic>.from(e)),
      );
      if (slots.isNotEmpty) {
        selectSlot(int.tryParse(slots.first['id']?.toString() ?? '') ?? 0);
      } else {
        selectedSlotId.value = null;
        seats.clear();
        selectedSeats.clear();
      }
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    }
  }

  void selectResource(int id) {
    selectedResourceId.value = id;
    loadSlots();
  }

  void selectSlot(int id) {
    if (id <= 0) return;
    selectedSlotId.value = id;
    selectedSeats.clear();
    final selected = slots.firstWhereOrNull(
      (s) => int.tryParse(s['id']?.toString() ?? '') == id,
    );
    _applySeatMap(selected);
  }

  void _applySeatMap(Map? slot) {
    if (slot == null) {
      seats.clear();
      return;
    }
    final map = slot['seat_map'];
    if (map is! Map) {
      seats.clear();
      return;
    }
    seatsPerRow.value =
        int.tryParse(map['seats_per_row']?.toString() ?? '') ?? 8;
    final list = map['seats'] as List? ?? const [];
    seats.assignAll(
      list
          .whereType<Map>()
          .map(CinemaSeat.fromMap)
          .where((s) => s.code.isNotEmpty),
    );
  }

  void toggleSeat(String code) {
    final seat = seats.firstWhereOrNull((s) => s.code == code);
    if (seat == null || seat.isTaken) return;

    if (selectedSeats.contains(code)) {
      selectedSeats.remove(code);
      return;
    }
    if (selectedSeats.length >= 8) {
      AppSnackbar.showInfo(message: 'auto_key_192'.tr);
      return;
    }
    selectedSeats.add(code);
  }

  Future<void> submit() async {
    if (selectedSlotId.value == null) {
      AppSnackbar.showError(message: 'auto_key_193'.tr);
      return;
    }
    if (selectedSeats.isEmpty) {
      AppSnackbar.showError(message: 'auto_key_194'.tr);
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
          'booking_resource_id': selectedResourceId.value,
          'booking_slot_id': selectedSlotId.value,
          'guests': guests,
          'seats': List<String>.from(selectedSeats),
        },
      };
      await BookingOrderSubmit.storeAndSettle(
        repository: repository,
        body: body,
        successFallback: 'auto_key_195'.tr,
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
