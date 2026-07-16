class RestorantModel {
  final String name;
  final double rating;
  final String deliveryTime;
  final String distance;
  final String imagePath;
  final bool isFavorite;

  const RestorantModel({
    required this.name,
    required this.rating,
    required this.deliveryTime,
    required this.distance,
    required this.imagePath,
    this.isFavorite = false,
  });
}