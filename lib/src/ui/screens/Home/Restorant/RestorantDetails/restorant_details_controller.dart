import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/generated/assets.gen.dart';
import 'package:nisba_app/src/data/models/restorant_model.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/ui/screens/Home/Products/ProductDetails/product_details_controller.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class ReviewItem {
  final String userName;
  final String? userImage;
  final double rating;
  final String comment;
  final String createdAt;

  const ReviewItem({
    required this.userName,
    this.userImage,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory ReviewItem.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final user = map['user'] is Map
        ? Map<String, dynamic>.from(map['user'])
        : {};
    return ReviewItem(
      userName:
          user['name']?.toString() ?? map['user_name']?.toString() ?? 'auto_key_276'.tr,
      userImage: user['image']?.toString(),
      rating:
          (map['rating'] as num?)?.toDouble() ??
          double.tryParse(map['rating']?.toString() ?? '') ??
          0,
      comment: map['comment']?.toString() ?? map['review']?.toString() ?? '',
      createdAt: map['created_at']?.toString() ?? '',
    );
  }
}

class MealItem {
  final int? id;
  final String name;
  final String description;
  final String image;
  final double price;
  final int orders;

  const MealItem({
    this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.orders,
  });

  factory MealItem.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return MealItem(
      id: int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '') ?? 0,
      orders: int.tryParse(map['soldCount']?.toString() ?? '') ?? 0,
    );
  }
}

class RestorantDetailsController extends GetxController {
  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final selectedDeliveryType = RxString('');
  final marketType = 'restaurant'.obs; // 'store' | 'kioks' | 'restaurant'
  final restorant = RestorantModel(
    name: '',
    rating: 0,
    deliveryTime: '',
    distance: '',
    imagePath: Assets.images.resBurger.path,
  ).obs;
  final tabs = <String>['all'.tr].obs;
  final categoryIds = <int?>[null].obs;
  final meals = <MealItem>[].obs;
  final categoriesRaw = <Map>[].obs;
  final reviews = <ReviewItem>[].obs;
  final reviewsCount = 0.obs;
  final reviewsAvg = 0.0.obs;
  final isReviewsLoading = false.obs;

  int? marketId;

  bool get isStore => marketType.value == 'store';
  bool get isKioks => marketType.value == 'kioks';

  /// Returns the appropriate cover image asset based on market type.
  String get coverImage {
    switch (marketType.value) {
      case 'kioks':
        return Assets.images.coverImageKiosk.path;
      case 'store':
        return Assets.images.coverImageGift.path;
      default:
        return Assets.images.coverImage.path;
    }
  }

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  @override
  void onInit() {
    super.onInit();
    _resolveArgs();
    if (marketId != null) {
      fetchMarketDetails();
      fetchProducts();
      fetchReviews();
    }
  }

  void _resolveArgs() {
    final args = Get.arguments;
    if (args is RestorantModel) {
      restorant.value = args;
      marketId = args.id;
      marketType.value = _detectMarketType(args.serviceType);
    } else if (args is BaseServiceItem) {
      marketId = int.tryParse(args.id);
      marketType.value = _detectMarketType(args.serviceType);
      restorant.value = RestorantModel(
        id: marketId,
        name: args.name,
        rating: args.rating,
        deliveryTime: args.hours ?? args.subTitle,
        distance: args.distance,
        imagePath: args.imageUrl,
      );
    } else if (args is Map) {
      final map = Map<String, dynamic>.from(args);
      marketId = int.tryParse(map['id']?.toString() ?? '');
      marketType.value = _detectMarketType(
        map['service_type']?.toString() ?? map['market_type']?.toString(),
      );
      restorant.value = RestorantModel.fromApiMap(
        map,
        fallbackImage: Assets.images.resBurger.path,
      );
    } else if (args is int) {
      marketId = args;
    }
  }

  String _detectMarketType(String? raw) {
    final v = (raw ?? '').trim().toLowerCase();
    switch (v) {
      case 'store':
      case 'market':
        return 'store';
      case 'kioks':
      case 'kiosk':
        return 'kioks';
      default:
        return 'restaurant';
    }
  }

  Future<void> fetchMarketDetails() async {
    final id = marketId;
    if (id == null) return;
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getMarketDetails(id);
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        final store = data['store'];
        if (store is Map) {
          restorant.value = RestorantModel.fromApiMap(
            store,
            fallbackImage: restorant.value.imagePath,
          );
        }
        final cats = data['categories'] as List? ?? [];
        categoriesRaw.assignAll(cats.whereType<Map>());
        if (categoriesRaw.isEmpty) {
          await _fetchCategoriesFallback(id);
        }
        _applyCategoryTabs();
      }
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchCategoriesFallback(int marketId) async {
    try {
      final res = await repository.getCategories(
        query: {'market_id': marketId},
      );
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map
          ? (data['categories'] as List? ?? [])
          : <dynamic>[];
      categoriesRaw.assignAll(list.whereType<Map>());
    } catch (e) {
      log('categories fallback: $e');
    }
  }

  void _applyCategoryTabs() {
    if (categoriesRaw.isEmpty) return;
    tabs.assignAll([
      'all'.tr,
      ...categoriesRaw.map((c) => c['name']?.toString() ?? ''),
    ]);
    categoryIds.assignAll([
      null,
      ...categoriesRaw.map((c) => int.tryParse(c['id']?.toString() ?? '')),
    ]);
  }

  /// Fetches this market's reviews (`/markets/{id}/reviews`).
  Future<void> fetchReviews() async {
    final id = marketId;
    if (id == null) return;
    isReviewsLoading.value = true;
    try {
      final res = await repository.getMarketReviews(id);
      final data = ApiResult.ensureSuccess(res);
      if (data is Map) {
        reviewsCount.value =
            int.tryParse(data['reviews_count']?.toString() ?? '') ?? 0;
        reviewsAvg.value =
            (data['reviews_avg'] as num?)?.toDouble() ??
            double.tryParse(data['reviews_avg']?.toString() ?? '') ??
            0;
        final list = data['reviews'] as List? ?? [];
        reviews.assignAll(list.whereType<Map>().map(ReviewItem.fromApiMap));
      }
    } catch (e) {
      log('fetchReviews: $e');
    } finally {
      isReviewsLoading.value = false;
    }
  }

  Future<void> fetchProducts({int? categoryId}) async {
    final id = marketId;
    if (id == null) return;
    try {
      final res = await repository.getProducts(
        marketId: id,
        categoryId: categoryId,
      );
      final data = ApiResult.ensureSuccess(res);
      final list = data is Map
          ? (data['products'] as List? ?? [])
          : <dynamic>[];
      meals.assignAll(list.whereType<Map>().map(MealItem.fromApiMap).toList());
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }

  void selectTab(int index) {
    selectedTab.value = index;
    final catId = index < categoryIds.length ? categoryIds[index] : null;
    fetchProducts(categoryId: catId);
  }

  void openProduct(MealItem meal) {
    if (meal.id == null) {
      AppSnackbar.showError(message: 'auto_key_252'.tr);
      return;
    }
    if (Get.isRegistered<ProductDetailsController>()) {
      Get.delete<ProductDetailsController>(force: true);
    }
    Get.toNamed(
      AppRoutesNames.productDetails,
      arguments: {
        'id': meal.id,
        'market_id': marketId,
        'name': meal.name,
        'description': meal.description,
        'image': meal.image.isNotEmpty
            ? meal.image
            : Assets.images.resProduct1.path,
        'price': meal.price,
      },
    );
  }

  void orderNow() {
    if (meals.isNotEmpty) {
      openProduct(meals.first);
    } else {
      AppSnackbar.showInfo(message: 'auto_key_277'.tr);
    }
  }

  Future<void> toggleFavorite() async {
    final id = marketId;
    if (id == null || id <= 0) return;
    try {
      if (!await connectionChecker.hasConnection) {
        AppSnackbar.showError(message: 'check_connection'.tr);
        return;
      }
      final res = await repository.favMarket(id);
      ApiResult.ensureSuccess(res);
      final current = restorant.value;
      restorant.value = current.copyWith(isFavorite: !current.isFavorite);
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }
}
