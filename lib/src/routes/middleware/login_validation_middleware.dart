import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/local/get_storage_helper.dart';
import '../routes_names.dart';

class LoginValidationMiddleware extends GetMiddleware {
  String toke = Get.find<GetStorageHelper>().authToken;
  @override
  set priority(int? priority) {
    priority = 1;
  }

  @override
  RouteSettings? redirect(String? route) {
    if (toke == '') {
      return RouteSettings(name: AppRoutesNames.splashScreen);
    }
    return null;
  }
}
