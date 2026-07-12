import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt currentIndex = 0.obs; // 0 تعني الشاشة الرئيسية الافتراضية النشطة بالصورة

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}