import 'package:get/get.dart';
// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProductDetailsResponse {
  final String status;
  final String message;
  final ProductDetails? product;

  const ProductDetailsResponse({
    required this.status,
    required this.message,
    this.product,
  });

  bool get isSuccess => status == 'success';

  factory ProductDetailsResponse.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final data = map['data'];
    ProductDetails? product;
    if (data is Map && data['product'] is Map) {
      product = ProductDetails.fromApiMap(data['product'] as Map);
    }
    return ProductDetailsResponse(
      status: map['status']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      product: product,
    );
  }
}

class OptionValue {
  final int value;
  final String desc;

  const OptionValue({required this.value, required this.desc});

  bool get isEnabled => value == 1;

  factory OptionValue.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return OptionValue(
      value: int.tryParse(map['value']?.toString() ?? '') ?? 0,
      desc: map['desc']?.toString() ?? '',
    );
  }
}

/// Enum-like `{value, desc}` from backend EnumResource (string values).
class EnumDesc {
  final String value;
  final String desc;

  const EnumDesc({required this.value, required this.desc});

  factory EnumDesc.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return EnumDesc(
      value: map['value']?.toString() ?? '',
      desc: map['desc']?.toString() ?? '',
    );
  }
}

class ProductOption {
  final int? id;
  final String name;
  final EnumDesc type;
  final EnumDesc selectType;
  final List<ProductOptionChoice> values;

  const ProductOption({
    this.id,
    required this.name,
    this.type = const EnumDesc(value: 'optional', desc: ''),
    this.selectType = const EnumDesc(value: 'one_value_required', desc: ''),
    this.values = const [],
  });

  bool get isRequired => type.value == 'required';

  int get minSelections {
    if (!isRequired || selectType.value == 'no_value_required') return 0;
    switch (selectType.value) {
      case 'two_value_required':
        return 2;
      case 'three_value_required':
        return 3;
      case 'four_value_required':
        return 4;
      case 'multi_values':
        return 1;
      case 'one_value_required':
      default:
        return 1;
    }
  }

  int? get maxSelections {
    switch (selectType.value) {
      case 'one_value_required':
        return 1;
      case 'two_value_required':
        return 2;
      case 'three_value_required':
        return 3;
      case 'four_value_required':
        return 4;
      case 'multi_values':
      case 'no_value_required':
        return null;
      default:
        return 1;
    }
  }

  bool get isSingleSelect => maxSelections == 1;

  factory ProductOption.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final valuesRaw = map['values'] ?? map['choices'];
    final List<ProductOptionChoice> values = [];
    if (valuesRaw is List) {
      for (final c in valuesRaw) {
        if (c is Map) {
          values.add(ProductOptionChoice.fromApiMap(c));
        }
      }
    }
    final typeRaw = map['type'];
    final selectRaw = map['select_type'];
    return ProductOption(
      id: int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
      type: typeRaw is Map
          ? EnumDesc.fromApiMap(typeRaw)
          : const EnumDesc(value: 'optional', desc: ''),
      selectType: selectRaw is Map
          ? EnumDesc.fromApiMap(selectRaw)
          : const EnumDesc(value: 'one_value_required', desc: ''),
      values: values,
    );
  }
}

class ProductOptionChoice {
  final int? id;
  final String name;
  final double price;

  const ProductOptionChoice({this.id, required this.name, this.price = 0});

  factory ProductOptionChoice.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return ProductOptionChoice(
      id: int.tryParse(map['id']?.toString() ?? ''),
      name: map['name']?.toString() ?? '',
      price: double.tryParse(map['price']?.toString() ?? '') ?? 0,
    );
  }
}

class MarketInfo {
  final int id;
  final String name;
  final String mainImage;
  final String locationTitle;
  final String contactPhone;
  final String contactWhatsapp;
  final double rating;

  const MarketInfo({
    required this.id,
    required this.name,
    required this.mainImage,
    required this.locationTitle,
    required this.contactPhone,
    required this.contactWhatsapp,
    required this.rating,
  });

  factory MarketInfo.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    return MarketInfo(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      mainImage: map['main_image']?.toString() ?? '',
      locationTitle: map['location_title']?.toString() ?? '',
      contactPhone: map['contact_phone']?.toString() ?? '',
      contactWhatsapp: map['contact_whatsapp']?.toString() ?? '',
      rating: double.tryParse(map['rating']?.toString() ?? '') ?? 0,
    );
  }
}

class ProductDetails {
  final int id;
  final String name;
  final String description;
  final String image;
  final int soldCount;
  final double price;
  final double oldPrice;
  final int? quantity;
  final int minCountOrder;
  final int maxCountOrder;
  final OptionValue isUnlimited;
  final OptionValue withOption;
  final List<ProductOption> options;
  final MarketInfo market;

  const ProductDetails({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.soldCount,
    required this.price,
    required this.oldPrice,
    this.quantity,
    required this.minCountOrder,
    required this.maxCountOrder,
    required this.isUnlimited,
    required this.withOption,
    this.options = const [],
    required this.market,
  });

  String get savings {
    if (oldPrice > price && oldPrice > 0) {
      return 'auto_key_1'.tr;
    }
    return '';
  }

  bool get hasOptions => withOption.isEnabled && options.isNotEmpty;

  ProductDetails copyWith({
    int? id,
    String? name,
    String? description,
    String? image,
    int? soldCount,
    double? price,
    double? oldPrice,
    int? quantity,
    int? minCountOrder,
    int? maxCountOrder,
    OptionValue? isUnlimited,
    OptionValue? withOption,
    List<ProductOption>? options,
    MarketInfo? market,
  }) =>
      ProductDetails(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        soldCount: soldCount ?? this.soldCount,
        price: price ?? this.price,
        oldPrice: oldPrice ?? this.oldPrice,
        quantity: quantity ?? this.quantity,
        minCountOrder: minCountOrder ?? this.minCountOrder,
        maxCountOrder: maxCountOrder ?? this.maxCountOrder,
        isUnlimited: isUnlimited ?? this.isUnlimited,
        withOption: withOption ?? this.withOption,
        options: options ?? this.options,
        market: market ?? this.market,
      );

  factory ProductDetails.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    final price = double.tryParse(map['price']?.toString() ?? '') ?? 0;
    final oldPrice = double.tryParse(map['old_price']?.toString() ?? '') ?? 0;

    final optionsRaw = map['options'];
    final List<ProductOption> options = [];
    if (optionsRaw is List) {
      for (final o in optionsRaw) {
        if (o is Map) {
          options.add(ProductOption.fromApiMap(o));
        }
      }
    }

    final isUnlimitedRaw = map['is_unlimited'];
    final OptionValue isUnlimited = isUnlimitedRaw is Map
        ? OptionValue.fromApiMap(isUnlimitedRaw)
        : const OptionValue(value: 0, desc: '');

    final withOptionRaw = map['with_option'];
    final OptionValue withOption = withOptionRaw is Map
        ? OptionValue.fromApiMap(withOptionRaw)
        : const OptionValue(value: 0, desc: '');

    final marketRaw = map['market'];
    final MarketInfo market = marketRaw is Map
        ? MarketInfo.fromApiMap(marketRaw)
        : const MarketInfo(
            id: 0,
            name: '',
            mainImage: '',
            locationTitle: '',
            contactPhone: '',
            contactWhatsapp: '',
            rating: 0,
          );

    return ProductDetails(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      image: map['image']?.toString() ?? '',
      soldCount: int.tryParse(map['soldCount']?.toString() ?? '') ?? 0,
      price: price,
      oldPrice: oldPrice,
      quantity: int.tryParse(map['quantity']?.toString() ?? ''),
      minCountOrder:
          int.tryParse(map['min_count_order']?.toString() ?? '') ?? 1,
      maxCountOrder:
          int.tryParse(map['max_count_order']?.toString() ?? '') ?? 20,
      isUnlimited: isUnlimited,
      withOption: withOption,
      options: options,
      market: market,
    );
  }
}
