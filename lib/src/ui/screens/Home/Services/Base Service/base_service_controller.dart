import 'package:get/get.dart';
import '../../../../../data/models/service_model.dart';

abstract class BaseServiceController extends GetxController {
  final searchQuery = ''.obs;
  final selectedCategory = 'الكل'.obs;
  final isLoading = false.obs;

  // سيتم تحديد هذه القوائم في الكونترولر الخاص بكل خدمة
  List<ServiceCategory> get categories;
  List<BaseServiceItem> get featuredItems;
  List<BaseServiceItem> get allItems;

  /// تصفية العناصر ديناميكياً بناءً على البحث والتصنيف النشط
  List<BaseServiceItem> get filteredItems {
    var list = allItems;
    if (selectedCategory.value != 'الكل') {
      list = list.where((item) => item.category == selectedCategory.value).toList();
    }
    if (searchQuery.value.isNotEmpty) {
      list = list
          .where(
            (item) =>
                item.name.contains(searchQuery.value) ||
                item.address.contains(searchQuery.value),
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