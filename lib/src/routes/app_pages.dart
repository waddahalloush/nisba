import 'package:get/get.dart';
import 'package:nisba_app/src/ui/screens/Account/GiftCredit/gift_credit_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/PaymentSetting/payment_setting_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/RechargeWallet/recharge_wallet_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/Addresses/addresses_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/Security/change_account_password_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/Security/change_email_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/Security/change_payment_password_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/visa/add_visa_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/wallet/wallet_screen.dart';
import 'package:nisba_app/src/ui/screens/Account/wallet/wallet_cards_screen.dart';
import 'package:nisba_app/src/ui/screens/Inbox/inbox_screen.dart';
import 'package:nisba_app/src/ui/screens/Home/Booking/cinema_booking_screen.dart';
import 'package:nisba_app/src/ui/screens/Home/Booking/cinema_booking_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/Booking/entertainment_booking_screen.dart';
import 'package:nisba_app/src/ui/screens/Home/Booking/entertainment_booking_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/Booking/hotel_booking_screen.dart';
import 'package:nisba_app/src/ui/screens/Home/Booking/hotel_booking_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/Products/ProductDetails/product_details.dart';
import 'package:nisba_app/src/ui/screens/Home/Restorant/restorant_screen.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/AllServices/all_home_services_screen.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/ServiceSection/service_section_screen.dart';
import 'package:nisba_app/src/ui/screens/Home/Services/kioks/kioks_screen.dart';
import 'package:nisba_app/src/ui/screens/Notification/notification_screen.dart';
import 'package:nisba_app/src/ui/screens/Payment/payment_screen.dart';
import 'package:nisba_app/src/ui/screens/Payment/PaymentWebView/payment_webview_controller.dart';
import 'package:nisba_app/src/ui/screens/Payment/PaymentWebView/payment_webview_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/Coupons/coupon_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/Help/CustomerSupport/customer_support_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/Points/point_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/Reports/report_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/cars/my_cars_screen.dart';

import '../ui/screens/Account/UserAccount/user_account_screen.dart';
import '../ui/screens/Account/account_setting_screen.dart';
import '../ui/screens/Auth/OTP/otp_verify_screen.dart';
import '../ui/screens/Auth/Register/register_screen.dart';
import '../ui/screens/Auth/login/login_screen.dart';
import '../ui/screens/Cart/cart_screen.dart';
import '../ui/screens/Favorite/favorite_screen.dart';
import '../ui/screens/Home/Restorant/RestorantDetails/restorant_details_screen.dart';
import '../ui/screens/Home/Restorant/RestorantDetails/restorant_details_controller.dart';
import '../ui/screens/Home/Services/BaseService/PlaceDetails/place_details_screen.dart';
import '../ui/screens/Home/Services/BaseService/PlaceDetails/place_details_controller.dart';
import '../ui/screens/Home/Services/Mall/Mall Details/mall_details_controller.dart';
import '../ui/screens/Home/Services/kioks/kioks_controller.dart';
import '../ui/screens/Home/Services/Mall/Mall Details/mall_details_screen.dart';
import '../ui/screens/Home/Services/Mall/mall_screen.dart';
import '../ui/screens/Home/Services/Mall/mall_controller.dart';
import '../ui/screens/Home/Services/CommercialCenter/commercial_center_controller.dart';
import '../ui/screens/Home/Services/CommercialCenter/commercial_center_screen.dart';
import '../ui/screens/Offer/offer_screen.dart';
import '../ui/screens/Order/Chat/order_chat_controller.dart';
import '../ui/screens/Order/Chat/order_chat_screen.dart';
import '../ui/screens/Settings/About/about_screen.dart';
import '../ui/screens/Settings/FAQs/faq_screen.dart';
import '../ui/screens/Settings/Help/privacy_screen.dart';
import '../ui/screens/Settings/app_setting_screen.dart';
import '../ui/screens/SplashScreen/splash_screen.dart';
import '../ui/screens/dashboard/dashboard_screen.dart';
import 'routes_names.dart';

abstract class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutesNames.splashScreen,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.register,
      page: () => const RegisterScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.otpVerification,
      page: () => const OtpVerifyScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.dashboard,
      page: () => const DashboardScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.appSetting,
      page: () => const AppSettingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.accountSetting,
      page: () => const AccountSettingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.notification,
      page: () => const NotificationScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.favorite,
      page: () => const FavoriteScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.userAccount,
      page: () => const UserAccountScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.wallet,
      page: () => const WalletScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.walletCards,
      page: () => const WalletCardsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.giftCredit,
      page: () => const GiftCreditScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.rechargeWallet,
      page: () => const RechargeWalletScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.faq,
      page: () => const FaqScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.about,
      page: () => const AboutScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.myCars,
      page: () => const MyCarsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.points,
      page: () => const PointScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.coupon,
      page: () => const CouponScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.report,
      page: () => const ReportScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.privacy,
      page: () => const PrivacyScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.support,
      page: () => const CustomerSupportScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.paymentSetting,
      page: () => const PaymentSettingScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.visa,
      page: () => const AddVisaScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.addresses,
      page: () => const AddressesScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.cart,
      page: () => const CartScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.payment,
      page: () => const PaymentScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.paymentWebView,
      page: () => const PaymentWebViewScreen(),
      transition: Transition.fadeIn,
      binding: BindingsBuilder(() {
        Get.put(PaymentWebViewController());
      }),
    ),
    GetPage(
      name: AppRoutesNames.offer,
      page: () => const OfferScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.restorant,
      page: () => const RestorantScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.restorantDetails,
      page: () => const RestorantDetailsScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<RestorantDetailsController>()) {
          Get.delete<RestorantDetailsController>(force: true);
        }
        Get.put(RestorantDetailsController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.productDetails,
      page: () => const ProductDetailsScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.mall,
      page: () => const MallScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<MallController>()) {
          Get.delete<MallController>(force: true);
        }
        Get.put(MallController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.mallDetails,
      page: () => const MallDetailsScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<MallDetailsController>()) {
          Get.delete<MallDetailsController>(force: true);
        }
        Get.put(MallDetailsController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.commercialCenters,
      page: () => const CommercialCenterScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<CommercialCenterController>()) {
          Get.delete<CommercialCenterController>(force: true);
        }
        Get.put(CommercialCenterController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.kioks,
      page: () => const KioskScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<KioskController>()) {
          Get.delete<KioskController>(force: true);
        }
        Get.put(KioskController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.allHomeServices,
      page: () => const AllHomeServicesScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.serviceSection,
      page: () => const ServiceSectionScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.placeDetails,
      page: () => const PlaceDetailsScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<PlaceDetailsController>()) {
          Get.delete<PlaceDetailsController>(force: true);
        }
        Get.put(PlaceDetailsController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.cinemaBooking,
      page: () => const CinemaBookingScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<CinemaBookingController>()) {
          Get.delete<CinemaBookingController>(force: true);
        }
        Get.put(CinemaBookingController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.hotelBooking,
      page: () => const HotelBookingScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<HotelBookingController>()) {
          Get.delete<HotelBookingController>(force: true);
        }
        Get.put(HotelBookingController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.entertainmentBooking,
      page: () => const EntertainmentBookingScreen(),
      binding: BindingsBuilder(() {
        if (Get.isRegistered<EntertainmentBookingController>()) {
          Get.delete<EntertainmentBookingController>(force: true);
        }
        Get.put(EntertainmentBookingController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.orderChat,
      page: () => const OrderChatScreen(),
      binding: BindingsBuilder(() {
        Get.put(OrderChatController());
      }),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.changePaymentPassword,
      page: () => const ChangePaymentPasswordScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.changeEmail,
      page: () => const ChangeEmailScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.changeAccountPassword,
      page: () => const ChangeAccountPasswordScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutesNames.inbox,
      page: () => const InboxScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
