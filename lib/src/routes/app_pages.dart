import 'package:get/get.dart';
import 'package:nisba_app/src/ui/screens/Notification/notification_screen.dart';
import 'package:nisba_app/src/ui/screens/Payment/payment_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/Coupons/coupon_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/Help/Customer%20Support/customer_support_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/Points/point_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/Reports/report_screen.dart';
import 'package:nisba_app/src/ui/screens/Settings/cars/my_cars_screen.dart';
import 'package:nisba_app/src/ui/screens/account/Gift%20Credit/gift_credit_screen.dart';
import 'package:nisba_app/src/ui/screens/account/Recharge%20Wallet/recharge_wallet_screen.dart';
import 'package:nisba_app/src/ui/screens/account/payment%20setting/payment_setting_screen.dart';
import 'package:nisba_app/src/ui/screens/account/visa/add_visa_screen.dart';
import 'package:nisba_app/src/ui/screens/account/wallet/wallet_screen.dart';

import '../ui/screens/Auth/OTP/otp_verify_screen.dart';
import '../ui/screens/Auth/Register/register_screen.dart';
import '../ui/screens/Auth/login/login_screen.dart';
import '../ui/screens/Cart/cart_screen.dart';
import '../ui/screens/Favorite/favorite_screen.dart';
import '../ui/screens/Offer/offer_screen.dart';
import '../ui/screens/Settings/About/about_screen.dart';
import '../ui/screens/Settings/FAQs/faq_screen.dart';
import '../ui/screens/Settings/Help/privacy_screen.dart';
import '../ui/screens/Settings/app_setting_screen.dart';
import '../ui/screens/Splash Screen/splash_screen.dart';
import '../ui/screens/account/account_setting_screen.dart';
import '../ui/screens/account/User Account/user_account_screen.dart';
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
      name: AppRoutesNames.offer,
      page: () => const OfferScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
