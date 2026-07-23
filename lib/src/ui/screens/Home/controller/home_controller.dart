import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/data/models/home_category_model.dart';
import 'package:nisba_app/src/data/models/product_model.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

class HomeController extends GetxController {
  // متغير تفاعلي للتحكم في البانر النشط وتحديث الـ Dots Indicator بداخل الكارد
  final RxInt currentBannerIndex = 0.obs;

  // متحكم السكرول لتتبع موضع التمرير لأعلى
  late final ScrollController scrollController;

  // قيمة تفاعلية لموضع السكرول الحالي (تُستخدم لحساب التلاشي التدريجي)
  final RxDouble scrollOffset = 0.0.obs;

  // قائمة التصنيفات التفاعلية
  final RxList<HomeCategoryModel> homeCategoryList = <HomeCategoryModel>[].obs;
  final RxList<HomeCategoryModel> homeServiceList = <HomeCategoryModel>[].obs;

  // قوائم العروض والمنتجات
  final RxList<Product> dailyOfferList = <Product>[].obs;
  final RxList<Product> selectedForYouList = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    _initCategories();
    _initServices();
    _initDailyOffers();
    _initSelectedForYou();
  }

  void _initCategories() {
    homeCategoryList.assignAll([
      HomeCategoryModel(
        catName: 'مطاعم',
        catIcon: Assets.images.catFood.path,
        onTap: () => Get.toNamed(
          AppRoutesNames.restorant,
          arguments: {'title': 'المطاعم'},
        ),
      ),
      HomeCategoryModel(
        catName: 'بقالة',
        catIcon: Assets.images.catVigi.path,
        onTap: () => Get.toNamed(
          AppRoutesNames.restorant,
          arguments: {'title': 'بقالة'},
        ),
      ),
      HomeCategoryModel(
        catName: 'مقاهي',
        catIcon: Assets.images.catCafee.path,
        onTap: () => Get.toNamed(
          AppRoutesNames.restorant,
          arguments: {'title': 'مقاهي'},
        ),
      ),
      HomeCategoryModel(
        catName: 'العروض اليومية',
        catIcon: Assets.images.catOffer.path,
        onTap: () => Get.toNamed(AppRoutesNames.offer),
      ),
    ]);
  }

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
        catName: 'المزيد',
        catIcon: Assets.images.serv4.path,
        onTap: () => Get.toNamed(AppRoutesNames.allHomeServices),
      ),
    ]);
  }

  void _initDailyOffers() {
    dailyOfferList.assignAll([
      Product(
        name: 'شواية الخليج',
        description: 'شواية الخليج',
        price: 53,
        oldPrice: 76,
        savings: '25%',
        deliveryTime: '330',
        distance: '1.2',
        imagePath: Assets.images.offer1.path,
        rating: 4.8,
        ratingCount: 253,
      ),
      Product(
        name: 'سوشي يوشي',
        description: 'سوشي يوشي',
        price: 44,
        oldPrice: 59,
        savings: '25%',
        deliveryTime: '395',
        distance: '1.5',
        imagePath: Assets.images.offer2.path,
        rating: 4.8,
        ratingCount: 253,
      ),
      Product(
        name: 'باستا ريمو',
        description: 'باستا ريمو',
        price: 37,
        oldPrice: 49,
        savings: '25%',
        deliveryTime: '330',
        distance: '1.1',
        imagePath: Assets.images.offer3.path,
        rating: 4.8,
        ratingCount: 253,
      ),
    ]);
  }

  void _initSelectedForYou() {
    selectedForYouList.assignAll([
      Product(
        name: 'فاهيتا دجاج',
        description: 'فاهيتا النكهة السرية الحارة',
        price: 53,
        oldPrice: 76,
        savings: '25%',
        deliveryTime: '330',
        distance: '1.2',
        imagePath: Assets.images.homeForyou1.path,
        rating: 4.8,
        ratingCount: 253,
      ),
      Product(
        name: 'مندي حضرموت',
        description: 'مندي بالسمن العربي و المكسرات',
        price: 44,
        oldPrice: 59,
        savings: '25%',
        deliveryTime: '395',
        distance: '1.5',
        imagePath: Assets.images.homeForyou2.path,
        rating: 4.8,
        ratingCount: 253,
      ),
      Product(
        name: 'شاورما عربي',
        description: 'شاورما عربي دبل',
        price: 37,
        oldPrice: 49,
        savings: '25%',
        deliveryTime: '330',
        distance: '1.1',
        imagePath: Assets.images.homeForyou3.path,
        rating: 4.8,
        ratingCount: 253,
      ),
    ]);
  }

  void _onScroll() {
    scrollOffset.value = scrollController.hasClients
        ? scrollController.offset
        : 0.0;
  }

  void changeBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
