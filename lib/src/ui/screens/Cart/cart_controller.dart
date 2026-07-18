import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

import '../../../../generated/assets.gen.dart';

enum DeliveryMethod { orderNow, orderLater }

class CartItem {
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;
  final String? note;

  const CartItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.note,
  });
}

class CouponOption {
  final String title;
  final String icon;

  const CouponOption({required this.title, required this.icon});
}

class CartController extends GetxController {
  final couponController = TextEditingController();

  final items = <CartItem>[
    CartItem(
      name: 'ستربس الدجاج الحار',
      imageUrl: Assets.images.cartItem1.path,
      price: 25.00,
      quantity: 1,
      note: 'ستربس الدجاج الحار مع بطاطا و مشروب غازي\n3 قطع',
    ),
    CartItem(
      name: 'برجر دجاج حار',
      imageUrl: Assets.images.cartItem1.path,
      price: 22.00,
      quantity: 1,
      note: 'برجر الدجاج الحار مع بطاطا و مشروب غازي',
    ),
    CartItem(
      name: 'بطاطا كبيرة',
      imageUrl: Assets.images.cartItem2.path,
      price: 10.00,
      quantity: 1,
      note: 'بطاطا مقلية مدخنة',
    ),
  ];

  final selectedCoupon = 'قسيمة التسوق'.obs;
  final deliveryMethod = DeliveryMethod.orderNow.obs;

  // ── Schedule state ──
  final selectedDate = DateTime.now().obs;
  final selectedTimeSlot = ''.obs;
  final currentCalendarMonth = DateTime.now().obs;

  final List<String> timeSlots = const [
    '7:00 AM - 9:00 AM',
    '9:00 AM - 11:00 AM',
    '11:00 AM - 1:00 PM',
    '1:00 PM - 3:00 PM',
    '3:00 PM - 5:00 PM',
    '5:00 PM - 7:00 PM',
    '7:00 PM - 9:00 PM',
  ];

  final coupons = [
    CouponOption(
      title: 'قسيمة التسوق',
      icon: Assets.images.couponDiscountIcon.path,
    ),
    CouponOption(
      title: 'قسيمة الشحن',
      icon: Assets.images.couponDeliverIcon.path,
    ),
    CouponOption(
      title: 'قسيمة العروض',
      icon: Assets.images.couponOfferIcon.path,
    ),
  ];

  double get subtotal =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));
  double get deliveryFee => 5.00;
  double get tax => subtotal * 0.05;
  double get total => subtotal + deliveryFee + tax;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  void incrementQuantity(int index) {
    items[index] = CartItem(
      name: items[index].name,
      imageUrl: items[index].imageUrl,
      price: items[index].price,
      quantity: items[index].quantity + 1,
      note: items[index].note,
    );
    update();
  }

  void decrementQuantity(int index) {
    if (items[index].quantity > 1) {
      items[index] = CartItem(
        name: items[index].name,
        imageUrl: items[index].imageUrl,
        price: items[index].price,
        quantity: items[index].quantity - 1,
        note: items[index].note,
      );
      update();
    }
  }

  void removeItem(int index) {
    items.removeAt(index);
    update();
  }

  void selectCoupon(String title) => selectedCoupon.value = title;

  void selectDeliveryMethod(DeliveryMethod method) =>
      deliveryMethod.value = method;

  void selectScheduledDate(DateTime date) => selectedDate.value = date;

  void selectTimeSlot(String slot) => selectedTimeSlot.value = slot;

  void goToPreviousMonth() {
    currentCalendarMonth.value = DateTime(
      currentCalendarMonth.value.year,
      currentCalendarMonth.value.month - 1,
      1,
    );
  }

  void goToNextMonth() {
    currentCalendarMonth.value = DateTime(
      currentCalendarMonth.value.year,
      currentCalendarMonth.value.month + 1,
      1,
    );
  }

  String get scheduledSlotLabel => selectedTimeSlot.value.isNotEmpty
      ? selectedTimeSlot.value
      : 'لم يتم تحديد موعد';

  void applyCouponCode() {
    if (couponController.text.trim().isNotEmpty) {
      Get.snackbar('تم', 'تم تفعيل القسيمة بنجاح');
      couponController.clear();
    }
  }

  void checkout() {
    Get.toNamed(AppRoutesNames.payment);
  }

  @override
  void onClose() {
    couponController.dispose();
    super.onClose();
  }
}
