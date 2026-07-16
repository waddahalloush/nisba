import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';

class OfferItem {
  final String name;
  final double price;
  final double? oldPrice;
  final String imagePath;
  final bool isPopular;
  final String prepTime;

  const OfferItem({
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imagePath,
    this.isPopular = false,
    this.prepTime = '0-0 دقيقة',
  });
}

class OfferRestaurant {
  final String name;
  final double rating;
  final int reviewsCount;
  final String logoPath;
  final String discountTitle;
  final String discountDesc;
  final String deliveryTitle;
  final String deliveryDesc;
  final String deliveryTime;
  final String deliveryBy;
  final int satisfactionRate;
  final List<OfferItem> items;

  const OfferRestaurant({
    required this.name,
    required this.rating,
    required this.reviewsCount,
    required this.logoPath,
    required this.discountTitle,
    required this.discountDesc,
    required this.deliveryTitle,
    required this.deliveryDesc,
    required this.deliveryTime,
    required this.deliveryBy,
    required this.satisfactionRate,
    required this.items,
  });
}

class OfferController extends GetxController {
  final selectedTab = 0.obs;
  final location = 'شارع الملك فهد'.obs;

  final restaurants = <OfferRestaurant>[
    OfferRestaurant(
      name: 'عز الشام',
      rating: 3.0,
      reviewsCount: 3,
      logoPath: Assets.images.azSham.path,
      discountTitle: 'قيمة الخصم',
      discountDesc: '15% على جميع العروض',
      deliveryTitle: 'توصيل مجاني',
      deliveryDesc: 'للطلبات فوق 30 ريال',
      deliveryTime: '30 دقيقة',
      deliveryBy: 'Nisbaa',
      satisfactionRate: 92,
      items: [
        OfferItem(
          name: 'شاورما دجاج',
          price: 23.00,
          oldPrice: 25.00,
          imagePath: Assets.images.offer3.path,
        ),
        OfferItem(
          name: 'شاورما دجاج صحن كبير',
          price: 45.00,
          oldPrice: 50.00,
          imagePath: Assets.images.offer2.path,
          isPopular: true,
        ),
        OfferItem(
          name: 'شيش طاووق',
          price: 30.00,
          imagePath: Assets.images.offer1.path,
        ),
      ],
    ),
    OfferRestaurant(
      name: 'هارديز',
      rating: 0.0,
      reviewsCount: 0,
      logoPath: Assets.images.burgerLand.path,
      discountTitle: 'قيمة الخصم',
      discountDesc: '10% على الطلب الأول',
      deliveryTitle: 'توصيل 10.00 ريال',
      deliveryDesc: 'للطلبات تحت 30 ريال',
      deliveryTime: '30 دقيقة',
      deliveryBy: 'Nisbaa',
      satisfactionRate: 88,
      items: [
        OfferItem(
          name: 'زنجر برجر',
          price: 28.00,
          oldPrice: 32.00,
          imagePath: Assets.images.zinger.path,
        ),
        OfferItem(
          name: 'تشيكن برجر',
          price: 22.00,
          oldPrice: 25.00,
          imagePath: Assets.images.crispy.path,
        ),
        OfferItem(
          name: 'راب الدجاج الحار',
          price: 18.00,
          oldPrice: 20.00,
          imagePath: Assets.images.catFood.path,
        ),
      ],
    ),
  ];

  void selectTab(int index) => selectedTab.value = index;
}

