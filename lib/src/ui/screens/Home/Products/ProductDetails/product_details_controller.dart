import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/local/cart_storage.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/data/models/product_details_model.dart';
import 'package:nisba_app/src/data/models/product_model.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

import '../../../../../configs/api_response.dart';

class ProductDetailsController extends GetxController {
  final quantity = 1.obs;
  final isFavorite = false.obs;
  final isAdding = false.obs;

  /// Selected option value IDs keyed by option id.
  final selectedByOption = <int, Set<int>>{}.obs;

  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();
  final GetStorageHelper storageHelper = Get.find();
  final CartStorage cartStorage = CartStorage();

  int? productId;
  int? marketId;
  String fallbackName = '';
  String fallbackImage = '';
  double fallbackPrice = 0;
  String fallbackDescription = '';

  Rx<ApiResponse<ProductDetailsResponse>> productDetailsResponse =
      ApiResponse<ProductDetailsResponse>.init().obs;

  ProductDetails? get details {
    final resp = productDetailsResponse.value;
    if (resp.status != Status.completed) return null;
    return resp.data.product;
  }

  @override
  void onInit() {
    super.onInit();
    _resolveArgs();
    if (productId != null) {
      fetchProductDetails();
    } else {
      productDetailsResponse.value = ApiResponse<ProductDetailsResponse>.error(
        'auto_key_252'.tr,
      );
    }
  }

  void _resolveArgs() {
    final args = Get.arguments;
    if (args is OfferProduct) {
      productId = args.id;
      marketId = args.marketId;
      fallbackName = args.name;
      fallbackImage = args.image;
      fallbackPrice = double.tryParse(args.price) ?? 0;
    } else if (args is Product) {
      productId = args.id;
      marketId = args.marketId;
      fallbackName = args.name;
      fallbackImage = args.imagePath;
      fallbackPrice = args.price;
      fallbackDescription = args.description;
    } else if (args is Map) {
      final map = Map<String, dynamic>.from(args);
      productId = int.tryParse(map['id']?.toString() ?? '');
      marketId = int.tryParse(map['market_id']?.toString() ?? '');
      fallbackName = map['name']?.toString() ?? '';
      fallbackImage =
          map['image']?.toString() ?? map['imagePath']?.toString() ?? '';
      fallbackPrice = double.tryParse(map['price']?.toString() ?? '') ?? 0;
      fallbackDescription = map['description']?.toString() ?? '';
    } else if (args is int) {
      productId = args;
    }
  }

  Future<void> fetchProductDetails() async {
    productDetailsResponse.value = ApiResponse<ProductDetailsResponse>.loading(
      '',
    );
    final id = productId;
    if (id == null) return;
    if (!await connectionChecker.hasConnection) {
      const msg = 'check_connection';
      productDetailsResponse.value = ApiResponse<ProductDetailsResponse>.error(
        msg,
      );
      AppSnackbar.showError(message: msg.tr);
      return;
    }

    try {
      final res = await repository.getProductDetails(id);
      if (!res.isSuccess || res.product == null) {
        final msg = res.message.isNotEmpty ? res.message : 'auto_key_253'.tr;
        productDetailsResponse.value =
            ApiResponse<ProductDetailsResponse>.error(msg);
        AppSnackbar.showError(message: msg);
        return;
      }
      productDetailsResponse.value =
          ApiResponse<ProductDetailsResponse>.completed(res);
      final d = res.product!;
      if (marketId == null || marketId == 0) {
        marketId = d.market.id;
      }
      quantity.value = d.minCountOrder > 0 ? d.minCountOrder : 1;
      selectedByOption.clear();
    } on ApiException catch (e) {
      productDetailsResponse.value = ApiResponse<ProductDetailsResponse>.error(
        e.message,
      );
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      log(e.toString());
      final msg = DioErrorUtil.handleError(e);
      productDetailsResponse.value = ApiResponse<ProductDetailsResponse>.error(
        msg,
      );
      AppSnackbar.showError(message: msg);
    } catch (e) {
      productDetailsResponse.value = ApiResponse<ProductDetailsResponse>.error(
        e.toString(),
      );
      AppSnackbar.showError(message: e.toString());
    }
  }

  int get maxAllowedQty {
    final d = details;
    if (d == null) return 99;
    var max = d.maxCountOrder > 0 ? d.maxCountOrder : 99;
    if (!d.isUnlimited.isEnabled && d.quantity != null && d.quantity! > 0) {
      max = max < d.quantity! ? max : d.quantity!;
    }
    return max;
  }

  int get minAllowedQty {
    final d = details;
    if (d == null) return 1;
    return d.minCountOrder > 0 ? d.minCountOrder : 1;
  }

  void increment() {
    if (quantity.value < maxAllowedQty) quantity.value++;
  }

  void decrement() {
    if (quantity.value > minAllowedQty) quantity.value--;
  }

  void toggleFavorite() => isFavorite.value = !isFavorite.value;

  bool isChoiceSelected(int optionId, int choiceId) {
    return selectedByOption[optionId]?.contains(choiceId) ?? false;
  }

  void toggleChoice(ProductOption option, ProductOptionChoice choice) {
    final optionId = option.id;
    final choiceId = choice.id;
    if (optionId == null || choiceId == null) return;

    final current = Set<int>.from(selectedByOption[optionId] ?? {});

    if (option.isSingleSelect) {
      if (current.contains(choiceId)) {
        current.clear();
      } else {
        current
          ..clear()
          ..add(choiceId);
      }
    } else {
      if (current.contains(choiceId)) {
        current.remove(choiceId);
      } else {
        final max = option.maxSelections;
        if (max != null && current.length >= max) {
          AppSnackbar.showInfo(
            message: 'auto_key_254'.tr,
          );
          return;
        }
        current.add(choiceId);
      }
    }

    selectedByOption[optionId] = current;
    selectedByOption.refresh();
  }

  List<int> get selectedOptionValueIds {
    final ids = <int>[];
    for (final set in selectedByOption.values) {
      ids.addAll(set);
    }
    return ids;
  }

  double get optionsExtraPrice {
    final d = details;
    if (d == null || !d.hasOptions) return 0;
    var extra = 0.0;
    for (final option in d.options) {
      final selected = selectedByOption[option.id ?? -1] ?? {};
      for (final choice in option.values) {
        if (choice.id != null && selected.contains(choice.id)) {
          extra += choice.price;
        }
      }
    }
    return extra;
  }

  double get unitPrice {
    final d = details;
    final base = d?.price ?? fallbackPrice;
    return base + optionsExtraPrice;
  }

  double get totalPrice => unitPrice * quantity.value;

  String? validateOptions() {
    final d = details;
    if (d == null || !d.hasOptions) return null;
    for (final option in d.options) {
      final selected = selectedByOption[option.id ?? -1] ?? {};
      final count = selected.length;
      if (count < option.minSelections) {
        final label = option.isRequired ? 'auto_key_85'.tr : '';
        return 'auto_key_255'.tr
            .trim();
      }
      final max = option.maxSelections;
      if (max != null && count > max) {
        return 'auto_key_256'.tr;
      }
    }
    return null;
  }

  Future<void> addToCart() async {
    if (!storageHelper.isLoggedIn()) {
      Get.toNamed(AppRoutesNames.login);
      return;
    }

    final pid = productId ?? details?.id;
    final mid = marketId ?? details?.market.id;
    if (pid == null || mid == null || mid == 0) {
      AppSnackbar.showError(message: 'auto_key_257'.tr);
      return;
    }

    final optionError = validateOptions();
    if (optionError != null) {
      AppSnackbar.showError(message: optionError);
      return;
    }

    isAdding.value = true;
    try {
      final d = details;
      final name = d?.name ?? fallbackName;
      final image = d?.image ?? fallbackImage;

      await cartStorage.addItem(
        CartItem(
          marketId: mid,
          productId: pid,
          qty: quantity.value,
          optionValueIds: selectedOptionValueIds,
          values: {'name': name, 'image': image, 'price': unitPrice.toString()},
        ),
      );
      AppSnackbar.showSuccess(message: 'auto_key_258'.tr);
    } catch (e) {
      AppSnackbar.showError(message: e.toString());
    } finally {
      isAdding.value = false;
    }
  }
}
