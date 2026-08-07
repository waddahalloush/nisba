import 'package:get/get.dart';

extension Dimensions on num {
  double get w {
    return Get.width * (this / 393);
  }

  double get h {
    return Get.height * (this / 852);
  }

  double get r {
    return Get.size.shortestSide * (this / 393);
  }

  double get sp {
    return this * Get.textScaleFactor;
  }
}
