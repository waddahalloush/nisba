// ignore_for_file: public_member_api_docs

import 'package:get/get.dart';

/// نموذج بيانات المطعم/الشريك
class PartnerModel {
  final String name;
  final String imageUrl;
  final double rating;
  final String location;
  final String promotion;
  final double distanceKm;
  final PartnerType type;
  final bool isFavorite;

  const PartnerModel({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.location,
    required this.promotion,
    required this.distanceKm,
    required this.type,
    this.isFavorite = false,
  });
}

/// نوع الشريك
enum PartnerType {
  restaurant,
  cafe,
  grocery,
  healthy,
  service;

  String get label {
    switch (this) {
      case PartnerType.restaurant:
        return 'مطعم';
      case PartnerType.cafe:
        return 'مقهى';
      case PartnerType.grocery:
        return 'بقالة';
      case PartnerType.healthy:
        return 'صحي';
      case PartnerType.service:
        return 'خدمة';
    }
  }
}

/// صور Unsplash للأصناف
class _UnsplashImages {
  static const String seafood =
      'https://images.unsplash.com/photo-1559742811-822f208b32b3?w=400&h=300&fit=crop';
  static const String asian =
      'https://images.unsplash.com/photo-1552566626-52f8b828add9?w=400&h=300&fit=crop';
  static const String burger =
      'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=300&fit=crop';
  static const String breakfast =
      'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=300&fit=crop';
  static const String cafe =
      'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?w=400&h=300&fit=crop';
  static const String pizza =
      'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop';
  static const String grocery =
      'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&h=300&fit=crop';
  static const String pharmacy =
      'https://images.unsplash.com/photo-1576602976047-174e57a47881?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGhhcm1hY3l8ZW58MHx8MHx8fDA%3D';
}

class SearchhController extends GetxController {
  // ---- Observable State ----

  /// تفعيل عرض الخريطة
  final isMapView = false.obs;

  /// التبويب الرئيسي المختار (0=الكل, 1=المطاعم, 2=الخدمات)
  final selectedMainTab = 0.obs;

  /// التبويب الفرعي المختار (0=صحي, 1=مقاهي, 2=بقالة, 3=مطاعم)
  final selectedSubTab = 0.obs;

  /// خيار الترتيب (تصاعدي / تنازلي)
  final selectedSort = 'تصاعدي'.obs;

  // ---- Mock Data ----

  late final RxList<PartnerModel> allPartners;
  late final List<PartnerModel> nearbyPartners;

  /// قائمة المطاعم/الشركاء المفلترة حسب التبويبات
  List<PartnerModel> get filteredPartners {
    List<PartnerModel> list = allPartners.toList();

    // فلترة التبويب الرئيسي
    if (selectedMainTab.value == 1) {
      list = list.where((p) => p.type == PartnerType.restaurant).toList();
    } else if (selectedMainTab.value == 2) {
      list = list.where((p) => p.type == PartnerType.service).toList();
    }

    // فلترة التبويب الفرعي
    if (selectedSubTab.value == 0) {
      list = list.where((p) => p.type == PartnerType.healthy).toList();
    } else if (selectedSubTab.value == 1) {
      list = list.where((p) => p.type == PartnerType.cafe).toList();
    } else if (selectedSubTab.value == 2) {
      list = list.where((p) => p.type == PartnerType.grocery).toList();
    } else if (selectedSubTab.value == 3) {
      list = list.where((p) => p.type == PartnerType.restaurant).toList();
    }

    return list;
  }

  @override
  void onInit() {
    super.onInit();
    allPartners = _buildPartners().obs;
    nearbyPartners = _buildNearbyPartners();
  }

  // ---- Actions ----

  void toggleMapView() {
    isMapView.toggle();
  }

  void setMapView(bool value) {
    isMapView.value = value;
  }

  void setSort(String value) {
    selectedSort.value = value;
  }

  void selectMainTab(int index) {
    selectedMainTab.value = index;
  }

  void selectSubTab(int index) {
    selectedSubTab.value = index;
  }

  void toggleFavorite(int index) {
    final partner = allPartners[index];
    allPartners[index] = PartnerModel(
      name: partner.name,
      imageUrl: partner.imageUrl,
      rating: partner.rating,
      location: partner.location,
      promotion: partner.promotion,
      distanceKm: partner.distanceKm,
      type: partner.type,
      isFavorite: !partner.isFavorite,
    );
  }

  // ---- Mock Data Builders ----

  static List<PartnerModel> _buildPartners() {
    return [
      const PartnerModel(
        name: 'البحر الصغير',
        imageUrl: _UnsplashImages.seafood,
        rating: 4.5,
        location: 'الدوحة، شارع الكورنيش',
        promotion: 'خصم 20% على المأكولات البحرية',
        distanceKm: 1.2,
        type: PartnerType.restaurant,
      ),
      const PartnerModel(
        name: 'صيدلية الحياة',
        imageUrl: _UnsplashImages.pharmacy,
        rating: 4.5,
        location: 'الدوحة، شارع الكورنيش',
        promotion: 'خصم 20% على الأدوية المسكنة',
        distanceKm: 1.2,
        type: PartnerType.healthy,
      ),
      const PartnerModel(
        name: 'ماندرين',
        imageUrl: _UnsplashImages.asian,
        rating: 4.3,
        location: 'الدوحة، مشيرب قلب الدوحة',
        promotion: 'خصم 15% على الطلبات أكثر من 100 ر.ق',
        distanceKm: 2.5,
        type: PartnerType.restaurant,
      ),
      const PartnerModel(
        name: 'هارديز',
        imageUrl: _UnsplashImages.burger,
        rating: 4.2,
        location: 'الدوحة، طريق سلوى',
        promotion: 'وجبة مجانية مع أي طلب أكثر من 50 ر.ق',
        distanceKm: 3.1,
        type: PartnerType.restaurant,
      ),
      const PartnerModel(
        name: 'الشرق',
        imageUrl: _UnsplashImages.breakfast,
        rating: 4.6,
        location: 'الدوحة، شارع المطار القديم',
        promotion: 'خصم 25% على الإفطار',
        distanceKm: 4.0,
        type: PartnerType.restaurant,
      ),
      const PartnerModel(
        name: 'مقهى القهوة المختصة',
        imageUrl: _UnsplashImages.cafe,
        rating: 4.7,
        location: 'الدوحة، اللؤلؤة',
        promotion: 'خصم 10% على جميع المشروبات',
        distanceKm: 0.8,
        type: PartnerType.cafe,
      ),
      const PartnerModel(
        name: 'بيتزا هت',
        imageUrl: _UnsplashImages.pizza,
        rating: 4.0,
        location: 'الدوحة، الريان',
        promotion: 'اشترِ واحدة واحصل على الثانية مجاناً',
        distanceKm: 1.2,
        type: PartnerType.restaurant,
      ),
      const PartnerModel(
        name: 'بقالة الرفاهية',
        imageUrl: _UnsplashImages.grocery,
        rating: 3.9,
        location: 'الدوحة، السد',
        promotion: 'توصيل مجاني للطلبات فوق 200 ر.ق',
        distanceKm: 2.0,
        type: PartnerType.grocery,
      ),
    ];
  }

  static List<PartnerModel> _buildNearbyPartners() {
    return [
      const PartnerModel(
        name: 'مقهى القهوة المختصة',
        imageUrl: _UnsplashImages.cafe,
        rating: 4.7,
        location: 'الدوحة، اللؤلؤة',
        promotion: '',
        distanceKm: 0.8,
        type: PartnerType.cafe,
      ),
      const PartnerModel(
        name: 'بيتزا هت',
        imageUrl: _UnsplashImages.pizza,
        rating: 4.0,
        location: 'الدوحة، الريان',
        promotion: '',
        distanceKm: 1.2,
        type: PartnerType.restaurant,
      ),
      const PartnerModel(
        name: 'هارديز',
        imageUrl: _UnsplashImages.burger,
        rating: 4.2,
        location: 'الدوحة، طريق سلوى',
        promotion: '',
        distanceKm: 1.4,
        type: PartnerType.restaurant,
      ),
    ];
  }
}
