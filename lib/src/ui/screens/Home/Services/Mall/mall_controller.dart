import 'package:get/get.dart';

/// Data model for a mall.
class Mall {
  final String name;
  final String imageUrl;
  final String address;
  final double rating;
  final int stores;
  final int restaurants;
  final bool hasCinema;
  final String distance;
  final String? hours;
  final String category;

  const Mall({
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.stores,
    required this.restaurants,
    required this.hasCinema,
    required this.distance,
    this.hours,
    required this.category,
  });
}

class MallController extends GetxController {
  // ── Reactive state ──
  final searchQuery = ''.obs;
  final selectedCategory = 'الكل'.obs;
  final isLoading = false.obs;

  // ── Category list ──
  final categories = <String>['الكل', 'ترفيه', 'مطاعم', 'أزياء', 'إلكترونيات'];

  // ── Featured malls ──
  final featuredMalls = <Mall>[
    const Mall(
      name: 'قطر مول',
      imageUrl: '',
      address: 'طريق الدوحة السريع',
      rating: 4.8,
      stores: 350,
      restaurants: 50,
      hasCinema: true,
      distance: '2.5 كم',
      hours: '10:00 ص - 12:00 م',
      category: 'الكل',
    ),
    const Mall(
      name: 'لاند مارك مول',
      imageUrl: '',
      address: 'طريق سلوى',
      rating: 4.6,
      stores: 280,
      restaurants: 35,
      hasCinema: true,
      distance: '5.0 كم',
      hours: '9:00 ص - 11:00 م',
      category: 'الكل',
    ),
    const Mall(
      name: 'جلف مول',
      imageUrl: '',
      address: 'منطقة الخليج الغربي',
      rating: 4.5,
      stores: 200,
      restaurants: 30,
      hasCinema: false,
      distance: '3.2 كم',
      hours: '10:00 ص - 10:00 م',
      category: 'الكل',
    ),
  ];

  // ── All malls ──
  final allMalls = <Mall>[
    const Mall(
      name: 'قطر مول',
      imageUrl: '',
      address: 'طريق الدوحة السريع، الريان',
      rating: 4.8,
      stores: 350,
      restaurants: 50,
      hasCinema: true,
      distance: '2.5 كم',
      category: 'ترفيه',
    ),
    const Mall(
      name: 'لاند مارك مول',
      imageUrl: '',
      address: 'طريق سلوى، أبو هامور',
      rating: 4.6,
      stores: 280,
      restaurants: 35,
      hasCinema: true,
      distance: '5.0 كم',
      category: 'أزياء',
    ),
    const Mall(
      name: 'جلف مول',
      imageUrl: '',
      address: 'منطقة الخليج الغربي، الدوحة',
      rating: 4.5,
      stores: 200,
      restaurants: 30,
      hasCinema: false,
      distance: '3.2 كم',
      category: 'ترفيه',
    ),
    const Mall(
      name: 'فيلاجيو مول',
      imageUrl: '',
      address: 'منطقة أسباير زون، الدوحة',
      rating: 4.7,
      stores: 220,
      restaurants: 45,
      hasCinema: true,
      distance: '4.1 كم',
      category: 'ترفيه',
    ),
    const Mall(
      name: 'مول قطر',
      imageUrl: '',
      address: 'طريق سلوى، الريان',
      rating: 4.4,
      stores: 190,
      restaurants: 28,
      hasCinema: true,
      distance: '6.3 كم',
      category: 'مطاعم',
    ),
    const Mall(
      name: 'إزدان مول',
      imageUrl: '',
      address: 'الوكرة، الدوحة',
      rating: 4.3,
      stores: 150,
      restaurants: 22,
      hasCinema: false,
      distance: '8.0 كم',
      category: 'إلكترونيات',
    ),
    const Mall(
      name: 'سيتي سنتر الدوحة',
      imageUrl: '',
      address: 'منطقة الدفنة، الدوحة',
      rating: 4.5,
      stores: 300,
      restaurants: 40,
      hasCinema: true,
      distance: '3.8 كم',
      category: 'أزياء',
    ),
    const Mall(
      name: 'الحزم مول',
      imageUrl: '',
      address: 'منطقة اللؤلؤة، الدوحة',
      rating: 4.6,
      stores: 100,
      restaurants: 25,
      hasCinema: false,
      distance: '2.9 كم',
      category: 'مطاعم',
    ),
  ];

  /// Filtered list based on search & selected category.
  List<Mall> get filteredMalls {
    var list = allMalls;
    if (selectedCategory.value != 'الكل') {
      list = list.where((m) => m.category == selectedCategory.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (m) =>
                m.name.contains(searchQuery.value) ||
                m.address.contains(searchQuery.value),
          )
          .toList();
    }
    return list;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
