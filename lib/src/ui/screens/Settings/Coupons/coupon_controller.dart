import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponModel {
  final String title;
  final String discount;
  final String maxSaving;
  final String minOrder;
  final String expiry;
  final String status; // valid, used, expired

  const CouponModel({
    required this.title,
    required this.discount,
    required this.maxSaving,
    required this.minOrder,
    required this.expiry,
    required this.status,
  });
}

class CouponController extends GetxController {
  final selectedTab = 0.obs;
  final codeController = TextEditingController();

  final tabs = ['صالـح', 'استخدم', 'انتهت'];

  final coupons = <CouponModel>[
    const CouponModel(
      title: 'قسيمة التسوق',
      discount: 'وفر 15%',
      maxSaving: 'حد أقصى 75 ريال قطري',
      minOrder: 'الحد الأدنى للطلب 150 ر.ق',
      expiry: 'ينتهي خلال 5 أيام',
      status: 'valid',
    ),
    const CouponModel(
      title: 'قسيمة الشحن',
      discount: 'شحن مجاني 100%',
      maxSaving: 'حد أقصى 25 ريال قطري',
      minOrder: 'الحد الأدنى للطلب 100 ر.ق',
      expiry: 'ينتهي خلال 7 أيام',
      status: 'valid',
    ),
    const CouponModel(
      title: 'قسيمة العروض',
      discount: 'وفر 20%',
      maxSaving: 'حد أقصى 100 ريال قطري',
      minOrder: 'الحد الأدنى للطلب 200 ر.ق',
      expiry: 'ينتهي خلال 12 يوم',
      status: 'valid',
    ),
  ];

  List<CouponModel> get filteredCoupons {
    if (selectedTab.value == 0) {
      return coupons.where((c) => c.status == 'valid').toList();
    }
    if (selectedTab.value == 1) {
      return coupons.where((c) => c.status == 'used').toList();
    }
    return coupons.where((c) => c.status == 'expired').toList();
  }

  void selectTab(int index) => selectedTab.value = index;

  void useCoupon(CouponModel coupon) {
    Get.snackbar('تم', 'تم تطبيق القسيمة: ${coupon.title}');
  }

  void applyCode() {
    if (codeController.text.trim().isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال رمز القسيمة');
      return;
    }
    Get.snackbar('تم', 'تم إضافة القسيمة بنجاح');
    codeController.clear();
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }
}
