import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/local/cart_storage.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';
import 'package:nisba_app/src/utils/order_pricing.dart';
import 'package:nisba_app/src/utils/payment_flow_helper.dart';

enum DeliveryMethod { orderNow, orderLater }

class CartItem {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String? note;
  final int? productId;
  final int? marketId;

  const CartItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.note,
    this.productId,
    this.marketId,
  });
}

class CartController extends GetxController {
  final couponController = TextEditingController();
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  final CartStorage cartStorage = CartStorage();
  final GetStorageHelper storage = Get.find();

  final items = <CartItem>[];
  final isSubmitting = false.obs;
  final isPricingLoading = false.obs;

  final deliveryMethod = DeliveryMethod.orderNow.obs;
  /// Backend delivery_type value used for pricing + storeOrder.
  final deliveryType = 'to_home'.obs;

  final selectedDate = DateTime.now().obs;
  final selectedTimeSlot = ''.obs;
  final currentCalendarMonth = DateTime.now().obs;

  final marketRates = MarketPricingRates().obs;
  final couponValue = 0.0.obs;
  final offerDiscount = 0.0.obs;
  final isApplyingCoupon = false.obs;
  final appliedCouponCode = ''.obs;
  final appliedCouponName = ''.obs;
  /// Backend discount_type value: percent | fixed
  String? appliedDiscountType;
  double appliedDiscountAmount = 0;
  int? appliedCouponId;

  /// Backend delivery_type keys supported by the current market.
  final availableDeliveryTypes = <String>[].obs;

  static const deliveryTypeMeta = <String, String>{
    'to_home': 'توصيل للمنزل',
    'at_provider': 'عند المزود',
    'book_table': 'حجز طاولة',
    'to_car': 'إلى السيارة',
    'throw_in': 'تناول في المكان',
  };

  static const _defaultDeliveryOrder = [
    'to_home',
    'at_provider',
    'to_car',
    'throw_in',
    'book_table',
  ];

  String deliveryTypeLabel(String key) =>
      deliveryTypeMeta[key] ?? key;

  bool get needsAddress => deliveryType.value == 'to_home';

  bool get needsCar =>
      deliveryType.value == 'to_car' || deliveryType.value == 'throw_in';

  final List<String> timeSlots = const [
    '7:00 AM - 9:00 AM',
    '9:00 AM - 11:00 AM',
    '11:00 AM - 1:00 PM',
    '1:00 PM - 3:00 PM',
    '3:00 PM - 5:00 PM',
    '5:00 PM - 7:00 PM',
    '7:00 PM - 9:00 PM',
  ];

  final Rxn<Map<String, dynamic>> orderInfo = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    reloadFromStorage();
  }

  double get _conversionRate {
    final rate = double.tryParse(
          storage.getUser?.country.conversionRatePointMoney ?? '',
        ) ??
        1;
    return rate > 0 ? rate : 1;
  }

  OrderPricingBreakdown get pricing => OrderPricing.estimate(
        subtotal: itemsSubtotal,
        rates: marketRates.value,
        deliveryType: deliveryType.value,
        couponValue: couponValue.value,
        offerDiscount: offerDiscount.value,
      );

  double get itemsSubtotal =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  double get subtotal => pricing.subtotal;
  double get deliveryFee => pricing.deliveryPrice;
  double get customerDiscount => pricing.customerDiscount;
  double get earnedPoints => pricing.pointsCustomer;
  double get total => pricing.grandTotal;

  /// Preloads addresses/cars for the payment screen.
  Future<void> fetchOrderInfo() async {
    try {
      final res = await repository.getOrderInfo();
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        orderInfo.value = Map<String, dynamic>.from(data);
      }
    } catch (e) {
      log('fetchOrderInfo: $e');
    }
  }

  Future<void> fetchMarketPricing() async {
    final mid = primaryMarketId;
    if (mid == null) return;
    isPricingLoading.value = true;
    try {
      final res = await repository.getMarketDetails(mid);
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        final store = data['store'];
        if (store is Map) {
          marketRates.value = MarketPricingRates.fromMarketMap(
            store,
            conversionRatePointMoney: _conversionRate,
          );
          _applyMarketDeliveryTypes(store);
        }
      }
    } catch (e) {
      log('fetchMarketPricing: $e');
    } finally {
      isPricingLoading.value = false;
      update();
    }
  }

  void _applyMarketDeliveryTypes(Map store) {
    final raw = store['delivery_types'];
    final parsed = <String>[];
    if (raw is List) {
      for (final e in raw) {
        final v = e.toString();
        if (v.isNotEmpty) parsed.add(v);
      }
    }

    List<String> keys;
    if (parsed.contains('all') || parsed.isEmpty) {
      keys = List<String>.from(_defaultDeliveryOrder);
    } else {
      keys = _defaultDeliveryOrder.where(parsed.contains).toList();
      for (final p in parsed) {
        if (!_defaultDeliveryOrder.contains(p) && p != 'all') {
          keys.add(p);
        }
      }
    }
    availableDeliveryTypes.assignAll(keys);

    if (keys.isNotEmpty && !keys.contains(deliveryType.value)) {
      deliveryType.value = keys.first;
    }
  }

  void setDeliveryType(String type) {
    if (availableDeliveryTypes.isNotEmpty &&
        !availableDeliveryTypes.contains(type)) {
      return;
    }
    deliveryType.value = type;
    update();
  }

  void reloadFromStorage() {
    final stored = cartStorage.getItems();
    items
      ..clear()
      ..addAll(
        stored.map(
          (e) => CartItem(
            name: (e.values['name'] as String?) ?? '',
            imageUrl: (e.values['image'] as String?) ?? '',
            price: double.tryParse((e.values['price'] as String?) ?? '') ?? 0,
            quantity: e.qty,
            productId: e.productId,
            marketId: e.marketId,
          ),
        ),
      );
    update();
    fetchMarketPricing();
  }

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  int? get primaryMarketId {
    for (final item in items) {
      if (item.marketId != null) return item.marketId;
    }
    final stored = cartStorage.getItems();
    if (stored.isNotEmpty) return stored.first.marketId;
    final args = Get.arguments;
    if (args is Map) {
      return int.tryParse(args['market_id']?.toString() ?? '');
    }
    return null;
  }

  void incrementQuantity(int index) {
    items[index] = CartItem(
      name: items[index].name,
      imageUrl: items[index].imageUrl,
      price: items[index].price,
      quantity: items[index].quantity + 1,
      note: items[index].note,
      productId: items[index].productId,
      marketId: items[index].marketId,
    );
    _syncQty(items[index]);
    _recalculateCouponValue();
    update();
  }

  void decrementQuantity(int index) {
    if (items[index].quantity > 1) {
      items[index] = CartItem(
        name: items[index].name,
        imageUrl: items[index].imageUrl,
        price: items[index].price,
        quantity: items[index].quantity - 1,
        note: items[index].note,
        productId: items[index].productId,
        marketId: items[index].marketId,
      );
      _syncQty(items[index]);
      _recalculateCouponValue();
      update();
    }
  }

  Future<void> _syncQty(CartItem item) async {
    if (item.productId == null || item.marketId == null) return;
    await cartStorage.updateQty(
      marketId: item.marketId!,
      productId: item.productId!,
      qty: item.quantity,
    );
  }

  void removeItem(int index) {
    final item = items[index];
    if (item.productId != null && item.marketId != null) {
      cartStorage.removeItem(
        marketId: item.marketId!,
        productId: item.productId!,
      );
    }
    items.removeAt(index);
    update();
  }

  void selectDeliveryMethod(DeliveryMethod method) =>
      deliveryMethod.value = method;

  void selectScheduledDate(DateTime date) => selectedDate.value = date;

  void selectTimeSlot(String slot) => selectedTimeSlot.value = slot;

  void goToPreviousMonth() {
    currentCalendarMonth.value = DateTime(
      currentCalendarMonth.value.year,
      currentCalendarMonth.value.month - 1,
      1,
    );
  }

  void goToNextMonth() {
    currentCalendarMonth.value = DateTime(
      currentCalendarMonth.value.year,
      currentCalendarMonth.value.month + 1,
      1,
    );
  }

  String get scheduledSlotLabel => selectedTimeSlot.value.isNotEmpty
      ? selectedTimeSlot.value
      : 'لم يتم تحديد موعد';

  void _recalculateCouponValue() {
    if (appliedCouponId == null || appliedDiscountType == null) {
      couponValue.value = 0;
      return;
    }
    final sub = itemsSubtotal;
    double value;
    if (appliedDiscountType == 'percent') {
      value = (sub * appliedDiscountAmount) / 100;
    } else {
      value = appliedDiscountAmount;
    }
    if (value > sub) value = sub;
    if (value < 0) value = 0;
    couponValue.value = value;
  }

  Future<void> applyCouponCode() async {
    final code = couponController.text.trim();
    if (code.isEmpty) {
      AppSnackbar.showError(message: 'يرجى إدخال رمز القسيمة');
      return;
    }
    final mid = primaryMarketId;
    if (mid == null) {
      AppSnackbar.showError(message: 'معرّف المتجر غير متوفر');
      return;
    }
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }

    isApplyingCoupon.value = true;
    try {
      final res = await repository.checkCoupon(
        data: {
          'code': code,
          'market_id': mid,
        },
      );
      final data = ApiResult.ensureSuccess(res);
      if (data is! Map) {
        AppSnackbar.showError(message: 'استجابة القسيمة غير صالحة');
        return;
      }

      final id = int.tryParse(data['id']?.toString() ?? '');
      if (id == null) {
        AppSnackbar.showError(message: 'القسيمة بدون معرف');
        return;
      }

      final typeRaw = data['discount_type'];
      final type = typeRaw is Map
          ? typeRaw['value']?.toString() ?? ''
          : typeRaw?.toString() ?? '';
      final discount =
          double.tryParse(data['discount']?.toString() ?? '') ?? 0;

      appliedCouponId = id;
      appliedDiscountType = type;
      appliedDiscountAmount = discount;
      appliedCouponCode.value = data['code']?.toString() ?? code;
      appliedCouponName.value = data['name']?.toString() ?? '';
      _recalculateCouponValue();
      update();

      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'تم تفعيل القسيمة بنجاح',
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isApplyingCoupon.value = false;
    }
  }

  void clearCoupon() {
    appliedCouponId = null;
    appliedDiscountType = null;
    appliedDiscountAmount = 0;
    appliedCouponCode.value = '';
    appliedCouponName.value = '';
    couponValue.value = 0;
    couponController.clear();
    update();
  }

  Future<void> checkout() async {
    await fetchOrderInfo();
    Get.toNamed(
      AppRoutesNames.payment,
      arguments: {
        'market_id': primaryMarketId,
        'delivery_type': deliveryType.value,
      },
    );
  }

  Future<void> placeOrder({
    required String paymentMethod,
    int? addressId,
    int? userCarId,
    int? visaId,
  }) async {
    final marketId = primaryMarketId;
    final products = cartStorage.buildOrderProducts(marketId: marketId);
    if (marketId == null || products.isEmpty) {
      AppSnackbar.showError(message: 'السلة فارغة أو معرّف المتجر غير متوفر');
      return;
    }
    if (deliveryType.value == 'to_home' && addressId == null) {
      AppSnackbar.showError(message: 'يرجى اختيار عنوان التوصيل');
      return;
    }
    if ((deliveryType.value == 'to_car' ||
            deliveryType.value == 'throw_in') &&
        userCarId == null) {
      AppSnackbar.showError(message: 'يرجى اختيار السيارة');
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
        'date': DateTime.now().toIso8601String().split('T').first,
        'delivery_type': deliveryType.value,
        'payment_method': paymentMethod,
        if (addressId != null) 'address_id': addressId,
        if (userCarId != null) 'user_car_id': userCarId,
        if (visaId != null) 'visa_id': visaId,
        if (appliedCouponId != null) 'coupon_id': appliedCouponId,
        'products': products,
      };
      final res = await repository.storeOrder(body: body);
      final data = ApiResult.ensureSuccess(res);

      final gateway = await PaymentFlowHelper.openIfNeeded(
        data: data,
        purpose: PaymentWebViewPurpose.order,
      );

      if (gateway != PaymentGatewayResult.notNeeded) {
        await cartStorage.clear();
        items.clear();
        update();
        if (gateway == PaymentGatewayResult.paid) {
          Get.offNamedUntil(AppRoutesNames.dashboard, (route) => false);
          return;
        }
        if (gateway == PaymentGatewayResult.unavailable) {
          AppSnackbar.showError(message: 'تعذر فتح صفحة الدفع');
          return;
        }
        AppSnackbar.showInfo(
          message: 'الطلب أُنشئ وبانتظار إتمام الدفع',
        );
        Get.offNamedUntil(AppRoutesNames.dashboard, (route) => false);
        return;
      }

      await cartStorage.clear();
      items.clear();
      update();
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'تم إنشاء الطلب بنجاح',
      );
      Get.offNamedUntil(AppRoutesNames.dashboard, (route) => false);
    } on DioException catch (e) {
      log(e.toString());
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
    couponController.dispose();
    super.onClose();
  }
}
