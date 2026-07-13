import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

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
  final IconData icon;

  const CouponOption({required this.title, required this.icon});
}

class CartController extends GetxController {
  final couponController = TextEditingController();

  final items = <CartItem>[
    const CartItem(
      name: 'ستربس الدجاج الحار',
      imageUrl: '',
      price: 25.00,
      quantity: 1,
      note: '3 قطع',
    ),
    const CartItem(
      name: 'برجر دجاج حار',
      imageUrl: '',
      price: 22.00,
      quantity: 1,
    ),
    const CartItem(
      name: 'بطاطا كبيرة',
      imageUrl: '',
      price: 10.00,
      quantity: 1,
    ),
  ];

  final selectedCoupon = 'قسيمة التسوق'.obs;

  final coupons = const [
    CouponOption(title: 'قسيمة العروض', icon: Icons.local_offer_outlined),
    CouponOption(title: 'قسيمة الشحن', icon: Icons.local_shipping_outlined),
    CouponOption(title: 'قسيمة التسوق', icon: Icons.shopping_bag_outlined),
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
