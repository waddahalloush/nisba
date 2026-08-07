import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class OfferItem {
  final String name;
  final double price;
  final double? oldPrice;
  final String imagePath;
  final bool isPopular;
  final String prepTime;

  const OfferItem({
    required this.name,
    required this.price,
    this.oldPrice,
    required this.imagePath,
    this.isPopular = false,
    this.prepTime = '0-0 دقيقة',
  });
}

class OfferRestaurant {
  final int? id;
  final String name;
  final double rating;
  final int reviewsCount;
  final String logoPath;
  final String discountTitle;
  final String discountDesc;
  final String deliveryTitle;
  final String deliveryDesc;
  final String deliveryTime;
  final String deliveryBy;
  final int satisfactionRate;
  final List<OfferItem> items;

  const OfferRestaurant({
    this.id,
    required this.name,
    required this.rating,
    required this.reviewsCount,
    required this.logoPath,
    required this.discountTitle,
    required this.discountDesc,
    required this.deliveryTitle,
    required this.deliveryDesc,
    required this.deliveryTime,
    required this.deliveryBy,
    required this.satisfactionRate,
    required this.items,
  });
}

class OfferController extends GetxController {
  final selectedTab = 0.obs;
  final location = 'شارع الملك فهد'.obs;
  final restaurants = <OfferRestaurant>[].obs;
  final isLoading = false.obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchOffers();
  }

  void selectTab(int index) => selectedTab.value = index;

  Future<void> fetchOffers() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getOffers();
      final data = ApiResult.ensureSuccess(res);
      final list = _extractOffers(data);
      restaurants.assignAll(list.map(_mapOffer).toList());
    } on ApiException catch (e) {
      log(e.message);
      restaurants.clear();
    } on DioException catch (e) {
      log(e.toString());
      restaurants.clear();
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      log(e.toString());
      restaurants.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetches full offer details and shows them in a bottom sheet.
  Future<void> openOffer(int? id) async {
    if (id == null) return;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.getOfferDetails(id);
      final data = ApiResult.ensureSuccess(res);
      final offer = data is Map ? data['offer'] : null;
      if (offer is! Map) return;

      final title = offer['title']?.toString() ?? '';
      final description = offer['description']?.toString() ?? '';
      final image = offer['image']?.toString() ?? '';

      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    image,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(fontSize: 13)),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('إغلاق'),
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      log(e.toString());
    }
  }

  List _extractOffers(dynamic data) {
    if (data is Map) {
      final offers = data['offers'];
      if (offers is List) return offers;
    }
    return const [];
  }

  OfferRestaurant _mapOffer(dynamic raw) {
    if (raw is! Map) {
      return OfferRestaurant(
        name: '',
        rating: 0,
        reviewsCount: 0,
        logoPath: Assets.images.azSham.path,
        discountTitle: 'قيمة الخصم',
        discountDesc: '',
        deliveryTitle: 'توصيل',
        deliveryDesc: '',
        deliveryTime: '—',
        deliveryBy: 'Nisba',
        satisfactionRate: 0,
        items: const [],
      );
    }
    final map = Map<String, dynamic>.from(raw);
    final offerId = int.tryParse(map['id']?.toString() ?? '');
    final market = map['market'] is Map
        ? Map<String, dynamic>.from(map['market'] as Map)
        : <String, dynamic>{};

    final name =
        (map['title'] ??
                map['name'] ??
                market['name'] ??
                map['market_name'] ??
                '')
            .toString();
    final image =
        (map['image'] ??
                map['logo'] ??
                market['main_image'] ??
                market['image'] ??
                '')
            .toString();
    final desc = (map['description'] ?? map['desc'] ?? '').toString();
    final time = (map['time'] ?? map['delivery_time'] ?? '—').toString();

    final itemsRaw = map['items'] ?? map['products'] ?? map['relations'];
    final items = <OfferItem>[];
    if (itemsRaw is List) {
      for (final item in itemsRaw.whereType<Map>()) {
        final p = Map<String, dynamic>.from(item);
        final product = p['product'] is Map
            ? Map<String, dynamic>.from(p['product'] as Map)
            : p;
        items.add(
          OfferItem(
            name: (product['name'] ?? p['name'] ?? '').toString(),
            price:
                double.tryParse('${product['price'] ?? p['price'] ?? 0}') ?? 0,
            oldPrice: double.tryParse(
              '${product['old_price'] ?? p['old_price'] ?? ''}',
            ),
            imagePath: (product['image'] ?? p['image'] ?? image).toString(),
          ),
        );
      }
    }

    return OfferRestaurant(
      id: offerId,
      name: name,
      rating: double.tryParse('${map['rating'] ?? market['rating'] ?? 0}') ?? 0,
      reviewsCount:
          int.tryParse(
            '${map['reviews_count'] ?? market['reviews_count'] ?? 0}',
          ) ??
          0,
      logoPath: image.isNotEmpty ? image : Assets.images.azSham.path,
      discountTitle: 'قيمة الخصم',
      discountDesc: desc,
      deliveryTitle: 'توصيل',
      deliveryDesc: desc.isNotEmpty ? desc : 'عرض خاص',
      deliveryTime: time.contains('دقيقة') ? time : '$time دقيقة',
      deliveryBy: 'Nisba',
      satisfactionRate: int.tryParse('${map['satisfaction'] ?? 90}') ?? 90,
      items: items,
    );
  }
}
