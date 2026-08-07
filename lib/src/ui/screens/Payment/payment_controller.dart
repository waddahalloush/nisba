import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/local/cart_storage.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/ui/screens/Cart/cart_controller.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';
import 'package:nisba_app/src/utils/order_pricing.dart';
import 'package:nisba_app/src/utils/payment_flow_helper.dart';

import '../../../../generated/assets.gen.dart';

class PaymentMethod {
  final String icon;
  final String label;
  final String? subtitle;
  final String apiValue;

  const PaymentMethod({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.apiValue,
  });
}

class CheckoutAddress {
  final int id;
  final String title;
  final String details;

  const CheckoutAddress({
    required this.id,
    required this.title,
    required this.details,
  });

  String get display =>
      [title, details].where((e) => e.isNotEmpty).join(' — ');

  factory CheckoutAddress.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final details = [
      map['street']?.toString() ?? '',
      map['info']?.toString() ?? '',
      if ((map['building_number']?.toString() ?? '').isNotEmpty)
        'مبنى ${map['building_number']}',
      if ((map['apartment_number']?.toString() ?? '').isNotEmpty)
        'شقة ${map['apartment_number']}',
    ].where((e) => e.isNotEmpty).join('، ');
    return CheckoutAddress(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      title: map['name']?.toString() ?? '',
      details: details,
    );
  }
}

class CheckoutCar {
  final int id;
  final String label;

  const CheckoutCar({required this.id, required this.label});

  factory CheckoutCar.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    String nameOf(dynamic v) {
      if (v is Map) return v['name']?.toString() ?? '';
      return v?.toString() ?? '';
    }

    final brand = nameOf(map['carBrand'] ?? map['car_brand']);
    final color = nameOf(map['carColor'] ?? map['car_color']);
    final plate = map['plate_number']?.toString() ?? '';
    return CheckoutCar(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      label: [
        brand,
        color,
        plate,
      ].where((e) => e.isNotEmpty).join(' • '),
    );
  }
}

class PaymentController extends GetxController {
  Repository repository = Get.find();
  InternetConnectionChecker connectionChecker = Get.find();
  final CartStorage cartStorage = CartStorage();
  final GetStorageHelper storage = Get.find();

  final selectedPayment = 'بطاقة بنكية'.obs;
  final isPaying = false.obs;

  final restaurantName = ''.obs;
  final deliveryTime = ''.obs;
  final deliveryAddress = ''.obs;
  final selectedCarLabel = ''.obs;
  final deliveryType = 'to_home'.obs;

  final subtotal = 0.0.obs;
  final deliveryFee = 0.0.obs;
  final couponDiscount = 0.0.obs;
  final offerDiscount = 0.0.obs;
  final customerDiscount = 0.0.obs;
  final earnedPoints = 0.0.obs;
  final grandTotal = 0.0.obs;
  final availablePoints = 0.0.obs;
  final conversionRate = 1.0.obs;

  final addresses = <CheckoutAddress>[].obs;
  final cars = <CheckoutCar>[].obs;
  final selectedAddressId = RxnInt();
  final selectedCarId = RxnInt();

  int? marketId;
  int? visaId;

  /// Set when arriving from the QR scanner with an already-created order.
  int? scannedOrderId;

  bool get needsAddress => deliveryType.value == 'to_home';

  bool get needsCar =>
      deliveryType.value == 'to_car' || deliveryType.value == 'throw_in';

  String get deliveryTypeLabel =>
      CartController.deliveryTypeMeta[deliveryType.value] ??
      deliveryType.value;

  double get pointsRequiredToPay => OrderPricing.pointsRequiredToPay(
        grandTotal: grandTotal.value,
        conversionRatePointMoney: conversionRate.value,
      );

  double get total => grandTotal.value;

  final paymentMethods = <PaymentMethod>[
    PaymentMethod(
      icon: Assets.images.payVisa.path,
      label: 'بطاقة بنكية',
      subtitle: 'Visa, Mastercard — SkipCash',
      apiValue: 'card',
    ),
    PaymentMethod(
      icon: Assets.images.payGoogle.path,
      label: 'المحفظة الإلكترونية',
      subtitle: 'محفظة نسبة',
      apiValue: 'wallet',
    ),
    PaymentMethod(
      icon: Assets.images.paypal.path,
      label: 'الدفع بالنقاط',
      subtitle: 'خصم كامل الفاتورة بالنقاط',
      apiValue: 'point',
    ),
    PaymentMethod(
      icon: Assets.images.payOnDeliver.path,
      label: 'الدفع عند الاستلام',
      apiValue: 'cash',
    ),
  ];

  void selectPayment(String method) => selectedPayment.value = method;

  String get _selectedApiPayment {
    final match = paymentMethods.firstWhereOrNull(
      (m) => m.label == selectedPayment.value,
    );
    return match?.apiValue ?? 'wallet';
  }

  void selectAddress(CheckoutAddress address) {
    selectedAddressId.value = address.id;
    deliveryAddress.value = address.display;
  }

  void selectCar(CheckoutCar car) {
    selectedCarId.value = car.id;
    selectedCarLabel.value = car.label;
  }

  Future<void> payNow() async {
    isPaying.value = true;
    try {
      if (!await connectionChecker.hasConnection) {
        AppSnackbar.showError(message: 'check_connection'.tr);
        return;
      }

      if (_selectedApiPayment == 'point' &&
          availablePoints.value < pointsRequiredToPay) {
        AppSnackbar.showError(message: 'ليس لديك نقاط كافية لدفع الفاتورة');
        return;
      }

      if (scannedOrderId == null) {
        if (needsAddress && selectedAddressId.value == null) {
          AppSnackbar.showError(message: 'يرجى اختيار عنوان التوصيل');
          return;
        }
        if (needsCar && selectedCarId.value == null) {
          AppSnackbar.showError(message: 'يرجى اختيار السيارة');
          return;
        }
      }

      // QR-scanned order: pay directly, skip storeOrder.
      if (scannedOrderId != null) {
        final payRes = await repository.payOrder(
          scannedOrderId!,
          data: {
            'payment_method': _selectedApiPayment,
            if (visaId != null) 'visa_id': visaId,
          },
        );
        final payData = ApiResult.ensureSuccess(payRes);
        final gateway = await PaymentFlowHelper.openIfNeeded(
          data: payData,
          purpose: PaymentWebViewPurpose.order,
          orderId: scannedOrderId,
        );
        if (gateway == PaymentGatewayResult.paid) {
          Get.offNamedUntil(AppRoutesNames.dashboard, (route) => false);
          return;
        }
        if (gateway == PaymentGatewayResult.dismissed) {
          AppSnackbar.showInfo(message: 'الدفع لم يكتمل بعد');
          return;
        }
        if (gateway == PaymentGatewayResult.unavailable) {
          AppSnackbar.showError(message: 'تعذر فتح صفحة الدفع');
          return;
        }

        AppSnackbar.showSuccess(
          message: ApiResult.message(payRes).isNotEmpty
              ? ApiResult.message(payRes)
              : 'تم الدفع بنجاح',
        );
        Get.offNamedUntil(AppRoutesNames.dashboard, (route) => false);
        return;
      }

      if (Get.isRegistered<CartController>()) {
        final cart = Get.find<CartController>();
        final mid = cart.primaryMarketId;
        final products = cart.cartStorage.buildOrderProducts(marketId: mid);
        if (mid != null && products.isNotEmpty) {
          await cart.placeOrder(
            paymentMethod: _selectedApiPayment,
            addressId: needsAddress ? selectedAddressId.value : null,
            userCarId: needsCar ? selectedCarId.value : null,
            visaId: visaId,
          );
          return;
        }
      }

      final mid = marketId ??
          (Get.arguments is Map
              ? int.tryParse(
                  (Get.arguments as Map)['market_id']?.toString() ?? '',
                )
              : null);
      final products = cartStorage.buildOrderProducts(marketId: mid);
      if (mid == null || products.isEmpty) {
        AppSnackbar.showInfo(message: 'السلة فارغة');
        return;
      }

      final body = {
        'market_id': mid,
        'date': DateTime.now().toIso8601String().split('T').first,
        'delivery_type': deliveryType.value,
        'payment_method': _selectedApiPayment,
        if (needsAddress && selectedAddressId.value != null)
          'address_id': selectedAddressId.value,
        if (needsCar && selectedCarId.value != null)
          'user_car_id': selectedCarId.value,
        if (visaId != null) 'visa_id': visaId,
        'products': products,
      };
      final res = await repository.storeOrder(body: body);
      final data = ApiResult.ensureSuccess(res);
      _applyOrderTotalsFromResponse(data);

      final gateway = await PaymentFlowHelper.openIfNeeded(
        data: data,
        purpose: PaymentWebViewPurpose.order,
      );
      if (gateway != PaymentGatewayResult.notNeeded) {
        await cartStorage.clear();
        if (gateway == PaymentGatewayResult.paid) {
          Get.offNamedUntil(AppRoutesNames.dashboard, (route) => false);
          return;
        }
        if (gateway == PaymentGatewayResult.unavailable) {
          AppSnackbar.showError(message: 'تعذر فتح صفحة الدفع');
          return;
        }
        AppSnackbar.showInfo(message: 'الطلب أُنشئ وبانتظار إتمام الدفع');
        Get.offNamedUntil(AppRoutesNames.dashboard, (route) => false);
        return;
      }

      await cartStorage.clear();
      AppSnackbar.showSuccess(
        message: ApiResult.message(res).isNotEmpty
            ? ApiResult.message(res)
            : 'تم الدفع بنجاح',
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
      isPaying.value = false;
    }
  }

  void _applyOrderTotalsFromResponse(dynamic data) {
    if (data is! Map) return;
    final order = data['order'];
    if (order is! Map) return;
    final gt = double.tryParse(order['grand_total']?.toString() ?? '');
    final st = double.tryParse(order['subtotal']?.toString() ?? '');
    final dp = double.tryParse(order['delivery_price']?.toString() ?? '');
    final cd = double.tryParse(order['customer_discount']?.toString() ?? '');
    final cv = double.tryParse(order['coupon_value']?.toString() ?? '');
    final od = double.tryParse(order['discount']?.toString() ?? '');
    final pc = double.tryParse(order['points_customer']?.toString() ?? '');
    if (gt != null) grandTotal.value = gt;
    if (st != null) subtotal.value = st;
    if (dp != null) deliveryFee.value = dp;
    if (cd != null) customerDiscount.value = cd;
    if (cv != null) couponDiscount.value = cv;
    if (od != null) offerDiscount.value = od;
    if (pc != null) earnedPoints.value = pc;
  }

  @override
  void onInit() {
    super.onInit();
    conversionRate.value = double.tryParse(
          storage.getUser?.country.conversionRatePointMoney ?? '',
        ) ??
        1;
    if (conversionRate.value <= 0) conversionRate.value = 1;

    final args = Get.arguments;
    if (args is Map) {
      marketId = int.tryParse(args['market_id']?.toString() ?? '');
      deliveryType.value = args['delivery_type']?.toString() ?? 'to_home';
      final preAddress = int.tryParse(args['address_id']?.toString() ?? '');
      if (preAddress != null) selectedAddressId.value = preAddress;

      scannedOrderId = int.tryParse(
        args['order_id']?.toString() ?? args['pending_order_id']?.toString() ?? '',
      );

      final order = args['order'];
      if (order is Map) {
        scannedOrderId ??= int.tryParse(order['id']?.toString() ?? '');
        _applyOrderTotalsFromResponse({'order': order});
        final dt = order['delivery_type'];
        if (dt is Map && dt['value'] != null) {
          deliveryType.value = dt['value'].toString();
        }
        final market = order['market'];
        if (market is Map) {
          restaurantName.value =
              market['name']?.toString() ?? restaurantName.value;
        }
        final address = order['address'];
        if (address is Map) {
          final a = CheckoutAddress.fromApiMap(address);
          if (a.id > 0) selectAddress(a);
        }
      }
    }

    if (scannedOrderId == null && Get.isRegistered<CartController>()) {
      final cart = Get.find<CartController>();
      _syncFromCart(cart);
      _loadOrderInfo(cart.orderInfo.value);
      if (cart.orderInfo.value == null) {
        _fetchOrderInfo();
      }
    } else {
      _fetchOrderInfo();
      if (scannedOrderId != null &&
          (args is! Map || args['order'] is! Map)) {
        _hydratePendingOrder(scannedOrderId!);
      }
    }
  }

  Future<void> _hydratePendingOrder(int id) async {
    try {
      final res = await repository.getDetailedOrder(id: id);
      if (!res.isSuccess || res.data == null) return;
      final order = res.data!.order;
      _applyOrderTotalsFromResponse({'order': order.toPaymentArgsMap()});
      restaurantName.value = order.market.name;
      if (order.deliveryType.value.isNotEmpty) {
        deliveryType.value = order.deliveryType.value;
      }
      if (order.address is Map) {
        final a = CheckoutAddress.fromApiMap(order.address as Map);
        if (a.id > 0) selectAddress(a);
      }
    } catch (e) {
      log('hydrate pending order failed: $e');
    }
  }

  void _syncFromCart(CartController cart) {
    final p = cart.pricing;
    subtotal.value = p.subtotal;
    deliveryFee.value = p.deliveryPrice;
    couponDiscount.value = p.couponValue;
    offerDiscount.value = p.offerDiscount;
    customerDiscount.value = p.customerDiscount;
    earnedPoints.value = p.pointsCustomer;
    grandTotal.value = p.grandTotal;
    deliveryType.value = cart.deliveryType.value;
    marketId ??= cart.primaryMarketId;
  }

  void _loadOrderInfo(Map<String, dynamic>? info) {
    if (info == null) return;
    final client = info['client'];
    if (client is Map) {
      availablePoints.value =
          double.tryParse(client['points']?.toString() ?? '') ?? 0;
    }

    final addressList = info['addresses'];
    if (addressList is List) {
      addresses.assignAll(
        addressList
            .whereType<Map>()
            .map(CheckoutAddress.fromApiMap)
            .where((a) => a.id > 0)
            .toList(),
      );
      if (needsAddress &&
          selectedAddressId.value == null &&
          addresses.isNotEmpty) {
        selectAddress(addresses.first);
      } else if (selectedAddressId.value != null) {
        final match = addresses.firstWhereOrNull(
          (a) => a.id == selectedAddressId.value,
        );
        if (match != null) deliveryAddress.value = match.display;
      }
    }

    final carList = info['user_cars'];
    if (carList is List) {
      cars.assignAll(
        carList
            .whereType<Map>()
            .map(CheckoutCar.fromApiMap)
            .where((c) => c.id > 0)
            .toList(),
      );
      if (needsCar && selectedCarId.value == null && cars.isNotEmpty) {
        selectCar(cars.first);
      }
    }
  }

  Future<void> _fetchOrderInfo() async {
    try {
      final res = await repository.getOrderInfo();
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        _loadOrderInfo(Map<String, dynamic>.from(data));
      }
    } catch (e) {
      log('fetchOrderInfo: $e');
    }
  }
}
