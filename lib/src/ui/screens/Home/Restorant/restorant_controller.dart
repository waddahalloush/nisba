import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../data/models/restorant_model.dart';



class RestorantController extends GetxController {
  final categoryTitle = ''.obs;
  final nearbyTitle = ''.obs;

  final categories = <Map<String, dynamic>>[
    {'icon': Iconsax.bank, 'label': 'برجر'},
    {'icon': Iconsax.cake, 'label': 'بيتزا'},
    {'icon': Iconsax.coffee, 'label': 'مشاوي'},
    {'icon': Iconsax.fatrows, 'label': 'بحري'},
    {'icon': Iconsax.heart_circle, 'label': 'صحي'},
    {'icon': Iconsax.cup, 'label': 'حلويات'},
  ];

  final restaurants = <RestorantModel>[
    const RestorantModel(
      name: 'بحري',
      rating: 4.5,
      deliveryTime: '25-35 دقيقة',
      distance: '1.2 كم',
    ),
    const RestorantModel(
      name: 'بيتزا هت',
      rating: 4.2,
      deliveryTime: '20-30 دقيقة',
      distance: '0.8 كم',
    ),
    const RestorantModel(
      name: 'مشاوي الخليج',
      rating: 4.0,
      deliveryTime: '30-40 دقيقة',
      distance: '1.5 كم',
    ),
    const RestorantModel(
      name: 'برجر فاكتوري',
      rating: 4.6,
      deliveryTime: '15-25 دقيقة',
      distance: '2.0 كم',
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    final type = Get.arguments as String? ?? 'مطاعم';
    setCategory(type);
  }

  void setCategory(String type) {
    categoryTitle.value = type;
    switch (type) {
      case 'مطاعم':
        nearbyTitle.value = 'المطاعم القريبة منك';
        break;
      case 'بقالة':
        nearbyTitle.value = 'البقالات القريبة منك';
        break;
      case 'مقاهي':
        nearbyTitle.value = 'المقاهي القريبة منك';
        break;
      default:
        nearbyTitle.value = '$type القريبة منك';
    }
  }
}
