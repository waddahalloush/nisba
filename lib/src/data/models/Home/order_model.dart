import 'home_model.dart';
import 'notification_model.dart';

String _s(dynamic v, [String d = '']) => v?.toString() ?? d;

int _i(dynamic v, [int d = 0]) => int.tryParse(v?.toString() ?? '') ?? d;

double _d(dynamic v, [double d = 0]) =>
    double.tryParse(v?.toString() ?? '') ?? d;

EnumValue _enum(dynamic raw) {
  if (raw is Map) {
    return EnumValue(
      value: raw['value']?.toString() ?? '',
      desc: raw['desc']?.toString() ?? raw['value']?.toString() ?? '',
    );
  }
  return EnumValue(value: raw?.toString() ?? '', desc: raw?.toString() ?? '');
}

// ---------------------------------------------------------------------------
// Simplified Market inside an Order
// ---------------------------------------------------------------------------
class OrderMarket {
  final int id;
  final String name;
  final String mainImage;
  final String locationTitle;
  final String contactPhone;
  final String contactWhatsapp;
  final String rating;

  const OrderMarket({
    required this.id,
    required this.name,
    required this.mainImage,
    required this.locationTitle,
    required this.contactPhone,
    required this.contactWhatsapp,
    required this.rating,
  });

  factory OrderMarket.fromJson(Map<String, dynamic> json) => OrderMarket(
    id: _i(json['id']),
    name: _s(json['name']),
    mainImage: _s(json['main_image']),
    locationTitle: _s(json['location_title']),
    contactPhone: _s(json['contact_phone']),
    contactWhatsapp: _s(json['contact_whatsapp']),
    rating: _s(json['rating'], '0'),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'main_image': mainImage,
    'location_title': locationTitle,
    'contact_phone': contactPhone,
    'contact_whatsapp': contactWhatsapp,
    'rating': rating,
  };
}

// ---------------------------------------------------------------------------
// Single Order (list item)
// ---------------------------------------------------------------------------
class OrderItem {
  final int id;
  final String date;
  final EnumValue status;
  final EnumValue deliveryType;
  final String grandTotal;
  final OrderMarket market;
  final String createdAt;

  const OrderItem({
    required this.id,
    required this.date,
    required this.status,
    required this.deliveryType,
    required this.grandTotal,
    required this.market,
    required this.createdAt,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    final marketRaw = json['market'];
    return OrderItem(
      id: _i(json['id']),
      date: _s(json['date']),
      status: _enum(json['status']),
      deliveryType: _enum(json['delivery_type']),
      grandTotal: _s(json['grand_total'], '0'),
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
      createdAt: _s(json['created_at']),
    );
  }
}

// ---------------------------------------------------------------------------
// OrdersData — the `data` node
// ---------------------------------------------------------------------------
class OrdersData {
  final List<OrderItem> orders;
  final Pagination pagination;

  const OrdersData({required this.orders, required this.pagination});

  factory OrdersData.fromJson(Map<String, dynamic> json) {
    final list = json['orders'];
    final orders = <OrderItem>[];
    if (list is List) {
      for (final e in list) {
        if (e is Map) {
          orders.add(OrderItem.fromJson(Map<String, dynamic>.from(e)));
        }
      }
    }
    final pagRaw = json['pagination'];
    return OrdersData(
      orders: orders,
      pagination: pagRaw is Map
          ? Pagination.fromJson(Map<String, dynamic>.from(pagRaw))
          : const Pagination(
              total: 0,
              count: 0,
              perPage: 10,
              currentPage: 1,
              totalPages: 1,
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// OrderResponse — top-level API wrapper
// ---------------------------------------------------------------------------
class OrderResponse {
  final String status;
  final String message;
  final OrdersData data;

  const OrderResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  bool get isSuccess => status == 'success';

  factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
    status: _s(json['status']),
    message: _s(json['message']),
    data: json['data'] is Map
        ? OrdersData.fromJson(Map<String, dynamic>.from(json['data'] as Map))
        : const OrdersData(
            orders: [],
            pagination: Pagination(
              total: 0,
              count: 0,
              perPage: 10,
              currentPage: 1,
              totalPages: 1,
            ),
          ),
  );
}
