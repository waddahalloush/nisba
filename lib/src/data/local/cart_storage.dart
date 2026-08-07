import 'package:get/get.dart';

import '../local/constants/storages.dart';
import '../local/get_storage_helper.dart';

/// Local cart item persisted in GetStorage under [Storages.cart].
class CartItem {
  final int marketId;
  final int productId;
  final int qty;
  /// UI meta: name, image, price, …
  final Map<String, dynamic> values;
  /// Backend `products.*.values` = ProductOptionValue IDs.
  final List<int> optionValueIds;

  const CartItem({
    required this.marketId,
    required this.productId,
    required this.qty,
    this.values = const {},
    this.optionValueIds = const [],
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final rawIds = json['option_value_ids'] ?? json['optionValueIds'];
    final ids = <int>[];
    if (rawIds is List) {
      for (final e in rawIds) {
        final id = int.tryParse(e.toString());
        if (id != null) ids.add(id);
      }
    }
    return CartItem(
      marketId: json['market_id'] as int,
      productId: json['product_id'] as int,
      qty: json['qty'] as int? ?? 1,
      values: Map<String, dynamic>.from(json['values'] as Map? ?? {}),
      optionValueIds: ids,
    );
  }

  Map<String, dynamic> toJson() => {
        'market_id': marketId,
        'product_id': productId,
        'qty': qty,
        'values': values,
        'option_value_ids': optionValueIds,
      };

  /// Payload shape expected by order store `products` array.
  Map<String, dynamic> toOrderProduct() => {
        'product_id': productId,
        'quantity': qty,
        if (optionValueIds.isNotEmpty) 'values': optionValueIds,
      };

  CartItem copyWith({
    int? marketId,
    int? productId,
    int? qty,
    Map<String, dynamic>? values,
    List<int>? optionValueIds,
  }) =>
      CartItem(
        marketId: marketId ?? this.marketId,
        productId: productId ?? this.productId,
        qty: qty ?? this.qty,
        values: values ?? this.values,
        optionValueIds: optionValueIds ?? this.optionValueIds,
      );
}

bool _sameOptionIds(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  final sa = [...a]..sort();
  final sb = [...b]..sort();
  for (var i = 0; i < sa.length; i++) {
    if (sa[i] != sb[i]) return false;
  }
  return true;
}

/// Simple GetStorage-backed cart helper.
class CartStorage {
  final GetStorageHelper _storage = Get.find();

  List<CartItem> getItems() {
    final raw = _storage.read(Storages.cart);
    if (raw is! List) return [];
    return raw
        .whereType<Map>()
        .map((e) => CartItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> saveItems(List<CartItem> items) async {
    await _storage.write(
      Storages.cart,
      items.map((e) => e.toJson()).toList(),
    );
  }

  Future<void> addItem(CartItem item) async {
    final items = getItems();
    final index = items.indexWhere(
      (e) =>
          e.productId == item.productId &&
          e.marketId == item.marketId &&
          _sameOptionIds(e.optionValueIds, item.optionValueIds),
    );
    if (index >= 0) {
      items[index] = items[index].copyWith(
        qty: items[index].qty + item.qty,
        values: item.values.isNotEmpty ? item.values : items[index].values,
      );
    } else {
      items.add(item);
    }
    await saveItems(items);
  }

  Future<void> updateQty({
    required int marketId,
    required int productId,
    required int qty,
    List<int>? optionValueIds,
  }) async {
    final items = getItems();
    final index = items.indexWhere((e) {
      if (e.productId != productId || e.marketId != marketId) return false;
      if (optionValueIds == null) return true;
      return _sameOptionIds(e.optionValueIds, optionValueIds);
    });
    if (index < 0) return;
    if (qty <= 0) {
      items.removeAt(index);
    } else {
      items[index] = items[index].copyWith(qty: qty);
    }
    await saveItems(items);
  }

  Future<void> removeItem({
    required int marketId,
    required int productId,
    List<int>? optionValueIds,
  }) async {
    final items = getItems()
      ..removeWhere((e) {
        if (e.productId != productId || e.marketId != marketId) return false;
        if (optionValueIds == null) return true;
        return _sameOptionIds(e.optionValueIds, optionValueIds);
      });
    await saveItems(items);
  }

  Future<void> clear() async {
    await _storage.remove(Storages.cart);
  }

  /// Builds `products` payload for [storeOrder], optionally filtered by market.
  List<Map<String, dynamic>> buildOrderProducts({int? marketId}) {
    final items = getItems();
    final filtered = marketId == null
        ? items
        : items.where((e) => e.marketId == marketId);
    return filtered.map((e) => e.toOrderProduct()).toList();
  }

  int get totalQty => getItems().fold(0, (sum, e) => sum + e.qty);
}
