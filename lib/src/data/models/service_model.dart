// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ServiceModel {
  final String title;
  final String image;
  final VoidCallback onTap;
  ServiceModel({
    required this.title,
    required this.image,
    required this.onTap,
  });
}

/// تصنيف مشترك لأي خدمة
class ServiceCategory {
  final String name;
  final IconData icon;

  const ServiceCategory({required this.name, required this.icon});
}

/// موديل موحد لجميع العناصر (مولات، ترفيه، هدايا، إلخ)
class BaseServiceItem {
  final String name;
  final String imageUrl;
  final String address;
  final double rating;
  final String distance;
  final String category;
  final String? hours;
  
  // حقول مخصصة مرنة تختلف باختلاف الخدمة وتظهر ديناميكياً
  final List<ServiceFeature>? features;

  const BaseServiceItem({
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.rating,
    required this.distance,
    required this.category,
    this.hours,
    this.features,
  });
}

/// ميزة فريدة تظهر أسفل عنصر الخدمة (مثل: "سينما"، "تغليف متاح"، "العاب")
class ServiceFeature {
  final IconData icon;
  final String label;

  const ServiceFeature({required this.icon, required this.label});
}