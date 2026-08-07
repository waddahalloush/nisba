import 'package:get/get.dart' hide FormData;
import 'package:nisba_app/src/data/models/product_details_model.dart';
import 'package:nisba_app/src/data/models/section_details_model.dart';

import 'models/Home/home_model.dart';
import 'models/Home/notification_model.dart';
import 'models/Home/order_details_model.dart';
import 'models/Home/order_model.dart';
import 'remote/api/app_api.dart';

class Repository {
  AppApi appApi = Get.find();

  //========== Auth ===============
  Future sendVerificationCode({required var data}) =>
      appApi.sendVerificationCode(data: data);
  Future checkVerificationCode({required var data}) =>
      appApi.checkVerificationCode(data: data);
  Future completeAccount({required var data}) =>
      appApi.completeAccount(data: data);
  Future logout() => appApi.logout();
  Future getProfile() => appApi.getProfile();
  Future updateProfile({required Map data}) =>
      appApi.updateProfile(data: data);

  //========== Catalog ===============
  Future<HomeResponse> getHome({required double lat, required double lng}) =>
      appApi.getHome(lat: lat, lng: lng);
  Future getEnums() => appApi.getEnums();
  Future getBasics() => appApi.getBasics();
  Future getSections({String? type}) => appApi.getSections(type: type);
  Future<SectionDetailsResponse> getSectionDetails(int id, {int page = 1}) =>
      appApi.getSectionDetails(id, page: page);
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
  }) =>
      appApi.getMarkets(
        lat: lat,
        lng: lng,
        type: type,
        types: types,
        sectionId: sectionId,
        mallId: mallId,
        mallSectionId: mallSectionId,
        commercialCenterId: commercialCenterId,
        keyword: keyword,
        isFav: isFav,
        sort: sort,
        radiusKm: radiusKm,
        page: page,
      );
  Future getMarketDetails(int id) => appApi.getMarketDetails(id);
  Future getProducts({
    required int marketId,
    int? categoryId,
    int page = 1,
  }) =>
      appApi.getProducts(
        marketId: marketId,
        categoryId: categoryId,
        page: page,
      );
  Future<ProductDetailsResponse> getProductDetails(int id) => appApi.getProductDetails(id);
  Future getServices({
    required double lat,
    required double lng,
    int? sectionId,
    String? type,
    int page = 1,
  }) =>
      appApi.getServices(
        lat: lat,
        lng: lng,
        sectionId: sectionId,
        type: type,
        page: page,
      );
  Future getServiceDetails(int id) => appApi.getServiceDetails(id);
  Future getMalls({double? lat, double? lng, int page = 1}) =>
      appApi.getMalls(lat: lat, lng: lng, page: page);
  Future getMallDetail(int id) => appApi.getMallDetail(id);
  Future getCommercialCenters({double? lat, double? lng, int page = 1}) =>
      appApi.getCommercialCenters(lat: lat, lng: lng, page: page);
  Future getCommercialCenterDetail(int id) =>
      appApi.getCommercialCenterDetail(id);
  Future getKioks({double? lat, double? lng, int? sectionId}) =>
      appApi.getKioks(lat: lat, lng: lng, sectionId: sectionId);
  Future getBookingResources(int marketId) =>
      appApi.getBookingResources(marketId);
  Future getBookingSlots(
    int marketId, {
    String? date,
    int? resourceId,
  }) =>
      appApi.getBookingSlots(marketId, date: date, resourceId: resourceId);
  Future checkHotelAvailability(
    int marketId, {
    Map<String, dynamic>? params,
  }) =>
      appApi.checkHotelAvailability(marketId, params: params);

  //========== Orders ===============
  Future storeOrder({required Map body}) => appApi.storeOrder(body: body);
  Future payOrder(int id, {Map? data}) => appApi.payOrder(id, data: data);
  Future cancelOrder(int id, {Map? data}) =>
      appApi.cancelOrder(id, data: data);
  Future rateOrder(int id, {required Map data}) =>
      appApi.rateOrder(id, data: data);
  Future getOrderInfo({Map<String, dynamic>? query}) =>
      appApi.getOrderInfo(query: query);
  Future openPaymentPage({required Map data}) =>
      appApi.openPaymentPage(data: data);
  Future paymentStatus(String paymentRef) => appApi.paymentStatus(paymentRef);
  Future<OrderResponse> getMyOrders(String? filter, {int page = 1}) =>
      appApi.getMyOrders(filter, page: page);
  Future<OrderDetailResponse> getDetailedOrder({required int id}) =>
      appApi.getDetailedOrder(id: id);

  //========== Wallet / Points / Visas ===============
  Future getWallets() => appApi.getWallets();
  Future chargeWallet({required Map data}) =>
      appApi.chargeWallet(data: data);
  Future giftWallet({required Map data}) => appApi.giftWallet(data: data);
  Future walletCards() => appApi.walletCards();
  Future chargeStatus(String paymentRef) => appApi.chargeStatus(paymentRef);
  Future getPoints() => appApi.getPoints();
  Future giftPoints({required Map data}) => appApi.giftPoints(data: data);
  Future convertPointsToWallet({required Map data}) =>
      appApi.convertPointsToWallet(data: data);
  Future getVisas() => appApi.getVisas();
  Future storeVisa({required Map data}) => appApi.storeVisa(data: data);
  Future setDefaultVisa(int id) => appApi.setDefaultVisa(id);
  Future deleteVisa(int id) => appApi.deleteVisa(id);

  //========== Addresses / Cars ===============
  Future getAddresses() => appApi.getAddresses();
  Future storeAddress({required Map data}) =>
      appApi.storeAddress(data: data);
  Future deleteAddress(int id) => appApi.deleteAddress(id);
  Future getUserCars() => appApi.getUserCars();
  Future storeUserCar({required Map data}) =>
      appApi.storeUserCar(data: data);
  Future deleteUserCar(int id) => appApi.deleteUserCar(id);
  Future userCarsInfo() => appApi.userCarsInfo();

  //========== Coupons / Favorites / Misc ===============
  Future checkCoupon({required Map data}) => appApi.checkCoupon(data: data);
  Future getCoupons() => appApi.getCoupons();
  Future favMarket(int id) => appApi.favMarket(id);
  Future getFavorites({int page = 1}) => appApi.getFavorites(page: page);
  Future getFaqs() => appApi.getFaqs();
  Future getTermPrivacy() => appApi.getTermPrivacy();
  Future getOffers({int page = 1}) => appApi.getOffers(page: page);
  Future getOfferDetails(int id) => appApi.getOfferDetails(id);
  Future getMeals({int page = 1}) => appApi.getMeals(page: page);
  Future getCategories({Map<String, dynamic>? query}) =>
      appApi.getCategories(query: query);
  Future getTags() => appApi.getTags();
  Future getMarketReviews(int id, {int page = 1}) =>
      appApi.getMarketReviews(id, page: page);
  Future getMapMarkets({required Map<String, dynamic> query}) =>
      appApi.getMapMarkets(query: query);
  Future checkAppVersion({required Map data}) =>
      appApi.checkAppVersion(data: data);
  Future loginWithEmail({required Map data}) =>
      appApi.loginWithEmail(data: data);

  Future deleteAccount() => appApi.deleteAccount();
  Future updateFcm({required Map data}) => appApi.updateFcm(data: data);
  Future updateLang({required Map data}) => appApi.updateLang(data: data);
  Future getPaymentSettings() => appApi.getPaymentSettings();
  Future setDefaultPaymentMethod({required Map data}) =>
      appApi.setDefaultPaymentMethod(data: data);
  Future setDailyPurchaseLimit({required Map data}) =>
      appApi.setDailyPurchaseLimit(data: data);
  Future getInfoUser({Map<String, dynamic>? query}) =>
      appApi.getInfoUser(query: query);

  Future changePaymentPassword({required Map data}) =>
      appApi.changePaymentPassword(data: data);
  Future sendCodeForChangePayment({required Map data}) =>
      appApi.sendCodeForChangePayment(data: data);
  Future checkCodeForChangePayment({required Map data}) =>
      appApi.checkCodeForChangePayment(data: data);
  Future changePaymentPasswordByOtp({required Map data}) =>
      appApi.changePaymentPasswordByOtp(data: data);

  Future sendCodeForEmailPassword({required Map data}) =>
      appApi.sendCodeForEmailPassword(data: data);
  Future checkCodeForEmailPassword({required Map data}) =>
      appApi.checkCodeForEmailPassword(data: data);
  Future changeEmailPasswordByOtp({required Map data}) =>
      appApi.changeEmailPasswordByOtp(data: data);

  Future sendCodeForEmailChange({required Map data}) =>
      appApi.sendCodeForEmailChange(data: data);
  Future checkCodeForEmailChange({required Map data}) =>
      appApi.checkCodeForEmailChange(data: data);
  Future changeEmailByOtp({required Map data}) =>
      appApi.changeEmailByOtp(data: data);
  Future changeVerificationCode({required Map data}) =>
      appApi.changeVerificationCode(data: data);

  Future getContactInfo() => appApi.getContactInfo();
  Future getInquiries({int page = 1}) => appApi.getInquiries(page: page);
  Future storeInquiry({required Map data}) =>
      appApi.storeInquiry(data: data);
  Future deleteInquiry(int id) => appApi.deleteInquiry(id);
  Future getReports({Map<String, dynamic>? query}) =>
      appApi.getReports(query: query);
  Future getInboxes({int page = 1}) => appApi.getInboxes(page: page);
  Future getOrderChat(int orderId) => appApi.getOrderChat(orderId);
  Future sendChatMessage({required Map data}) =>
      appApi.sendChatMessage(data: data);

  //========== Notifications ===============
  Future<NotificationResponse> getNotifications({int page = 1}) =>
      appApi.getNotifications(page: page);
  Future deleteOneNotification({required int id}) =>
      appApi.deleteOneNotification(id: id);
  Future deleteAllNotifications() => appApi.deleteAllNotifications();
}
