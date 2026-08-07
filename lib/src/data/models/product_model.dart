class Product {
  final int? id;
  final int? marketId;
  final String name;
  final String description;
  final double price;
  final double oldPrice;
  final String savings;
  final String deliveryTime;
  final String distance;
  final String imagePath;
  final double rating;
  final int ratingCount;

  const Product({
    this.id,
    this.marketId,
    required this.name,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.savings,
    required this.deliveryTime,
    required this.distance,
    required this.imagePath,
    required this.rating,
    required this.ratingCount,
  });

  String get deliveryMeta => '$deliveryTime دقيقة • $distance كم';

  Product copyWith({
    int? id,
    int? marketId,
    String? name,
    String? description,
    double? price,
    double? oldPrice,
    String? savings,
    String? deliveryTime,
    String? distance,
    String? imagePath,
    double? rating,
    int? ratingCount,
  }) =>
      Product(
        id: id ?? this.id,
        marketId: marketId ?? this.marketId,
        name: name ?? this.name,
        description: description ?? this.description,
        price: price ?? this.price,
        oldPrice: oldPrice ?? this.oldPrice,
        savings: savings ?? this.savings,
        deliveryTime: deliveryTime ?? this.deliveryTime,
        distance: distance ?? this.distance,
        imagePath: imagePath ?? this.imagePath,
        rating: rating ?? this.rating,
        ratingCount: ratingCount ?? this.ratingCount,
      );

  factory Product.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final market = map['market'];
    int? marketId;
    if (market is Map) {
      marketId = int.tryParse(market['id']?.toString() ?? '');
    } else {
      marketId = int.tryParse(map['market_id']?.toString() ?? '');
    }
    final price = double.tryParse(map['price']?.toString() ?? '') ?? 0;
    final oldPrice = double.tryParse(map['old_price']?.toString() ?? '') ?? 0;
    final savings = oldPrice > price && oldPrice > 0
        ? 'وفر ${(oldPrice - price).toStringAsFixed(0)} ر.ق'
        : '';
    return Product(
      id: int.tryParse(map['id']?.toString() ?? ''),
      marketId: marketId,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: price,
      oldPrice: oldPrice,
      savings: savings,
      deliveryTime: map['preparation_time']?.toString() ?? '',
      distance: '',
      imagePath: map['image']?.toString() ?? map['main_image']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      ratingCount: int.tryParse(map['soldCount']?.toString() ?? '') ?? 0,
    );
  }
}
