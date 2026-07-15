import 'package:get/get.dart';

/// Data model for a kiosk / zone location.
class Kiosk {
  final String name;
  final String imageUrl;
  final String city;
  final double rating;
  final int reviewCount;
  final String category;

  const Kiosk({
    required this.name,
    required this.imageUrl,
    required this.city,
    required this.rating,
    required this.reviewCount,
    required this.category,
  });
}

class KioksController extends GetxController {
  // ── Reactive state ──
  final searchQuery = ''.obs;
  final selectedCategory = 'الكل'.obs;
  final isLoading = false.obs;

  // ── Category list ──
  final categories = <String>['الكل', 'مطاعم ووجبات', 'مقاهي', 'تسوق', 'خدمات'];

  // ── All kiosks ──
  final allKiosks = <Kiosk>[
    const Kiosk(
      name: 'الرياض بارك',
      imageUrl: '',
      city: 'الرياض',
      rating: 4.7,
      reviewCount: 128,
      category: 'تسوق',
    ),
    const Kiosk(
      name: 'النخيل مول',
      imageUrl: '',
      city: 'الرياض',
      rating: 4.5,
      reviewCount: 95,
      category: 'مطاعم ووجبات',
    ),
    const Kiosk(
      name: 'السلام مول',
      imageUrl: '',
      city: 'الرياض',
      rating: 4.6,
      reviewCount: 73,
      category: 'تسوق',
    ),
    const Kiosk(
      name: 'غرناطة مول',
      imageUrl: '',
      city: 'الرياض',
      rating: 4.4,
      reviewCount: 64,
      category: 'مقاهي',
    ),
    const Kiosk(
      name: 'بانوراما مول',
      imageUrl: '',
      city: 'الرياض',
      rating: 4.3,
      reviewCount: 51,
      category: 'خدمات',
    ),
    const Kiosk(
      name: 'القصر مول',
      imageUrl: '',
      city: 'الرياض',
      rating: 4.2,
      reviewCount: 38,
      category: 'مطاعم ووجبات',
    ),
  ];

  /// Filtered list based on search & selected category.
  List<Kiosk> get filteredKiosks {
    var list = allKiosks;
    if (selectedCategory.value != 'الكل') {
      list = list.where((k) => k.category == selectedCategory.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (k) =>
                k.name.contains(searchQuery.value) ||
                k.city.contains(searchQuery.value),
          )
          .toList();
    }
    return list;
  }

  /// Top‑rated kiosks (sorted by rating descending).
  List<Kiosk> get topRatedKiosks {
    final sorted = allKiosks.toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));
    return sorted.take(4).toList();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
