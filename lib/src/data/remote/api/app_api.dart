import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../../../utils/api_result.dart';
import '../../models/Auth/profile_model.dart';
import '../../models/Auth/user_model.dart';
import '../../models/Home/home_model.dart';
import '../../models/Home/notification_model.dart';
import '../../models/Home/order_details_model.dart';
import '../../models/Home/order_model.dart';
import '../../models/product_details_model.dart';
import '../../models/section_details_model.dart';
import '../constants/endpoints.dart';
import 'dio_client.dart';

class AppApi {
  // ignore: unused_field
  final DioClient _dioClient = Get.find();

  Map<String, dynamic> _cleanQuery(Map<String, dynamic> params) {
    params.removeWhere((_, v) => v == null || v == '');
    // Expand list params for Laravel (types[0], types[1], ...)
    final expanded = <String, dynamic>{};
    params.forEach((key, value) {
      if (value is List) {
        for (var i = 0; i < value.length; i++) {
          expanded['$key[$i]'] = value[i];
        }
      } else {
        expanded[key] = value;
      }
    });
    return expanded;
  }

  // ====== Auth ======

  Future<String> sendVerificationCode({required var data}) async {
    final res = await _dioClient.post(EndPoints.sendCode, data: data);
    return res['status'];
  }

  Future<AuthResponse> checkVerificationCode({required var data}) async {
    final res = await _dioClient.post(
      EndPoints.checkVerificationCode,
      data: data,
    );
    return AuthResponse.fromJson(res);
  }

  Future<ProfileUpdateResponse> completeAccount({required var data}) async {
    final res = await _dioClient.post(EndPoints.completeAccount, data: data);
    return ProfileUpdateResponse.fromJson(res);
  }

  Future logout() async {
    return await _dioClient.post(EndPoints.logout);
  }

  Future getProfile() async {
    return await _dioClient.get(EndPoints.profile);
  }

  Future updateProfile({required Map data}) async {
    return await _dioClient.post(EndPoints.updateProfile, data: data);
  }

  // ====== Catalog ======

  Future<HomeResponse> getHome({
    required double lat,
    required double lng,
  }) async {
    final res = await _dioClient.get(
      EndPoints.home,
      queryParameters: {
        'lat': lat,
        'lng': lng,
        'latitude': lat,
        'longitude': lng,
      },
    );
    return HomeResponse.fromJson(res);
  }

  Future getEnums() async {
    return await _dioClient.get(EndPoints.enums);
  }

  Future getBasics() async {
    return await _dioClient.get(EndPoints.basics);
  }

  Future getSections({String? type}) async {
    return await _dioClient.get(
      EndPoints.sections,
      queryParameters: _cleanQuery({'type': type}),
    );
  }

  Future<SectionDetailsResponse> getSectionDetails(
    int id, {
    int page = 1,
  }) async {
    final res = await _dioClient.get(
      EndPoints.sectionDetails(id),
      queryParameters: {'page': page},
    );
    return SectionDetailsResponse.fromApiMap(res);
  }

  Future getMarkets({
    double? lat,
    double? lng,
    String? type,
    List<String>? types,
    int? sectionId,
    int? mallId,
    int? mallSectionId,
    int? commercialCenterId,
    String? keyword,
    int? isFav,
    String? sort,
    double? radiusKm,
    int page = 1,
  }) async {
    return await _dioClient.get(
      EndPoints.markets,
      queryParameters: _cleanQuery({
        'lat': lat,
        'lng': lng,
        'latitude': lat,
        'longitude': lng,
        'type': type,
        'types': types,
        'section_id': sectionId,
        'mall_id': mallId,
        'mall_section_id': mallSectionId,
        'commercial_center_id': commercialCenterId,
        'keyword': keyword,
        'is_fav': isFav,
        'sort': sort,
        'radius_km': radiusKm,
        'page': page,
      }),
    );
  }

  Future getMarketDetails(int id) async {
    return await _dioClient.get('${EndPoints.markets}/$id');
  }

  Future getProducts({
    required int marketId,
    int? categoryId,
    int page = 1,
  }) async {
    return await _dioClient.get(
      EndPoints.products,
      queryParameters: _cleanQuery({
        'market_id': marketId,
        'category_id': categoryId,
        'page': page,
      }),
    );
  }

  Future<ProductDetailsResponse> getProductDetails(int id) async {
    final res = await _dioClient.get('${EndPoints.products}/$id');
    return ProductDetailsResponse.fromApiMap(res);
  }

  Future getServices({
    required double lat,
    required double lng,
    int? sectionId,
    String? type,
    int page = 1,
  }) async {
    return await _dioClient.get(
      EndPoints.services,
      queryParameters: _cleanQuery({
        'lat': lat,
        'lng': lng,
        'latitude': lat,
        'longitude': lng,
        'section_id': sectionId,
        'type': type,
        'page': page,
      }),
    );
  }

  Future getServiceDetails(int id) async {
    return await _dioClient.get(EndPoints.serviceDetails(id));
  }

  Future getMalls({double? lat, double? lng, int page = 1}) async {
    return await _dioClient.get(
      EndPoints.malls,
      queryParameters: _cleanQuery({
        'lat': lat,
        'lng': lng,
        'latitude': lat,
        'longitude': lng,
        'page': page,
      }),
    );
  }

  Future getMallDetail(int id) async {
    return await _dioClient.get(EndPoints.mallDetails(id));
  }

  Future getCommercialCenters({double? lat, double? lng, int page = 1}) async {
    return await _dioClient.get(
      EndPoints.commercialCenters,
      queryParameters: _cleanQuery({
        'lat': lat,
        'lng': lng,
        'latitude': lat,
        'longitude': lng,
        'page': page,
      }),
    );
  }

  Future getCommercialCenterDetail(int id) async {
    return await _dioClient.get(EndPoints.commercialCenterDetails(id));
  }

  Future getKioks({double? lat, double? lng, int? sectionId}) async {
    final query = _cleanQuery({
      'lat': lat,
      'lng': lng,
      'latitude': lat,
      'longitude': lng,
      'section_id': sectionId,
    });
    try {
      // Prefer canonical endpoint naming.
      return await _dioClient.get(EndPoints.kiosks, queryParameters: query);
    } on DioException catch (e) {
      // Backward compatibility for environments that still expose `/kioks`.
      if (e.response?.statusCode == 404) {
        return await _dioClient.get(EndPoints.kioks, queryParameters: query);
      }
      rethrow;
    }
  }

  Future getBookingResources(int marketId) async {
    return await _dioClient.get(EndPoints.bookingResources(marketId));
  }

  Future getBookingSlots(int marketId, {String? date, int? resourceId}) async {
    return await _dioClient.get(
      EndPoints.bookingSlots(marketId),
      queryParameters: _cleanQuery({
        'date': date,
        'booking_resource_id': resourceId,
      }),
    );
  }

  Future checkHotelAvailability(
    int marketId, {
    Map<String, dynamic>? params,
  }) async {
    return await _dioClient.get(
      EndPoints.bookingAvailability(marketId),
      queryParameters: params == null ? null : _cleanQuery(Map.of(params)),
    );
  }

  // ====== Orders ======

  Future storeOrder({required Map body}) async {
    return await _dioClient.post(EndPoints.storeOrder, data: body);
  }

  Future payOrder(int id, {Map? data}) async {
    return await _dioClient.post(EndPoints.payOrder(id), data: data);
  }

  Future cancelOrder(int id, {Map? data}) async {
    return await _dioClient.post(EndPoints.cancelOrder(id), data: data);
  }

  Future rateOrder(int id, {required Map data}) async {
    return await _dioClient.post(EndPoints.rateOrder(id), data: data);
  }

  Future getOrderInfo({Map<String, dynamic>? query}) async {
    return await _dioClient.get(
      EndPoints.orderInfo,
      queryParameters: query == null ? null : _cleanQuery(Map.of(query)),
    );
  }

  Future openPaymentPage({required Map data}) async {
    return await _dioClient.post(EndPoints.openPaymentPage, data: data);
  }

  Future paymentStatus(String paymentRef) async {
    return await _dioClient.get(EndPoints.paymentStatus(paymentRef));
  }

  Future<OrderResponse> getMyOrders(String? filter, {int page = 1}) async {
    final res = await _dioClient.get(
      EndPoints.getMyOrders,
      queryParameters: {'status': filter, 'page': page},
    );
    if (res is! Map) {
      throw ApiException('invalid_orders_response'.tr);
    }
    final map = Map<String, dynamic>.from(res);
    final parsed = OrderResponse.fromJson(map);
    if (!parsed.isSuccess) {
      throw ApiException(
        parsed.message.isNotEmpty ? parsed.message : 'failed_to_load_orders'.tr,
      );
    }
    return parsed;
  }

  Future<OrderDetailResponse> getDetailedOrder({required int id}) async {
    final res = await _dioClient.get('${EndPoints.getMyOrders}/$id');
    if (res is! Map) {
      throw ApiException('invalid_order_detail_response'.tr);
    }
    final map = Map<String, dynamic>.from(res);
    final parsed = OrderDetailResponse.fromJson(map);
    if (!parsed.isSuccess) {
      throw ApiException(
        parsed.message.isNotEmpty
            ? parsed.message
            : 'failed_to_load_order_details'.tr,
      );
    }
    return parsed;
  }

  // ====== Wallet / Points / Visas ======

  Future getWallets() async {
    return await _dioClient.get(EndPoints.wallets);
  }

  Future chargeWallet({required Map data}) async {
    return await _dioClient.post(EndPoints.chargeWallet, data: data);
  }

  Future giftWallet({required Map data}) async {
    return await _dioClient.post(EndPoints.giftWallet, data: data);
  }

  Future walletCards() async {
    return await _dioClient.get(EndPoints.walletCards);
  }

  Future chargeStatus(String paymentRef) async {
    return await _dioClient.get(EndPoints.chargeStatus(paymentRef));
  }

  Future getPoints() async {
    return await _dioClient.get(EndPoints.points);
  }

  Future giftPoints({required Map data}) async {
    return await _dioClient.post(EndPoints.giftPoints, data: data);
  }

  Future convertPointsToWallet({required Map data}) async {
    return await _dioClient.post(EndPoints.convertPointsToWallet, data: data);
  }

  Future getVisas() async {
    return await _dioClient.get(EndPoints.visas);
  }

  Future storeVisa({required Map data}) async {
    return await _dioClient.post(EndPoints.storeVisa, data: data);
  }

  Future setDefaultVisa(int id) async {
    return await _dioClient.post(EndPoints.setDefaultVisa(id));
  }

  Future deleteVisa(int id) async {
    return await _dioClient.delete('${EndPoints.visas}/$id');
  }

  // ====== Addresses / Cars ======

  Future getAddresses() async {
    return await _dioClient.get(EndPoints.addresses);
  }

  Future storeAddress({required Map data}) async {
    return await _dioClient.post(EndPoints.storeAddress, data: data);
  }

  Future deleteAddress(int id) async {
    return await _dioClient.delete('${EndPoints.addresses}/$id');
  }

  Future getUserCars() async {
    return await _dioClient.get(EndPoints.userCars);
  }

  Future storeUserCar({required Map data}) async {
    return await _dioClient.post(EndPoints.storeUserCar, data: data);
  }

  Future deleteUserCar(int id) async {
    return await _dioClient.delete('${EndPoints.userCars}/$id');
  }

  Future userCarsInfo() async {
    return await _dioClient.get(EndPoints.userCarsInfo);
  }

  // ====== Coupons / Favorites / Misc ======

  Future checkCoupon({required Map data}) async {
    return await _dioClient.post(EndPoints.checkCoupon, data: data);
  }

  Future getCoupons() async {
    return await _dioClient.get(EndPoints.coupons);
  }

  Future favMarket(int id) async {
    return await _dioClient.post(EndPoints.favMarket(id));
  }

  /// Uses the dedicated favorites endpoint only (contract-first).
  Future getFavorites({int page = 1}) async {
    return await _dioClient.get(
      EndPoints.favorites,
      queryParameters: {'page': page},
    );
  }

  Future getFaqs() async {
    return await _dioClient.get(EndPoints.faqs);
  }

  Future getTermPrivacy() async {
    return await _dioClient.get(EndPoints.termPrivacy);
  }

  Future getOffers({int page = 1}) async {
    return await _dioClient.get(
      EndPoints.offers,
      queryParameters: {'page': page},
    );
  }

  Future getOfferDetails(int id) async {
    return await _dioClient.get(EndPoints.offerDetails(id));
  }

  Future getMeals({int page = 1}) async {
    return await _dioClient.get(
      EndPoints.meals,
      queryParameters: {'page': page},
    );
  }

  Future getMealDetails(int id) async {
    return await _dioClient.get(EndPoints.mealDetails(id));
  }

  Future getCategories({Map<String, dynamic>? query}) async {
    return await _dioClient.get(
      EndPoints.categories,
      queryParameters: query == null ? null : _cleanQuery(Map.of(query)),
    );
  }

  Future getTags() async {
    return await _dioClient.get(EndPoints.tags);
  }

  Future getMarketReviews(int id, {int page = 1}) async {
    return await _dioClient.get(
      EndPoints.marketReviews(id),
      queryParameters: {'page': page},
    );
  }

  Future getMapMarkets({required Map<String, dynamic> query}) async {
    return await _dioClient.get(
      EndPoints.mapMarkets,
      queryParameters: _cleanQuery(Map.of(query)),
    );
  }

  Future checkAppVersion({required Map data}) async {
    return await _dioClient.post(EndPoints.version, data: data);
  }

  Future loginWithEmail({required Map data}) async {
    return await _dioClient.post(EndPoints.loginEmail, data: data);
  }

  // ====== Account extras ======

  Future deleteAccount() async {
    return await _dioClient.post(EndPoints.deleteAccount);
  }

  Future updateFcm({required Map data}) async {
    return await _dioClient.post(EndPoints.updateFcm, data: data);
  }

  Future updateLang({required Map data}) async {
    return await _dioClient.post(EndPoints.updateLang, data: data);
  }

  Future getPaymentSettings() async {
    return await _dioClient.get(EndPoints.paymentSettings);
  }

  Future setDefaultPaymentMethod({required Map data}) async {
    return await _dioClient.post(EndPoints.setDefaultPaymentMethod, data: data);
  }

  Future setDailyPurchaseLimit({required Map data}) async {
    return await _dioClient.post(EndPoints.setDailyPurchaseLimit, data: data);
  }

  Future getInfoUser({Map<String, dynamic>? query}) async {
    return await _dioClient.get(
      EndPoints.infoUser,
      queryParameters: query == null ? null : _cleanQuery(Map.of(query)),
    );
  }

  // ====== Security OTP ======

  Future changePaymentPassword({required Map data}) async {
    return await _dioClient.post(EndPoints.changePaymentPassword, data: data);
  }

  Future sendCodeForChangePayment({required Map data}) async {
    return await _dioClient.post(
      EndPoints.sendCodeForChangePayment,
      data: data,
    );
  }

  Future checkCodeForChangePayment({required Map data}) async {
    return await _dioClient.post(
      EndPoints.checkCodeForChangePayment,
      data: data,
    );
  }

  Future changePaymentPasswordByOtp({required Map data}) async {
    return await _dioClient.post(
      EndPoints.changePaymentPasswordByOtp,
      data: data,
    );
  }

  Future sendCodeForEmailPassword({required Map data}) async {
    return await _dioClient.post(
      EndPoints.sendCodeForEmailPassword,
      data: data,
    );
  }

  Future checkCodeForEmailPassword({required Map data}) async {
    return await _dioClient.post(
      EndPoints.checkCodeForEmailPassword,
      data: data,
    );
  }

  Future changeEmailPasswordByOtp({required Map data}) async {
    return await _dioClient.post(
      EndPoints.changeEmailPasswordByOtp,
      data: data,
    );
  }

  Future sendCodeForEmailChange({required Map data}) async {
    return await _dioClient.post(EndPoints.sendCodeForEmailChange, data: data);
  }

  Future checkCodeForEmailChange({required Map data}) async {
    return await _dioClient.post(EndPoints.checkCodeForEmailChange, data: data);
  }

  Future changeEmailByOtp({required Map data}) async {
    return await _dioClient.post(EndPoints.changeEmailByOtp, data: data);
  }

  Future changeVerificationCode({required Map data}) async {
    return await _dioClient.post(EndPoints.changeVerificationCode, data: data);
  }

  // ====== Support / Reports / Chat ======

  Future getContactInfo() async {
    return await _dioClient.get(EndPoints.contactInfo);
  }

  Future getInquiries({int page = 1}) async {
    return await _dioClient.get(
      EndPoints.inquiries,
      queryParameters: {'page': page},
    );
  }

  Future storeInquiry({required Map data}) async {
    return await _dioClient.post(EndPoints.inquiries, data: data);
  }

  Future deleteInquiry(int id) async {
    return await _dioClient.delete('${EndPoints.inquiries}/$id');
  }

  Future getReports({Map<String, dynamic>? query}) async {
    return await _dioClient.get(
      EndPoints.reports,
      queryParameters: query == null ? null : _cleanQuery(Map.of(query)),
    );
  }

  Future getInboxes({int page = 1}) async {
    return await _dioClient.get(
      EndPoints.inboxes,
      queryParameters: {'page': page},
    );
  }

  Future getOrderChat(int orderId) async {
    return await _dioClient.get(EndPoints.orderChat(orderId));
  }

  Future sendChatMessage({required Map data}) async {
    return await _dioClient.post(EndPoints.sendChatMessage, data: data);
  }

  // ====== Notifications ======

  Future<NotificationResponse> getNotifications({int page = 1}) async {
    final res = await _dioClient.get(
      EndPoints.getNotifications,
      queryParameters: {'page': page},
    );
    return NotificationResponse.fromJson(res);
  }

  /// Backend returns an empty `data: {}` payload for deletes, so this is
  /// intentionally untyped (unlike [getNotifications]).
  Future deleteOneNotification({required int id}) async {
    return await _dioClient.delete('${EndPoints.getNotifications}/$id');
  }

  Future deleteAllNotifications() async {
    return await _dioClient.delete(EndPoints.deleteAllNotifications);
  }
}
