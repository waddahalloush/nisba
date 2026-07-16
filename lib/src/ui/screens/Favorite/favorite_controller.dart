import 'package:get/get.dart';

import '../../../../generated/assets.gen.dart';

class FavoriteItem {
  final String imageUrl;
  final String name;
  final double rating;
  final List<String> tags;
  final String deliveryTime;
  final bool isLiked;

  const FavoriteItem({
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.tags,
    required this.deliveryTime,
    this.isLiked = true,
  });
}

class FavoriteController extends GetxController {
  final selectedTab = 0.obs; // 0 = restaurants, 1 = meals

  final restaurants = <FavoriteItem>[
    FavoriteItem(
      imageUrl: Assets.images.azSham.path,
      name: 'عز الشام',
      rating: 3.0,
      tags: ['مشويات', 'عربي'],
      deliveryTime: '30-40 دقيقة',
    ),
    FavoriteItem(
      imageUrl: Assets.images.burgerLand.path,
      name: 'برجر لاند',
      rating: 4.2,
      tags: ['برجر', 'أمريكي'],
      deliveryTime: '20-30 دقيقة',
    ),
    FavoriteItem(
      imageUrl: Assets.images.pastaItaly.path,
      name: 'باستا إيطاليا',
      rating: 4.6,
      tags: ['إيطالي', 'باستا'],
      deliveryTime: '25-35 دقيقة',
    ),
  ];

  final meals = <FavoriteItem>[
    FavoriteItem(
      imageUrl: Assets.images.kfc.path,
      name: 'دجاج كنتاكي',
      rating: 4.7,
      tags: ['مقرمش', 'حار', 'أمريكي'],
      deliveryTime: '20-30 دقيقة',
    ),
    FavoriteItem(
      imageUrl: Assets.images.zinger.path,
      name: 'زنجر',
      rating: 4.5,
      tags: ['حار', 'مقرمش', 'أمريكي'],
      deliveryTime: '20-30 دقيقة',
    ),
    FavoriteItem(
      imageUrl: Assets.images.crispy.path,
      name: 'كريسبي',
      rating: 4.6,
      tags: ['مقرمش', 'حار', 'أمريكي'],
      deliveryTime: '20-30 دقيقة',
    ),
  ];

  List<FavoriteItem> get currentItems =>
      selectedTab.value == 0 ? restaurants : meals;

  void selectTab(int index) => selectedTab.value = index;

  void toggleLike(int index) {
    final items = selectedTab.value == 0 ? restaurants : meals;
    // Items are const, so in real app you'd update a mutable list
  }
}
