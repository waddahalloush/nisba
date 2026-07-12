import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/ui/screens/Auth/OTP/otp_verify_controller.dart';
import 'package:nisba_app/src/ui/screens/Auth/Register/register_controller.dart';
import 'package:nisba_app/src/ui/screens/Home/controller/home_controller.dart';
import 'package:nisba_app/src/ui/screens/Notification/notification_controller.dart';
import 'package:nisba_app/src/ui/screens/account%20setting/account_setting_controller.dart';

import '../data/remote/api/app_api.dart';
import '../data/remote/api/dio_client.dart';
import '../data/remote/constants/endpoints.dart';
import '../data/remote/interceptors/auth_interceptor.dart';
import '../data/repository.dart';
import '../ui/screens/Auth/login/login_controller.dart';
import '../ui/screens/Favorite/favorite_controller.dart';
import '../ui/screens/Order/controller/order_controller.dart';
import '../ui/screens/Settings/app_setting_controller.dart';
import '../ui/screens/Splash Screen/splash_controller.dart';
import '../ui/screens/dashboard/dashboard_controller.dart';
import '../ui/screens/scanner/scanner_controller.dart';
import '../ui/screens/search/search_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    //! Auth screens bindings

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

    //! -----------------------
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
            ..interceptors.add(AuthInterceptor())
            ..interceptors.add(
              InterceptorsWrapper(
                onRequest: (options, handler) async {
                  options.headers['Accept'] = "application/json";
                  options.headers['lang'] = Get.locale?.languageCode ?? 'ar';

                  return handler.next(options);
                },
              ),
            ),
      fenix: true,
    );

    Get.lazyPut(() => Repository(), fenix: true);
    Get.lazyPut(() => AppApi(), fenix: true);
    Get.lazyPut(() => DioClient(), fenix: true);
  }
}
