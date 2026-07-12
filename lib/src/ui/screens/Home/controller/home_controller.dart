import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // متغير تفاعلي للتحكم في البانر النشط وتحديث الـ Dots Indicator بداخل الكارد
  final RxInt currentBannerIndex = 0.obs;

  // متحكم السكرول لتتبع موضع التمرير لأعلى
  late final ScrollController scrollController;

  // قيمة تفاعلية لموضع السكرول الحالي (تُستخدم لحساب التلاشي التدريجي)
  final RxDouble scrollOffset = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    scrollOffset.value = scrollController.hasClients
        ? scrollController.offset
        : 0.0;
  }

  void changeBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
