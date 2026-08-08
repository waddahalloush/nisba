import 'package:get/get.dart';
/// Client-side estimate mirroring `OrderRepository::store` totals.
///
/// Backend formula (products after options):
/// 1. subtotal = sum(cart.price * qty)
/// 2. coupon_value + offer discount → totalAfterDiscounts
/// 3. commission = totalAfterDiscounts * market_commission_rate%
/// 4. customer_discount = commission * customer_discount_percent%
/// 5. points_customer (earned) = (commission * customer_points_percent%) / conversion_rate
/// 6. delivery_price = market.delivery_price only when delivery_type == to_home
/// 7. grand_total = totalAfterDiscounts - customer_discount + delivery_price
///
/// Note: paying WITH points is a payment_method (`point`), not an invoice line discount.
class MarketPricingRates {
  final double deliveryPrice;
  final double marketCommissionRate;
  final double customerDiscountPercent;
  final double customerPointsPercent;
  final double conversionRatePointMoney;

  const MarketPricingRates({
    this.deliveryPrice = 0,
    this.marketCommissionRate = 0,
    this.customerDiscountPercent = 0,
    this.customerPointsPercent = 0,
    this.conversionRatePointMoney = 1,
  });

  factory MarketPricingRates.fromMarketMap(
    Map raw, {
    double conversionRatePointMoney = 1,
  }) {
    final map = Map<String, dynamic>.from(raw);
    return MarketPricingRates(
      deliveryPrice:
          double.tryParse(map['delivery_price']?.toString() ?? '') ?? 0,
      marketCommissionRate:
          double.tryParse(map['market_commission_rate']?.toString() ?? '') ?? 0,
      customerDiscountPercent:
          double.tryParse(map['customer_discount_percent']?.toString() ?? '') ??
              0,
      customerPointsPercent:
          double.tryParse(map['customer_points_percent']?.toString() ?? '') ?? 0,
      conversionRatePointMoney:
          conversionRatePointMoney > 0 ? conversionRatePointMoney : 1,
    );
  }
}

class OrderPricingBreakdown {
  final double subtotal;
  final double couponValue;
  final double offerDiscount;
  final double totalAfterDiscounts;
  final double commission;
  final double customerDiscount;
  final double pointsCustomer;
  final double deliveryPrice;
  final double totalWithDelivery;
  final double grandTotal;

  const OrderPricingBreakdown({
    required this.subtotal,
    required this.couponValue,
    required this.offerDiscount,
    required this.totalAfterDiscounts,
    required this.commission,
    required this.customerDiscount,
    required this.pointsCustomer,
    required this.deliveryPrice,
    required this.totalWithDelivery,
    required this.grandTotal,
  });

  static const zero = OrderPricingBreakdown(
    subtotal: 0,
    couponValue: 0,
    offerDiscount: 0,
    totalAfterDiscounts: 0,
    commission: 0,
    customerDiscount: 0,
    pointsCustomer: 0,
    deliveryPrice: 0,
    totalWithDelivery: 0,
    grandTotal: 0,
  );
}

class OrderPricing {
  /// [deliveryType] matches backend enum values (`to_home`, …).
  static OrderPricingBreakdown estimate({
    required double subtotal,
    required MarketPricingRates rates,
    String deliveryType = 'to_home',
    double couponValue = 0,
    double offerDiscount = 0,
  }) {
    final discounts = couponValue + offerDiscount;
    var totalAfter = subtotal - discounts;
    if (totalAfter < 0) totalAfter = 0;

    final commission = totalAfter * (rates.marketCommissionRate / 100);
    final customerDiscount =
        commission * (rates.customerDiscountPercent / 100);
    final pointsMoney = commission * (rates.customerPointsPercent / 100);
    final rate = rates.conversionRatePointMoney > 0
        ? rates.conversionRatePointMoney
        : 1;
    final pointsCustomer = pointsMoney / rate;

    final delivery =
        deliveryType == 'to_home' ? rates.deliveryPrice : 0.0;
    final totalWithDelivery = totalAfter + delivery;
    final grandTotal = (totalAfter - customerDiscount) + delivery;

    return OrderPricingBreakdown(
      subtotal: subtotal,
      couponValue: couponValue,
      offerDiscount: offerDiscount,
      totalAfterDiscounts: totalAfter,
      commission: commission,
      customerDiscount: customerDiscount,
      pointsCustomer: pointsCustomer,
      deliveryPrice: delivery,
      totalWithDelivery: totalWithDelivery,
      grandTotal: grandTotal < 0 ? 0 : grandTotal,
    );
  }

  /// Points required to pay [grandTotal] with payment_method `point`.
  static double pointsRequiredToPay({
    required double grandTotal,
    required double conversionRatePointMoney,
  }) {
    final rate = conversionRatePointMoney > 0 ? conversionRatePointMoney : 1;
    return grandTotal * rate;
  }
}
