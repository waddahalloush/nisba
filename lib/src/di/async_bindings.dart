
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../data/local/get_storage_helper.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';

class InitBinding extends Bindings {
  @override
  Future dependencies() async {
    await Get.putAsync(() async => await GetStorage.init(), permanent: true);
    Get.lazyPut(() => GetStorageHelper(), fenix: true);
    Get.lazyPut(() => InternetConnectionChecker.instance, fenix: true);
    Get.lazyPut(() => GetStorage(), fenix: true);
    // App-wide settings: must be ready before [GetMaterialApp] builds.
    Get.put(ThemeService(), permanent: true);
    Get.put(LocaleService(), permanent: true);
  }
}
