import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../generated/assets.gen.dart';

/// Data model for a mall category.
class MallCategoryModel {
  final String name;
  final IconData icon;

  const MallCategoryModel({required this.name, required this.icon});
}

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
  final categories = <MallCategoryModel>[
    const MallCategoryModel(name: 'الكل', icon: Iconsax.category),
    const MallCategoryModel(name: 'ترفيه', icon: Iconsax.music),
    const MallCategoryModel(name: 'مطاعم', icon: Iconsax.coffee),
    const MallCategoryModel(name: 'أزياء', icon: Iconsax.shop),
    const MallCategoryModel(name: 'إلكترونيات', icon: Iconsax.mobile),
  ];

  // ── Featured malls ──
  final featuredMalls = <Mall>[
    Mall(
      name: 'قطر مول',
      imageUrl: Assets.images.mall11.path,
      address: 'طريق الدوحة السريع',
      rating: 4.8,
      stores: 350,
      restaurants: 50,
      hasCinema: true,
      distance: '2.5 كم',
      hours: '10:00 ص - 12:00 م',
      category: 'الكل',
    ),
    Mall(
      name: 'لاند مارك مول',
      imageUrl: Assets.images.mall22.path,
      address: 'طريق سلوى',
      rating: 4.6,
      stores: 280,
      restaurants: 35,
      hasCinema: true,
      distance: '5.0 كم',
      hours: '9:00 ص - 11:00 م',
      category: 'الكل',
    ),
    Mall(
      name: 'جلف مول',
      imageUrl: Assets.images.mall44.path,
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
    Mall(
      name: 'قطر مول',
      imageUrl: Assets.images.mall11.path,
      address: 'طريق الدوحة السريع، الريان',
      rating: 4.8,
      stores: 350,
      restaurants: 50,
      hasCinema: true,
      distance: '2.5 كم',
      category: 'ترفيه',
    ),
    Mall(
      name: 'لاند مارك مول',
      imageUrl: Assets.images.mall22.path,
      address: 'طريق سلوى، أبو هامور',
      rating: 4.6,
      stores: 280,
      restaurants: 35,
      hasCinema: true,
      distance: '5.0 كم',
      category: 'أزياء',
    ),
    Mall(
      name: 'جلف مول',
      imageUrl: Assets.images.mall44.path,
      address: 'منطقة الخليج الغربي، الدوحة',
      rating: 4.5,
      stores: 200,
      restaurants: 30,
      hasCinema: false,
      distance: '3.2 كم',
      category: 'ترفيه',
    ),
    Mall(
      name: 'فيلاجيو مول',
      imageUrl: Assets.images.mall33.path,
      address: 'منطقة أسباير زون، الدوحة',
      rating: 4.7,
      stores: 220,
      restaurants: 45,
      hasCinema: true,
      distance: '4.1 كم',
      category: 'ترفيه',
    ),
    Mall(
      name: 'مول قطر',
      imageUrl: Assets.images.service6.path,
      address: 'طريق سلوى، الريان',
      rating: 4.4,
      stores: 190,
      restaurants: 28,
      hasCinema: true,
      distance: '6.3 كم',
      category: 'مطاعم',
    ),
    Mall(
      name: 'إزدان مول',
      imageUrl: Assets.images.service7.path,
      address: 'الوكرة، الدوحة',
      rating: 4.3,
      stores: 150,
      restaurants: 22,
      hasCinema: false,
      distance: '8.0 كم',
      category: 'إلكترونيات',
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
