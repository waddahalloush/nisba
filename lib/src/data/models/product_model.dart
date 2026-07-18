class Product {
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
}
