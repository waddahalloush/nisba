import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../generated/assets.gen.dart';

class NotificationModel {
  final String icon;
  final String title;
  final String? subtitle;
  final String time;
  final String category; // orders, delivery, offers, account

  const NotificationModel({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.time,
    required this.category,
  });
}

class NotificationnController extends GetxController {
  final selectedTab = 0.obs; // 0 = today, 1 = all
  final selectedFilter = ''.obs; // '' = all

  final filters = <String>['الطلبات', 'التوصيل', 'العروض', 'الحساب'];

  final notifications = <NotificationModel>[
     NotificationModel(
      icon: Assets.images.orderNoti.path,
      title: 'تم استلام طلبك',
      subtitle: 'رقم الطلب: #12345',
      time: '2 دقيقة',
      category: 'الطلبات',
    ),
     NotificationModel(
      icon: Assets.images.deliveryMan.path,
      title: 'على الطريق إليك',
      subtitle: 'مندوب التوصيل في الطريق إليك الآن',
      time: '15 دقيقة',
      category: 'التوصيل',
    ),
     NotificationModel(
      icon: Assets.images.creditOffer.path,
      title: 'خصم خاص لك!',
      subtitle: 'استخدم الكود SAVE20 للحصول على خصم 20%',
      time: 'ساعة',
      category: 'العروض',
    ),
     NotificationModel(
      icon: Assets.images.box.path,
      title: 'تم توصيل طلبك',
      subtitle: 'تم توصيل طلبك رقم #12344 بنجاح',
      time: '3 ساعات',
      category: 'التوصيل',
    ),
     NotificationModel(
      icon: Assets.images.privacy.path,
      title: 'تحديث مهم',
      subtitle: 'تم تحديث سياسة الخصوصية، يرجى الاطلاع',
      time: '1 يوم',
      category: 'الحساب',
    ),
  ];

  List<NotificationModel> get filteredNotifications {
    if (selectedFilter.value.isEmpty) return notifications;
    return notifications
        .where((n) => n.category == selectedFilter.value)
        .toList();
  }

  void selectTab(int index) => selectedTab.value = index;

  void toggleFilter(String filter) {
    selectedFilter.value = selectedFilter.value == filter ? '' : filter;
  }
}
