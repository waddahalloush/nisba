// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:nisba_app/src/ui/screens/Order/extensions/order_status_extension.dart';

/// نموذج يمثل بيانات الطلب - جاهز للربط مع API
class OrderModel {
  final String orderId;
  final String dateTime;
  final String restaurantName;
  final String restaurantAddress;
  final double totalPrice;
  final int currentStep;
  final String itemImageUrl;
  final String restaurantLogoUrl;
  final OrderStatus status;

  const OrderModel({
    required this.orderId,
    required this.dateTime,
    required this.restaurantName,
    required this.restaurantAddress,
    required this.totalPrice,
    required this.currentStep,
    required this.itemImageUrl,
    required this.restaurantLogoUrl,
    required this.status,
  });

  /// Factory لإنشاء نموذج من JSON (جاهز للـ API)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['order_id'] as String? ?? '',
      dateTime: json['date_time'] as String? ?? '',
      restaurantName: json['restaurant_name'] as String? ?? '',
      restaurantAddress: json['restaurant_address'] as String? ?? '',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      currentStep: json['current_step'] as int? ?? 0,
      itemImageUrl: json['item_image_url'] as String? ?? '',
      restaurantLogoUrl: json['restaurant_logo_url'] as String? ?? '',
      status: OrderStatusExtension.fromStep(json['current_step'] as int? ?? 0),
    );
  }

  /// تحويل النموذج إلى JSON (جاهز للـ API)
  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'date_time': dateTime,
      'restaurant_name': restaurantName,
      'restaurant_address': restaurantAddress,
      'total_price': totalPrice,
      'current_step': currentStep,
      'item_image_url': itemImageUrl,
      'restaurant_logo_url': restaurantLogoUrl,
    };
  }
}
