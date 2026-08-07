import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/ui/screens/Account/GiftCredit/gift_credit_controller.dart';
import 'package:nisba_app/src/ui/screens/Account/PaymentSetting/payment_setting_controller.dart';
import 'package:nisba_app/src/ui/screens/Account/Security/change_account_password_controller.dart';
import 'package:nisba_app/src/ui/screens/Account/Security/change_email_controller.dart';
import 'package:nisba_app/src/ui/screens/Account/Security/change_payment_password_controller.dart';
import 'package:nisba_app/src/ui/screens/Account/account_setting_controller.dart';
import 'package:nisba_app/src/ui/screens/Account/Addresses/addresses_controller.dart';
import 'package:nisba_app/src/ui/screens/Account/visa/add_visa_controller.dart';
import 'package:nisba_app/src/ui/screens/Account/wallet/wallet_controller.dart';
import 'package:nisba_app/src/ui/screens/Inbox/inbox_controller.dart';
import 'package:nisba_app/src/ui/screens/Auth/OTP/otp_verify_controller.dart';
import 'package:nisba_app/src/ui/screens/Auth/Register/register_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/Restorant/restorant_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/AllServices/all_home_services_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/ServiceSection/service_section_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/Mall/mall_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/home_controller.dart';
import 'package:nisba_app/src/ui/screens/Notification/notification_controller.dart';
import 'package:nisba_app/src/ui/screens/Payment/payment_controller.dart';
import 'package:nisba_app/src/ui/screens/Settings/Help/CustomerSupport/customer_support_controller.dart';
import 'package:nisba_app/src/ui/screens/Settings/cars/my_cars_controller.dart';

import '../data/remote/api/app_api.dart';
import '../data/remote/api/dio_client.dart';
import '../data/remote/constants/endpoints.dart';
import '../data/remote/interceptors/auth_interceptor.dart';
import '../data/repository.dart';
import '../ui/screens/Account/RechargeWallet/recharge_wallet_controller.dart';
import '../ui/screens/Account/UserAccount/user_account_controller.dart';
import '../ui/screens/Auth/login/login_controller.dart';
import '../ui/screens/Cart/cart_controller.dart';
import '../ui/screens/Favorite/favorite_controller.dart';
import '../ui/screens/Home/Products/ProductDetails/product_details_controller.dart';
import '../ui/screens/Offer/offer_controller.dart';
import '../ui/screens/Order/order_controller.dart';
import '../ui/screens/Scanner/scanner_controller.dart';
import '../ui/screens/Search/search_controller.dart';
import '../ui/screens/Settings/About/about_controller.dart';
import '../ui/screens/Settings/Coupons/coupon_controller.dart';
import '../ui/screens/Settings/FAQs/faq_controller.dart';
import '../ui/screens/Settings/Help/privacy_controller.dart';
import '../ui/screens/Settings/Points/point_controller.dart';
import '../ui/screens/Settings/Reports/report_controller.dart';
import '../ui/screens/Settings/app_setting_controller.dart';
import '../ui/screens/SplashScreen/splash_controller.dart';
import '../ui/screens/dashboard/dashboard_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SplashController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => OtpVerifyController(), fenix: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => HomeController(), fenix: true);
    Get.lazyPut(() => OrderController(), fenix: true);
    Get.lazyPut(() => SearchhController(), fenix: true);
    Get.lazyPut(() => AppSettingController(), fenix: true);
    Get.lazyPut(() => ScannerController(), fenix: true);
    Get.lazyPut(() => AccountSettingController(), fenix: true);
    Get.lazyPut(() => NotificationnController(), fenix: true);
    Get.lazyPut(() => FavoriteController(), fenix: true);
    Get.lazyPut(() => UserAccountController(), fenix: true);
    Get.lazyPut(() => WalletController(), fenix: true);
    Get.lazyPut(() => GiftCreditController(), fenix: true);
    Get.lazyPut(() => RechargeWalletController(), fenix: true);
    Get.lazyPut(() => FaqController(), fenix: true);
    Get.lazyPut(() => AboutController(), fenix: true);
    Get.lazyPut(() => MyCarsController(), fenix: true);
    Get.lazyPut(() => PointController(), fenix: true);
    Get.lazyPut(() => CouponController(), fenix: true);
    Get.lazyPut(() => ReportController(), fenix: true);
    Get.lazyPut(() => CustomerSupportController(), fenix: true);
    Get.lazyPut(() => PaymentSettingController(), fenix: true);
    Get.lazyPut(() => ChangePaymentPasswordController(), fenix: true);
    Get.lazyPut(() => ChangeEmailController(), fenix: true);
    Get.lazyPut(() => ChangeAccountPasswordController(), fenix: true);
    Get.lazyPut(() => InboxController(), fenix: true);
    Get.lazyPut(() => AddVisaController(), fenix: true);
    Get.lazyPut(() => AddressesController(), fenix: true);
    Get.lazyPut(() => PrivacyController(), fenix: true);
    Get.lazyPut(() => CartController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
    Get.lazyPut(() => OfferController(), fenix: true);
    Get.lazyPut(() => RestorantController(), fenix: true);
    Get.lazyPut(() => ProductDetailsController(), fenix: true);
    Get.lazyPut(() => MallController(), fenix: true);
    Get.lazyPut(() => ServiceSectionController(), fenix: true);
    Get.lazyPut(() => AllHomeServicesController(), fenix: true);
    // Kiosk / RestorantDetails / PlaceDetails / Booking: route-level Get.put

    Get.lazyPut(
      () =>
          Dio(
              BaseOptions(
                baseUrl: EndPoints.baseUrl,
                receiveTimeout: EndPoints.receiveTimeout,
                connectTimeout: EndPoints.connectionTimeout,
              ),
            )
            ..interceptors.add(
              LogInterceptor(
                error: true,
                request: true,
                responseBody: true,
                requestBody: true,
                requestHeader: true,
              ),
            )
            ..interceptors.add(AuthInterceptor()),
      fenix: true,
    );

    Get.lazyPut(() => Repository(), fenix: true);
    Get.lazyPut(() => AppApi(), fenix: true);
    Get.lazyPut(() => DioClient(), fenix: true);
  }
}
