import 'package:get/get.dart';

/// Data model for a hotel.
class Hotel {
  final String name;
  final String imageUrl;
  final String address;
  final double rating;
  final double price;
  final String distance;
  final List<String> amenities;

  const Hotel({
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.price,
    required this.distance,
    required this.amenities,
  });
}

class HotelController extends GetxController {
  // ── Reactive state ──
  final searchQuery = ''.obs;
  final selectedFilter = 'الكل'.obs;
  final isLoading = false.obs;

  // ── Filter list ──
  final filters = <String>[
    'الكل',
    'الأقرب إلي',
    'الأعلى تقييماً',
    'السعر',
    'المزيد',
  ];

  // ── All hotels ──
  final allHotels = <Hotel>[
    const Hotel(
      name: 'فندق الماسة',
      imageUrl: '',
      address: 'شارع الوعب، الدوحة',
      rating: 4.6,
      price: 340,
      distance: '2.4 كم',
      amenities: ['واي فاي مجاني', 'موقف سيارات', 'مسبح'],
    ),
    const Hotel(
      name: 'فندق الريان',
      imageUrl: '',
      address: 'طريق سلوى، الدوحة',
      rating: 4.5,
      price: 420,
      distance: '3.1 كم',
      amenities: ['واي فاي مجاني', 'موقف سيارات', 'مطعم'],
    ),
    const Hotel(
      name: 'فندق الخليج',
      imageUrl: '',
      address: 'منطقة الخليج الغربي، الدوحة',
      rating: 4.4,
      price: 300,
      distance: '5.2 كم',
      amenities: ['واي فاي مجاني', 'موقف سيارات', 'نادي رياضي'],
    ),
    const Hotel(
      name: 'فندق سيتي سنتر',
      imageUrl: '',
      address: 'الريان، الدوحة',
      rating: 4.7,
      price: 300,
      distance: '6.8 كم',
      amenities: ['واي فاي مجاني', 'موقف سيارات', 'سبا'],
    ),
    const Hotel(
      name: 'فندق شيراتون',
      imageUrl: '',
      address: 'منطقة الدفنة، الدوحة',
      rating: 4.8,
      price: 550,
      distance: '1.8 كم',
      amenities: ['واي فاي مجاني', 'موقف سيارات', 'مسبح', 'سبا'],
    ),
    const Hotel(
      name: 'فندق ماريوت',
      imageUrl: '',
      address: 'طريق المطار، الدوحة',
      rating: 4.3,
      price: 280,
      distance: '7.5 كم',
      amenities: ['واي فاي مجاني', 'موقف سيارات', 'مطعم'],
    ),
  ];

  /// Filtered list based on search & selected filter.
  List<Hotel> get filteredHotels {
    var list = allHotels;

    // Apply filter chip
    switch (selectedFilter.value) {
      case 'الأقرب إلي':
        list = list.toList()
          ..sort((a, b) {
            final da = double.tryParse(a.distance.replaceAll(' كم', '')) ?? 0;
            final db = double.tryParse(b.distance.replaceAll(' كم', '')) ?? 0;
            return da.compareTo(db);
          });
        break;
      case 'الأعلى تقييماً':
        list = list.toList()..sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'السعر':
        list = list.toList()..sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'المزيد':
        // TODO: open more filters bottom sheet
        break;
    }

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (h) =>
                h.name.contains(searchQuery.value) ||
                h.address.contains(searchQuery.value),
          )
          .toList();
    }

    return list;
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
}
