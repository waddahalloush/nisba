import 'package:get/get.dart';
import 'package:nisba_app/src/ui/screens/Notification/notification_screen.dart';

import '../ui/screens/Auth/OTP/otp_verify_screen.dart';
import '../ui/screens/Auth/Register/register_screen.dart';
import '../ui/screens/Auth/login/login_screen.dart';
import '../ui/screens/Favorite/favorite_screen.dart';
import '../ui/screens/Settings/app_setting_screen.dart';
import '../ui/screens/Splash Screen/splash_screen.dart';
import '../ui/screens/account setting/account_setting_screen.dart';
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
  ];
}
