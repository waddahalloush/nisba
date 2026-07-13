import 'package:get/get.dart';

class OfferItem {
  final String name;
  final double price;

  const OfferItem({required this.name, required this.price});
}

class OfferRestaurant {
  final String name;
  final double rating;
  final String discount;
  final String deliveryInfo;
  final List<OfferItem> items;

  const OfferRestaurant({
    required this.name,
    required this.rating,
    required this.discount,
    required this.deliveryInfo,
    required this.items,
  });
}

class OfferController extends GetxController {
  final selectedTab = 0.obs;
  final location = 'شارع الملك فهد'.obs;

  final restaurants = <OfferRestaurant>[
    const OfferRestaurant(
      name: 'عز الشام',
      rating: 3.0,
      discount: 'خصم 15% على جميع العروض',
      deliveryInfo: 'توصيل مجاني للطلبات فوق 30 ريال',
      items: [
        OfferItem(name: 'شاورما دجاج صحن كبير', price: 45.00),
        OfferItem(name: 'شاورما دجاج', price: 23.00),
        OfferItem(name: 'شيش طاووق', price: 30.00),
      ],
    ),
    const OfferRestaurant(
      name: 'هارديز',
      rating: 0.0,
      discount: 'خصم 10% على أول طلب',
      deliveryInfo: 'توصيل 10.00 ريال للطلبات تحت 30 ريال',
      items: [
        OfferItem(name: 'برجر دجاج', price: 22.00),
        OfferItem(name: 'برجر لحم', price: 28.00),
        OfferItem(name: 'بطاطس كبير', price: 10.00),
      ],
    ),
  ];

  void selectTab(int index) => selectedTab.value = index;
}
