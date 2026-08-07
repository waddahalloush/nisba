import 'home_model.dart';
import 'order_model.dart';

String _s(dynamic v, [String d = '']) => v?.toString() ?? d;

int _i(dynamic v, [int d = 0]) => int.tryParse(v?.toString() ?? '') ?? d;

EnumValue _enum(dynamic raw) {
  if (raw is Map) {
    return EnumValue(
      value: raw['value']?.toString() ?? '',
      desc: raw['desc']?.toString() ?? raw['value']?.toString() ?? '',
    );
  }
  return EnumValue(value: raw?.toString() ?? '', desc: raw?.toString() ?? '');
}

List<String> _stringList(dynamic raw) {
  if (raw is List) {
    return raw.map((e) => e.toString()).toList();
  }
  if (raw == null) return const [];
  return [raw.toString()];
}

// ---------------------------------------------------------------------------
// Product nested inside a cart item
// ---------------------------------------------------------------------------
class CartProduct {
  final int id;
  final String name;
  final String image;
  final List<String> deliveryType;
  final String price;
  final String oldPrice;
  final EnumValue withOption;
  final EnumValue status;
  final OrderMarket market;

  const CartProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.deliveryType,
    required this.price,
    required this.oldPrice,
    required this.withOption,
    required this.status,
    required this.market,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) {
    final marketRaw = json['market'];
    return CartProduct(
      id: _i(json['id']),
      name: _s(json['name']),
      image: _s(json['image']),
      deliveryType: _stringList(json['delivery_type']),
      price: _s(json['price'], '0'),
      oldPrice: _s(json['old_price'], '0'),
      withOption: _enum(json['with_option']),
      status: _enum(json['status']),
      market: marketRaw is Map
          ? OrderMarket.fromJson(Map<String, dynamic>.from(marketRaw))
          : const OrderMarket(
              id: 0,
              name: '',
              mainImage: '',
              locationTitle: '',
              contactPhone: '',
              contactWhatsapp: '',
              rating: '0',
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single Cart Item
// ---------------------------------------------------------------------------
class CartItem {
  final int id;
  final String price;
  final int quantity;
  final String total;
  final CartProduct product;
  final List<dynamic> values;

  const CartItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.total,
    required this.product,
    required this.values,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productRaw = json['product'];
    return CartItem(
      id: _i(json['id']),
      price: _s(json['price'], '0'),
      quantity: _i(json['quantity'], 1),
      total: _s(json['total'], '0'),
      product: productRaw is Map
          ? CartProduct.fromJson(Map<String, dynamic>.from(productRaw))
          : CartProduct.fromJson(const {}),
      values: json['values'] is List ? json['values'] as List<dynamic> : const [],
    );
  }
}

// ---------------------------------------------------------------------------
// Order Status Timeline Entry
// ---------------------------------------------------------------------------
class OrderStatusEntry {
  final int id;
  final EnumValue status;
  final String createdAt;

  const OrderStatusEntry({
    required this.id,
    required this.status,
    required this.createdAt,
  });

  factory OrderStatusEntry.fromJson(Map<String, dynamic> json) =>
      OrderStatusEntry(
        id: _i(json['id']),
        status: _enum(json['status']),
        createdAt: _s(json['created_at']),
      );
}

// ---------------------------------------------------------------------------
// Full Order Detail
// ---------------------------------------------------------------------------
class OrderDetail {
  final int id;
  final String qr;
  final bool isRated;
  final dynamic note;
  final String createdAt;
  final String total;
  final String deliveryPrice;
  final String subtotal;
  final String couponValue;
  final String discount;
  final String grandTotal;
  final String pointsCustomer;
  final String customerDiscount;
  final String date;
  final EnumValue deliveryType;
  final EnumValue status;
  final EnumValue paymentMethod;
  final dynamic address;
  final dynamic userCar;
  final dynamic driver;
  final OrderMarket market;
  final List<CartItem> carts;
  final List<OrderStatusEntry> orderStatuses;

  const OrderDetail({
    required this.id,
    required this.qr,
    required this.isRated,
    this.note,
    required this.createdAt,
    required this.total,
    required this.deliveryPrice,
    required this.subtotal,
    required this.couponValue,
    required this.discount,
    required this.grandTotal,
    required this.pointsCustomer,
    required this.customerDiscount,
    required this.date,
    required this.deliveryType,
    required this.status,
    required this.paymentMethod,
    this.address,
    this.userCar,
    this.driver,
    required this.market,
    required this.carts,
    required this.orderStatuses,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    final marketRaw = json['market'];
    final cartsRaw = json['carts'];
    final statusesRaw = json['order_statuses'];

    return OrderDetail(
      id: _i(json['id']),
      qr: _s(json['qr']),
      isRated: json['is_rated'] == true,
      note: json['note'],
      createdAt: _s(json['created_at']),
      total: _s(json['total'], '0'),
      deliveryPrice: _s(json['delivery_price'], '0'),
      subtotal: _s(json['subtotal'], '0'),
      couponValue: _s(json['coupon_value'], '0'),
      discount: _s(json['discount'], '0'),
      grandTotal: _s(json['grand_total'], '0'),
      pointsCustomer: _s(json['points_customer'], '0'),
      customerDiscount: _s(json['customer_discount'], '0'),
      date: _s(json['date']),
      deliveryType: _enum(json['delivery_type']),
      status: _enum(json['status']),
      paymentMethod: _enum(json['payment_method']),
      address: json['address'],
      userCar: json['userCar'],
      driver: json['driver'],
      market: marketRaw is Map
          ? OrderMarket.fromJson(Map<String, dynamic>.from(marketRaw))
          : const OrderMarket(
              id: 0,
              name: '',
              mainImage: '',
              locationTitle: '',
              contactPhone: '',
              contactWhatsapp: '',
              rating: '0',
            ),
      carts: cartsRaw is List
          ? cartsRaw
              .whereType<Map>()
              .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
      orderStatuses: statusesRaw is List
          ? statusesRaw
              .whereType<Map>()
              .map(
                (e) => OrderStatusEntry.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList()
          : const [],
    );
  }

  /// Lightweight map for payment screen hydration.
  Map<String, dynamic> toPaymentArgsMap() => {
        'id': id,
        'total': total,
        'subtotal': subtotal,
        'delivery_price': deliveryPrice,
        'coupon_value': couponValue,
        'discount': discount,
        'customer_discount': customerDiscount,
        'points_customer': pointsCustomer,
        'grand_total': grandTotal,
        'delivery_type': {
          'value': deliveryType.value,
          'desc': deliveryType.desc,
        },
        'payment_method': {
          'value': paymentMethod.value,
          'desc': paymentMethod.desc,
        },
        'market': {
          'id': market.id,
          'name': market.name,
          'main_image': market.mainImage,
        },
        if (address is Map) 'address': address,
        if (userCar is Map) 'userCar': userCar,
      };
}

// ---------------------------------------------------------------------------
// OrderDetailData — the `data` node
// ---------------------------------------------------------------------------
class OrderDetailData {
  final OrderDetail order;

  const OrderDetailData({required this.order});

  factory OrderDetailData.fromJson(Map<String, dynamic> json) {
    final orderRaw = json['order'];
    if (orderRaw is! Map) {
      throw FormatException('Missing order in detail response');
    }
    return OrderDetailData(
      order: OrderDetail.fromJson(Map<String, dynamic>.from(orderRaw)),
    );
  }
}

// ---------------------------------------------------------------------------
// OrderDetailResponse — top-level API wrapper
// ---------------------------------------------------------------------------
class OrderDetailResponse {
  final String status;
  final String message;
  final OrderDetailData? data;

  const OrderDetailResponse({
    required this.status,
    required this.message,
    this.data,
  });

  bool get isSuccess => status == 'success' && data != null;

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    final dataRaw = json['data'];
    OrderDetailData? data;
    if (dataRaw is Map && dataRaw['order'] != null) {
      data = OrderDetailData.fromJson(Map<String, dynamic>.from(dataRaw));
    }
    return OrderDetailResponse(
      status: _s(json['status']),
      message: _s(json['message']),
      data: data,
    );
  }
}
