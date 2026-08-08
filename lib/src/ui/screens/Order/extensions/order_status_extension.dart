// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';
import 'package:flutter/material.dart';

/// يمثل حالة الطلب في النظام
enum OrderStatus {
  waitingPayment,
  newOrder,
  preparing,
  delivering,
  delivered,
  cancelled,
}

/// Extension لإرجاع الخصائص المرئية لكل حالة طلب
extension OrderStatusExtension on OrderStatus {
  /// العنوان العربي للحالة
  String get title {
    switch (this) {
      case OrderStatus.waitingPayment:
        return 'auto_key_456'.tr;
      case OrderStatus.newOrder:
        return 'new_order'.tr;
      case OrderStatus.preparing:
        return 'order_stepper_preparing'.tr;
      case OrderStatus.delivering:
        return 'auto_key_457'.tr;
      case OrderStatus.delivered:
        return 'auto_key_458'.tr;
      case OrderStatus.cancelled:
        return 'auto_key_459'.tr;
    }
  }

  /// لون خلفية Chip الحالة
  Color backgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case OrderStatus.waitingPayment:
        return Colors.amber.withValues(alpha: isDark ? 0.25 : 0.12);
      case OrderStatus.newOrder:
        return Colors.blue.withValues(alpha: isDark ? 0.25 : 0.12);
      case OrderStatus.preparing:
        return Colors.orange.withValues(alpha: isDark ? 0.25 : 0.12);
      case OrderStatus.delivering:
        return Colors.purple.withValues(alpha: isDark ? 0.25 : 0.12);
      case OrderStatus.delivered:
        return Colors.green.withValues(alpha: isDark ? 0.25 : 0.12);
      case OrderStatus.cancelled:
        return Colors.red.withValues(alpha: isDark ? 0.25 : 0.12);
    }
  }

  /// لون نص Chip الحالة
  Color textColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case OrderStatus.waitingPayment:
        return isDark ? Colors.amber.shade200 : Colors.amber.shade900;
      case OrderStatus.newOrder:
        return isDark ? Colors.blue.shade200 : Colors.blue.shade800;
      case OrderStatus.preparing:
        return isDark ? Colors.orange.shade200 : Colors.orange.shade800;
      case OrderStatus.delivering:
        return isDark ? Colors.purple.shade200 : Colors.purple.shade800;
      case OrderStatus.delivered:
        return isDark ? Colors.green.shade200 : Colors.green.shade800;
      case OrderStatus.cancelled:
        return isDark ? Colors.red.shade200 : Colors.red.shade800;
    }
  }

  /// أيقونة تمثل حالة الطلب
  IconData get icon {
    switch (this) {
      case OrderStatus.waitingPayment:
        return Icons.payment_rounded;
      case OrderStatus.newOrder:
        return Icons.receipt_long_rounded;
      case OrderStatus.preparing:
        return Icons.restaurant_rounded;
      case OrderStatus.delivering:
        return Icons.delivery_dining_rounded;
      case OrderStatus.delivered:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  /// تحويل currentStep (0-3) إلى OrderStatus
  static OrderStatus fromStep(int step) {
    switch (step) {
      case 0:
        return OrderStatus.newOrder;
      case 1:
        return OrderStatus.preparing;
      case 2:
        return OrderStatus.delivering;
      case 3:
        return OrderStatus.delivered;
      default:
        return OrderStatus.newOrder;
    }
  }
}
