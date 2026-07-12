import 'package:get/get.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import '../../../../generated/assets.gen.dart';

class SplashController extends GetxController {
  @override
  onInit() {
    moveToNextPage();
    super.onInit();
  }

  String imgLogo = Assets.images.logo3d.path;

  Future<void> moveToNextPage() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offNamed(AppRoutesNames.login);
  }
}
