import 'package:get/get.dart';

import '../../../../../../data/models/service_model.dart';

class PlaceDetailsController extends GetxController {
  late final BaseServiceItem item;

  final isFavorite = false.obs;
  final selectedTab = ''.obs;
  final availableTabs = <String>[].obs;
  final currentImageIndex = 1.obs;
  final totalImages = 1.obs;

  final selectedItems = <String, int>{}.obs;
  final totalPrice = 0.0.obs;
  final selectedCount = 0.obs;

  @override
  void onInit() {
    if (Get.arguments is BaseServiceItem) {
      item = Get.arguments as BaseServiceItem;
      totalImages.value = item.images.isNotEmpty ? item.images.length : 1;
      _initializeTabs();
    } else {
      // Fallback mock item if initialized directly without arguments
      _initializeFallbackItem();
    }
    super.onInit();
  }

  void _initializeFallbackItem() {
    // If no arguments provided, create a mock item to prevent crashes during preview
    item = const BaseServiceItem(
      id: 'demo_1',
      name: 'فندق لاكجري دبي',
      subTitle: 'فندق خمس نجوم فاخر',
      imageUrl:
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=500&q=80',
      address: 'دبي، الإمارات',
      rating: 4.8,
      reviewsCount: 523,
      distance: '3.5 كم',
      category: 'فنادق 5 نجوم',
      serviceType: 'Hotel',
      aboutText:
          'تجربة إقامة استثنائية في قلب مدينة دبي مع أفضل الخدمات الفندقية والمرافق الراعية.',
      currency: 'د.إ',
    );
    totalImages.value = 1;
    _initializeTabs();
  }

  void _initializeTabs() {
    availableTabs.clear();

    final type = item.serviceType.toLowerCase();

    if (type == 'hotel' || type == 'فندق') {
      if (item.rooms != null && item.rooms!.isNotEmpty) {
        for (final r in item.rooms!) {
          final roomName = r is HotelRoom
              ? r.name
              : (r is Map ? r['name']?.toString() : null);
          if (roomName != null && roomName.isNotEmpty) {
            availableTabs.add(roomName);
          }
        }
      }
      if (availableTabs.isEmpty) {
        availableTabs.assignAll([
          'غرفة دبل',
          'غرفة فردية',
          'جناح',
          'جناح ملكي',
        ]);
      }
    } else if (type == 'mall' || type == 'مول') {
      availableTabs.add('نظرة عامة');
      if ((item.stores != null && item.stores!.isNotEmpty) ||
          (item.productsOrServices != null &&
              item.productsOrServices!.isNotEmpty)) {
        availableTabs.add('المتاجر');
      }
      if (item.restaurants != null && item.restaurants!.isNotEmpty) {
        availableTabs.add('المطاعم');
      }
      availableTabs.addAll(['الترفيه', 'العروض والفعاليات']);
    } else if (type == 'beauty' || type == 'تجميل' || type == 'spa') {
      availableTabs.add('نظرة عامة');
      if (item.productsOrServices != null &&
          item.productsOrServices!.isNotEmpty) {
        availableTabs.add('الخدمات');
      }
    } else {
      // Generic Fallback
      availableTabs.add('نظرة عامة');
      if (item.productsOrServices != null &&
          item.productsOrServices!.isNotEmpty) {
        availableTabs.add('الخدمات');
      }
      if (item.rooms != null && item.rooms!.isNotEmpty) {
        availableTabs.add('الغرف');
      }
      if (item.itinerarySteps != null && item.itinerarySteps!.isNotEmpty) {
        availableTabs.add('برنامج الرحلة');
      }
    }

    if (availableTabs.isNotEmpty) {
      selectedTab.value = availableTabs.first;
    }
  }

  void selectTab(String tab) => selectedTab.value = tab;
  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  void nextImage() {
    if (currentImageIndex.value < totalImages.value) currentImageIndex.value++;
  }

  void previousImage() {
    if (currentImageIndex.value > 1) currentImageIndex.value--;
  }

  void toggleItemSelection(String itemId, double price) {
    if (selectedItems.containsKey(itemId)) {
      selectedItems.remove(itemId);
    } else {
      selectedItems[itemId] = 1;
    }
    _recalculateTotal(priceOverride: price);
  }

  void incrementQuantity(String itemId, double price) {
    selectedItems[itemId] = (selectedItems[itemId] ?? 0) + 1;
    _recalculateTotal(priceOverride: price);
  }

  void decrementQuantity(String itemId, double price) {
    if (selectedItems.containsKey(itemId)) {
      if (selectedItems[itemId]! > 1) {
        selectedItems[itemId] = selectedItems[itemId]! - 1;
      } else {
        selectedItems.remove(itemId);
      }
      _recalculateTotal(priceOverride: price);
    }
  }

  int getQuantity(String itemId) => selectedItems[itemId] ?? 0;

  final _selectedRx = <String, RxBool>{};

  RxBool isSelected(String itemId) {
    _selectedRx.putIfAbsent(
      itemId,
      () => RxBool(selectedItems.containsKey(itemId)),
    );
    return _selectedRx[itemId]!;
  }

  void _syncSelectionRx() {
    for (final key in _selectedRx.keys) {
      _selectedRx[key]?.value = selectedItems.containsKey(key);
    }
  }

  void _recalculateTotal({double? priceOverride}) {
    double total = 0;
    int count = 0;

    // Search in productsOrServices
    final allSubItems = <ServiceSubItem>[
      if (item.productsOrServices != null) ...item.productsOrServices!,
    ];

    for (final entry in selectedItems.entries) {
      final subItem = allSubItems.firstWhereOrNull((s) => s.id == entry.key);
      if (subItem != null) {
        total += subItem.price * entry.value;
        count += entry.value;
      } else {
        // If price details passed directly or from rooms/stores
        total += (priceOverride ?? 0) * entry.value;
        count += entry.value;
      }
    }

    totalPrice.value = total;
    selectedCount.value = count;
    _syncSelectionRx();
  }

  void clearSelections() {
    selectedItems.clear();
    totalPrice.value = 0;
    selectedCount.value = 0;
    _syncSelectionRx();
  }
}
