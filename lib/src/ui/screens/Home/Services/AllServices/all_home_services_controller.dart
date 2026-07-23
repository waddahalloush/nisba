import 'package:get/get.dart';

import '../../../../../../generated/assets.gen.dart';
import '../../../../../data/models/home_category_model.dart';
import '../../../../../routes/routes_names.dart';

class AllHomeServicesController extends GetxController {
  @override
  void onInit() {
    _initServices();
    super.onInit();
  }

  final RxList<HomeCategoryModel> homeServiceList = <HomeCategoryModel>[].obs;
  void _initServices() {
    homeServiceList.assignAll([
      HomeCategoryModel(
        catName: 'الترفيه',
        catIcon: Assets.images.serv1.path,
        onTap: () => Get.toNamed(AppRoutesNames.entertain),
      ),
      HomeCategoryModel(
        catName: 'الهدايا',
        catIcon: Assets.images.serv2.path,
        onTap: () => Get.toNamed(AppRoutesNames.gift),
      ),
      HomeCategoryModel(
        catName: 'السياحة',
        catIcon: Assets.images.serv3.path,
        onTap: () => Get.toNamed(AppRoutesNames.tourism),
      ),
      HomeCategoryModel(
        catName: 'الأسواق',
        catIcon: Assets.images.serv6.path,
        onTap: () => Get.toNamed(AppRoutesNames.market),
      ),
      HomeCategoryModel(
        catName: 'kioks',
        catIcon: Assets.images.serv9.path,
        onTap: () => Get.toNamed(AppRoutesNames.kioks),
      ),
      HomeCategoryModel(
        catName: 'الفنادق',
        catIcon: Assets.images.serv5.path,
        onTap: () => Get.toNamed(AppRoutesNames.hotel),
      ),
      HomeCategoryModel(
        catName: 'المولات',
        catIcon: Assets.images.serv7.path,
        onTap: () => Get.toNamed(AppRoutesNames.mall),
      ),
      HomeCategoryModel(
        catName: 'التجميل',
        catIcon: Assets.images.serv8.path,
        onTap: () => Get.toNamed(AppRoutesNames.beauty),
      ),
    ]);
  }
}
