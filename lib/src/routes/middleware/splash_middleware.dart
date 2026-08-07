// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../data/local/get_storage_helper.dart';
// import '../routes_names.dart';

// class SplashMiddleware extends GetMiddleware {
//   String toke = Get.find<GetStorageHelper>().authToken;
//   int step = Get.find<GetStorageHelper>().screenStep;

//   @override
//   set priority(int? priority) {
//     priority = 1;
//   }

//   @override
//   RouteSettings? redirect(String? route) {
//     Future.delayed(Duration(seconds: 2), () {
//       switch (step) {
//         case 0:
//           Get.offAllNamed(AppRoutesNames.onboarding);

//           break;
//         case 1:
//           Get.offAllNamed(AppRoutesNames.login);

//           break;
//         case 2:
//           Get.offAllNamed(AppRoutesNames.waitingAccount);

//           break;
//         default: Get.offAllNamed(AppRoutesNames.dash);
//       }
//     });
//     return null; // Return null to prevent navigation to the original route
//   }
// }
