import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/ui/screens/Home/BaseService/market_type_router.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class FavoriteItem {
  final int? id;
  final String imageUrl;
  final String name;
  final double rating;
  final List<String> tags;
  final String deliveryTime;
  final bool isLiked;
  final String marketType;
  final String location;

  const FavoriteItem({
    this.id,
    required this.imageUrl,
    required this.name,
    required this.rating,
    required this.tags,
    required this.deliveryTime,
    this.isLiked = true,
    this.marketType = 'store',
    this.location = '',
  });

  FavoriteItem copyWith({bool? isLiked}) => FavoriteItem(
        id: id,
        imageUrl: imageUrl,
        name: name,
        rating: rating,
        tags: tags,
        deliveryTime: deliveryTime,
        isLiked: isLiked ?? this.isLiked,
        marketType: marketType,
        location: location,
      );

  factory FavoriteItem.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final tagsRaw = map['tags'];
    final tags = <String>[];
    if (tagsRaw is List) {
      for (final t in tagsRaw) {
        if (t is Map) {
          tags.add(t['name']?.toString() ?? '');
        } else if (t != null) {
          tags.add(t.toString());
        }
      }
    }
    final mt = map['market_type'];
    final typeValue = mt is Map
        ? mt['value']?.toString() ?? 'store'
        : mt?.toString() ?? 'store';
    return FavoriteItem(
      id: int.tryParse(map['id']?.toString() ?? ''),
      imageUrl: map['main_image']?.toString() ??
          map['image']?.toString() ??
          map['logo']?.toString() ??
          '',
      name: map['name']?.toString() ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0,
      tags: tags.where((e) => e.isNotEmpty).toList(),
      deliveryTime: map['preparation_time']?.toString() ?? '',
      isLiked: true,
      marketType: typeValue.isNotEmpty ? typeValue : 'store',
      location: map['location']?.toString() ??
          map['location_title']?.toString() ??
          '',
    );
  }
}

class FavoriteController extends GetxController {
  final selectedTab = 0.obs;
  final restaurants = <FavoriteItem>[].obs;
  final meals = <FavoriteItem>[].obs;
  final isLoading = false.obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  List<FavoriteItem> get currentItems =>
      selectedTab.value == 0 ? restaurants : meals;

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  Future<void> fetchFavorites() async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    isLoading.value = true;
    try {
      final res = await repository.getFavorites();
      final data = ApiResult.ensureSuccess(res);
      List list = [];
      if (data is Map) {
        list = data['stores'] as List? ?? [];
      } else if (data is List) {
        // Keep this for defensive compatibility if backend ever returns a raw list.
        list = data;
      }
      restaurants.assignAll(
        list.whereType<Map>().map(FavoriteItem.fromApiMap).toList(),
      );
      meals.clear();
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

  void selectTab(int index) => selectedTab.value = index;

  void openItem(FavoriteItem item) {
    final id = item.id;
    if (id == null || id <= 0) return;
    MarketTypeRouter.open(
      item.marketType,
      arguments: BaseServiceItem(
        id: '$id',
        name: item.name,
        subTitle: item.location,
        imageUrl: item.imageUrl,
        address: item.location,
        rating: item.rating,
        reviewsCount: 0,
        distance: '',
        category: item.marketType,
        serviceType: item.marketType,
        aboutText: item.location,
      ),
    );
  }

  Future<void> toggleLike(int index) async {
    final list = selectedTab.value == 0 ? restaurants : meals;
    if (index < 0 || index >= list.length) return;
    final item = list[index];
    final id = item.id;
    if (id == null) {
      list.removeAt(index);
      return;
    }
    try {
      final res = await repository.favMarket(id);
      ApiResult.ensureSuccess(res);
      list.removeAt(index);
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    }
  }
}
