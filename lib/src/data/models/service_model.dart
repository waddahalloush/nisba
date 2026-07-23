import 'package:flutter/material.dart';

/// ميزة فريدة تظهر بأيقونة (مثل المرافق أو المميزات)
class ServiceFeature {
  final IconData icon;
  final String label;
  const ServiceFeature({required this.icon, required this.label});
}

/// بطاقة إحصائيات سريعة (مثل ساعات العمل، التذاكر)
class ServiceStat {
  final String title;
  final String value;
  final IconData icon;
  const ServiceStat({
    required this.title,
    required this.value,
    required this.icon,
  });
}

/// نموذج فرعي موحد للمنتجات/الخدمات/الأنشطة (يغطي السوق، التجميل، والسياحة)
class ServiceSubItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String? extraInfo; // يمكن استخدامه للمدة الزمنية أو العيار

  const ServiceSubItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.extraInfo,
  });
}

/// نموذج سعة الغرفة الفندقية
class HotelRoomCapacity {
  final String person;
  final String bed;
  const HotelRoomCapacity({required this.person, required this.bed});
}

/// نموذج الغرفة الفندقية
class HotelRoom {
  final String id;
  final String name;
  final String? subtitle;
  final String imageUrl;
  final double price;
  final HotelRoomCapacity capacity;
  final List<String> specs;
  final bool isAvailable;

  const HotelRoom({
    required this.id,
    required this.name,
    this.subtitle,
    required this.imageUrl,
    required this.price,
    required this.capacity,
    required this.specs,
    this.isAvailable = true,
  });
}

/// نموذج المتاجر والمطاعم داخل المول
class MallStoreOrRestaurant {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double rating;
  final int reviewsCount;
  final String? actionLabel; // مثال: "احجز طاولة" أو "استلام من المتجر"
  final String? priceDescription;
  final double? price;

  const MallStoreOrRestaurant({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.rating,
    this.reviewsCount = 0,
    this.actionLabel,
    this.priceDescription,
    this.price,
  });
}

/// نموذج الرابط السريع للخدمات
class QuickLink {
  final String title;
  final IconData icon;
  final String actionUrl;

  const QuickLink({
    required this.title,
    required this.icon,
    required this.actionUrl,
  });
}

/// المودل الشامل لجميع الخدمات
class BaseServiceItem {
  // ── البيانات الأساسية المشتركة ──
  final String id;
  final String name;
  final String subTitle;
  final String imageUrl;
  final String? logoUrl;
  final String address;
  final double rating;
  final int reviewsCount;
  final String distance;
  final String category;
  final String serviceType;
  final String aboutText;
  final String? hours;
  final String currency;

  // ── معرض الصور ──
  final List<String> images;

  // ── القوائم المشتركة (تظهر إذا لم تكن فارغة) ──
  final List<ServiceFeature>? features;
  final List<String>? highlights;
  final List<ServiceStat>? stats;

  // ── البيانات المخصصة (ديناميكية حسب نوع الخدمة) ──
  final List<ServiceSubItem>? productsOrServices;
  final List<dynamic>? rooms;
  final List<MallStoreOrRestaurant>? stores;
  final List<MallStoreOrRestaurant>? restaurants;
  final List<QuickLink>? quickLinks;
  final List<dynamic>? itinerarySteps;
  final List<dynamic>? departments;

  const BaseServiceItem({
    required this.id,
    required this.name,
    required this.subTitle,
    required this.imageUrl,
    this.logoUrl,
    this.hours,
    required this.address,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.category,
    required this.serviceType,
    required this.aboutText,
    this.currency = 'ر.ق',
    this.images = const [],
    this.features,
    this.highlights,
    this.stats,
    this.productsOrServices,
    this.rooms,
    this.stores,
    this.restaurants,
    this.quickLinks,
    this.itinerarySteps,
    this.departments,
  });
}
