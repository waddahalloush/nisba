class RestorantModel {
  final int? id;
  final String name;
  final String description;
  final double rating;
  final String deliveryTime;
  final String distance;
  final String imagePath;
  final bool isFavorite;
  final bool isOpen;
  final double? deliveryPrice;

  /// Backend keys: to_home, at_provider, book_table, to_car, throw_in, all
  final List<String> deliveryTypes;
  final List<String> paymentMethods;
  final String serviceType; // 'store' | 'kioks' | 'restaurant'

  const RestorantModel({
    this.id,
    required this.name,
    this.description = '',
    required this.rating,
    required this.deliveryTime,
    required this.distance,
    required this.imagePath,
    this.isFavorite = false,
    this.isOpen = true,
    this.deliveryPrice,
    this.deliveryTypes = const [],
    this.paymentMethods = const [],
    this.serviceType = 'restaurant',
  });

  RestorantModel copyWith({
    int? id,
    String? name,
    String? description,
    double? rating,
    String? deliveryTime,
    String? distance,
    String? imagePath,
    bool? isFavorite,
    bool? isOpen,
    double? deliveryPrice,
    List<String>? deliveryTypes,
    List<String>? paymentMethods,
    String? serviceType,
  }) => RestorantModel(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    rating: rating ?? this.rating,
    deliveryTime: deliveryTime ?? this.deliveryTime,
    distance: distance ?? this.distance,
    imagePath: imagePath ?? this.imagePath,
    isFavorite: isFavorite ?? this.isFavorite,
    isOpen: isOpen ?? this.isOpen,
    deliveryPrice: deliveryPrice ?? this.deliveryPrice,
    deliveryTypes: deliveryTypes ?? this.deliveryTypes,
    paymentMethods: paymentMethods ?? this.paymentMethods,
    serviceType: serviceType ?? this.serviceType,
  );

  static List<String> _parseStringList(dynamic raw) {
    if (raw is! List) return [];
    return raw.map((e) => e.toString()).where((e) => e.isNotEmpty).toList();
  }

  factory RestorantModel.fromApiMap(Map raw, {String fallbackImage = ''}) {
    final map = Map<String, dynamic>.from(raw);
    return RestorantModel(
      id: int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      deliveryTime: map['preparation_time']?.toString() ?? '',
      distance: map['distance']?.toString() ?? '',
      imagePath:
          map['main_image']?.toString() ??
          map['image']?.toString() ??
          map['logo']?.toString() ??
          fallbackImage,
      isFavorite: map['is_fav'] == true || map['is_fav'] == 1,
      isOpen: map['is_open'] == true || map['is_open'] == 1,
      deliveryPrice: double.tryParse(map['delivery_price']?.toString() ?? ''),
      deliveryTypes: _parseStringList(map['delivery_types']),
      paymentMethods: _parseStringList(map['payment_methods']),
      serviceType:
          map['service_type']?.toString() ??
          map['market_type']?.toString() ??
          'restaurant',
    );
  }
}
