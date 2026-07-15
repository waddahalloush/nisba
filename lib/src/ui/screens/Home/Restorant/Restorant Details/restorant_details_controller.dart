import 'package:get/get.dart';

import '../../../../../data/models/restorant_model.dart';

class MealItem {
  final String name;
  final String description;
  final double price;
  final int orders;

  const MealItem({
    required this.name,
    required this.description,
    required this.price,
    required this.orders,
  });
}

class RestorantDetailsController extends GetxController {
  final RestorantModel restorant = Get.arguments;
  final selectedTab = 0.obs;

  final tabs = ['الوجبات', 'المشروبات', 'المقبلات', 'الإضافات'];

  final meals = <MealItem>[
    const MealItem(
      name: 'تندر باكيت',
      description: '30 قطعة ستربس مع بوكس بطاطا ولتر بيبسي',
      price: 110.00,
      orders: 3,
    ),
    const MealItem(
      name: 'وجبة مشاركة',
      description: '8 قطع دجاج و 8 قطع ستربس',
      price: 65.00,
      orders: 10,
    ),
  ];

  void selectTab(int index) => selectedTab.value = index;

  void orderNow() {
    Get.snackbar('تم', 'جاري إضافة الطلب...');
  }
}
