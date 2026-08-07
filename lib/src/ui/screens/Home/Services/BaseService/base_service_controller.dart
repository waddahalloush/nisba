import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../../../data/models/service_model.dart';

// قم باستدعاء ملف BaseServiceItem هنا
// import '../../../../../data/models/base_service_model.dart';

/// مودل تصنيفات الفلترة العلوية (إذا لم يكن مكتوباً مسبقاً)
class ServiceCategory {
  final String name;
  final IconData icon;
  
  const ServiceCategory({required this.name, required this.icon});
}

abstract class BaseServiceController extends GetxController {
  // ── الحالة التفاعلية (Reactive State) ──
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final selectedCategory = 'الكل'.obs;
  final errorMessage = ''.obs;

  // ── القوائم الأساسية ──
  // تم تحويلها من Getters ثابتة إلى متغيرات تفاعلية (obs) لتقبل البيانات من API لاحقاً
  final categories = <ServiceCategory>[].obs;
  final featuredItems = <BaseServiceItem>[].obs;
  final allItems = <BaseServiceItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // بمجرد تهيئة الكونترولر، نطلب جلب البيانات (سواء من Mock أو API حقيقي)
    fetchData();
  }

  // ── دوال جلب البيانات ──
  /// دالة مجردة (Abstract) يُجبر كل كونترولر يرث هذا الكلاس (مثل سوق، فندق) على تنفيذها
  Future<void> fetchData();

  // ── منطق الفلترة المتقدم ──
  /// تصفية العناصر ديناميكياً بناءً على البحث والتصنيف النشط
  List<BaseServiceItem> get filteredItems {
    var list = allItems.toList(); // أخذ نسخة من القائمة

    // 1. الفلترة حسب التصنيف
    if (selectedCategory.value != 'الكل') {
      list = list.where((item) => item.category == selectedCategory.value).toList();
    }

    // 2. الفلترة حسب نص البحث
    if (searchQuery.value.trim().isNotEmpty) {
      final query = searchQuery.value.trim().toLowerCase();
      list = list.where((item) {
        // البحث الآن يشمل الاسم، العنوان، والعنوان الفرعي (subTitle) المضاف حديثاً في المودل
        final matchName = item.name.toLowerCase().contains(query);
        final matchAddress = item.address.toLowerCase().contains(query);
        final matchSubTitle = item.subTitle.toLowerCase().contains(query);
        
        return matchName || matchAddress || matchSubTitle;
      }).toList();
    }

    return list;
  }

  // ── الإجراءات (Actions) ──
  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }
  
  void clearSearch() {
    searchQuery.value = '';
  }
}