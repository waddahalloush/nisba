// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:nisba_app/src/ui/screens/Order/extensions/order_status_extension.dart';
import 'package:nisba_app/src/ui/screens/Order/models/order_model.dart';

/// صور Unsplash للأصناف المختلفة
class _UnsplashImages {
  static const String burger =
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=300&h=300&fit=crop';
  static const String pizza =
      'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=300&h=300&fit=crop';
  static const String coffee =
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=300&h=300&fit=crop';
  static const String hardeesLogo =
      'https://images.unsplash.com/photo-1582582621959-48d27397dc69?w=100&h=100&fit=crop';
  static const String pizzaHutLogo =
      'https://images.unsplash.com/photo-1628840042765-356cda07504e?w=100&h=100&fit=crop';
  static const String starbucksLogo =
      'https://images.unsplash.com/photo-1582582621959-48d27397dc69?w=100&h=100&fit=crop';
}

class OrderController extends GetxController {
  // التبويب المختار (0 = الحالية، 1 = السابقة)
  final selectedTab = 0.obs;

  // حالة توسيع/طي كل كارد
  final expandedOrders = <String, bool>{}.obs;

  // الطلبات الحالية
  late final List<OrderModel> activeOrders;

  // الطلبات السابقة
  late final List<OrderModel> pastOrders;

  @override
  void onInit() {
    super.onInit();
    activeOrders = _buildActiveOrders();
    pastOrders = _buildPastOrders();
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void toggleOrderExpand(String orderId) {
    if (expandedOrders.containsKey(orderId)) {
      expandedOrders[orderId] = !expandedOrders[orderId]!;
    } else {
      expandedOrders[orderId] = true;
    }
    expandedOrders.refresh();
  }

  bool isOrderExpanded(String orderId) {
    return expandedOrders[orderId] ?? false;
  }

  // --- بيانات تجريبية ---

  static List<OrderModel> _buildActiveOrders() {
    return [
      const OrderModel(
        orderId: '#1234567',
        dateTime: '09:27 مساءً، 26/06',
        restaurantName: 'هارديز',
        restaurantAddress: 'الدوحة',
        totalPrice: 25.00,
        currentStep: 1,
        itemImageUrl: _UnsplashImages.burger,
        restaurantLogoUrl: _UnsplashImages.hardeesLogo,
        status: OrderStatus.preparing,
      ),
      const OrderModel(
        orderId: '#7654321',
        dateTime: '07:15 مساءً، 26/06',
        restaurantName: 'بيتزا هت',
        restaurantAddress: 'الريان',
        totalPrice: 42.50,
        currentStep: 3,
        itemImageUrl: _UnsplashImages.pizza,
        restaurantLogoUrl: _UnsplashImages.pizzaHutLogo,
        status: OrderStatus.delivered,
      ),
      const OrderModel(
        orderId: '#9876543',
        dateTime: '07:05 صباحاً، 01/06',
        restaurantName: 'ستاربكس',
        restaurantAddress: 'لوسيل',
        totalPrice: 18.00,
        currentStep: 2,
        itemImageUrl: _UnsplashImages.coffee,
        restaurantLogoUrl: _UnsplashImages.starbucksLogo,
        status: OrderStatus.delivering,
      ),
    ];
  }

  static List<OrderModel> _buildPastOrders() {
    return [
      const OrderModel(
        orderId: '#1112223',
        dateTime: '05:30 مساءً، 20/06',
        restaurantName: 'ماكدونالدز',
        restaurantAddress: 'الخور',
        totalPrice: 32.00,
        currentStep: 3,
        itemImageUrl: _UnsplashImages.burger,
        restaurantLogoUrl: _UnsplashImages.hardeesLogo,
        status: OrderStatus.delivered,
      ),
      const OrderModel(
        orderId: '#4445556',
        dateTime: '02:00 مساءً، 15/06',
        restaurantName: 'دومينوز',
        restaurantAddress: 'الوكرة',
        totalPrice: 55.00,
        currentStep: 3,
        itemImageUrl: _UnsplashImages.pizza,
        restaurantLogoUrl: _UnsplashImages.pizzaHutLogo,
        status: OrderStatus.delivered,
      ),
    ];
  }
}
