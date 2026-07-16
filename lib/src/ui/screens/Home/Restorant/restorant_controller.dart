import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';

import '../../../../data/models/restorant_model.dart';

class RestorantController extends GetxController {
  final categoryTitle = 'مطاعم'.obs;
  final nearbyTitle = 'المطاعم القريبة منك'.obs;
  final restorantTitle = 'أشهر المطاعم'.obs;

  final categories = <Map<String, dynamic>>[
    {'icon': Assets.images.resCat1.path, 'label': 'حلويات'},
    {'icon': Assets.images.resCat2.path, 'label': 'صحي'},
    {'icon': Assets.images.resCat3.path, 'label': 'بحري'},
    {'icon': Assets.images.resCat4.path, 'label': 'مشاوي'},
    {'icon': Assets.images.resCat5.path, 'label': 'بيتزا'},
    {'icon': Assets.images.resCat6.path, 'label': 'برجر'},
  ];

  final restaurants = <RestorantModel>[
    RestorantModel(
      name: 'برجر فاكتوري',
      rating: 4.5,
      deliveryTime: '30-20 د',
      distance: '1.1 كم',
      imagePath: Assets.images.resBurger.path,
      isFavorite: false,
    ),
    RestorantModel(
      name: 'مشاوي الخليج',
      rating: 4.7,
      deliveryTime: '40-30 د',
      distance: '1.8 كم',
      imagePath: Assets.images.resMeat.path,
      isFavorite: false,
    ),
    RestorantModel(
      name: 'بيتزا هت',
      rating: 4.4,
      deliveryTime: '35-25 د',
      distance: '1.5 كم',
      imagePath: Assets.images.resPizza.path,
      isFavorite: false,
    ),
    RestorantModel(
      name: 'بحري',
      rating: 4.6,
      deliveryTime: '45-20 د',
      distance: '1.2 كم',
      imagePath: Assets.images.resSea.path,
      isFavorite: false,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    final String type;
    if (args is Map) {
      type = args['title'] as String? ?? 'مطاعم';
    } else if (args is String) {
      type = args;
    } else {
      type = 'مطاعم';
    }
    setCategory(type);
  }

  void setCategory(String type) {
    categoryTitle.value = type;
    switch (type) {
      case 'مطاعم':
        nearbyTitle.value = 'المطاعم القريبة منك';
        restorantTitle.value = 'أشهر المطاعم';
        break;
      case 'بقالة':
        nearbyTitle.value = 'البقالات القريبة منك';
        restorantTitle.value = 'أشهر البقالات';
        break;
      case 'مقاهي':
        nearbyTitle.value = 'المقاهي القريبة منك';
        restorantTitle.value = 'أشهر المقاهي';
        break;
      default:
        nearbyTitle.value = '$type القريبة منك';
        restorantTitle.value = 'أشهر $type';
    }
  }
}
