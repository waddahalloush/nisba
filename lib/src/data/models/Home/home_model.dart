// ---------------------------------------------------------------------------
// Reusable value/desc pair used across many API responses (status, type, etc.)
// ---------------------------------------------------------------------------
class EnumValue {
  final String value;
  final String desc;

  const EnumValue({required this.value, required this.desc});

  factory EnumValue.fromJson(Map<String, dynamic> json) => EnumValue(
        value: json['value']?.toString() ?? '',
        desc: json['desc']?.toString() ?? json['value']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {'value': value, 'desc': desc};
}

// ---------------------------------------------------------------------------
// Offer → Product (nested inside offers[].products)
// ---------------------------------------------------------------------------
class OfferProduct {
  final int id;
  final String name;
  final String image;
  final String price;
  final String oldPrice;
  final EnumValue withOption;
  final EnumValue status;
  final int marketId;

  const OfferProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.oldPrice,
    required this.withOption,
    required this.status,
    required this.marketId,
  });

  factory OfferProduct.fromJson(Map<String, dynamic> json) => OfferProduct(
    id: json['id'] as int,
    name: json['name']?.toString() ?? '',
    image: json['image']?.toString() ?? '',
    price: json['price'].toString(),
    oldPrice: json['old_price'].toString(),
    withOption: EnumValue.fromJson(Map<String, dynamic>.from(json['with_option'] as Map)),
    status: EnumValue.fromJson(Map<String, dynamic>.from(json['status'] as Map)),
    marketId: (json['market_id'] as num?)?.toInt() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': image,
    'price': price,
    'old_price': oldPrice,
    'with_option': withOption.toJson(),
    'status': status.toJson(),
    'market_id': marketId,
  };
}

// ---------------------------------------------------------------------------
// Offer
// ---------------------------------------------------------------------------
class Offer {
  final int id;
  final String title;
  final String description;
  final String image;
  final EnumValue type;
  final String time;
  final List<Market>? markets;
  final List<OfferProduct>? products;

  const Offer({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.type,
    required this.time,
    this.markets,
    this.products,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    List<OfferProduct>? products;
    final rawProducts = json['products'];
    if (rawProducts is List) {
      products = rawProducts
          .whereType<Map>()
          .map((e) => OfferProduct.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      if (products.isEmpty) products = null;
    } else if (rawProducts is Map && rawProducts['data'] is List) {
      products = (rawProducts['data'] as List)
          .whereType<Map>()
          .map((e) => OfferProduct.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      if (products.isEmpty) products = null;
    }

    List<Market>? markets;
    final rawMarkets = json['markets'];
    if (rawMarkets is List && rawMarkets.isNotEmpty) {
      markets = rawMarkets
          .whereType<Map>()
          .map((e) => Market.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return Offer(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      type: EnumValue.fromJson(Map<String, dynamic>.from(json['type'] as Map)),
      time: json['time']?.toString() ?? '',
      markets: markets,
      products: products,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'image': image,
    'type': type.toJson(),
    'time': time,
    if (markets != null) 'markets': markets!.map((e) => e.toJson()).toList(),
    if (products != null) 'products': products!.map((e) => e.toJson()).toList(),
  };
}

// ---------------------------------------------------------------------------
// Banner
// ---------------------------------------------------------------------------
class BannerItem {
  final int id;
  final String description;
  final String image;
  final EnumValue bannerType;
  final String? websiteUrl;
  final int? marketId;

  const BannerItem({
    required this.id,
    required this.description,
    required this.image,
    required this.bannerType,
    this.websiteUrl,
    this.marketId,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
    id: json['id'] as int,
    description: json['description'] as String,
    image: json['image'] as String,
    bannerType: EnumValue.fromJson(json['banner_type'] as Map<String, dynamic>),
    websiteUrl: json['website_url'] as String?,
    marketId: json['market_id'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'image': image,
    'banner_type': bannerType.toJson(),
    'website_url': websiteUrl,
    'market_id': marketId,
  };
}

// ---------------------------------------------------------------------------
// Section (simple)
// ---------------------------------------------------------------------------
class Section {
  final int id;
  final String name;
  final String image;

  /// Backend `SectionType`: `market` | `service` (plain string).
  final String type;

  /// Backend `route_key` for client navigation (hotel, mall, kioks, …).
  final String routeKey;

  const Section({
    required this.id,
    required this.name,
    required this.image,
    this.type = '',
    this.routeKey = '',
  });

  bool get isService => type == 'service';
  bool get isMarket => type == 'market';

  factory Section.fromJson(Map<String, dynamic> json) => Section(
        id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
        name: json['name']?.toString() ?? '',
        image: json['image']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
        routeKey: json['route_key']?.toString() ?? '',
      );
}

// ---------------------------------------------------------------------------
// Meal (simple)
// ---------------------------------------------------------------------------
class Meal {
  final int id;
  final String name;
  final String image;

  const Meal({required this.id, required this.name, required this.image});

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
  );
}

// ---------------------------------------------------------------------------
// Market (used for popular_brand & near_from_you)
// ---------------------------------------------------------------------------
class Market {
  final int id;
  final String name;
  final String mainImage;
  final bool isOpen;
  final String preparationTime;
  final String deliveryPrice;
  final String latitude;
  final String longitude;
  final String location;
  final int preOrder;
  final int rating;
  final EnumValue isStar;
  final EnumValue isPopular;
  final bool isFav;
  final EnumValue marketType;
  final double? distance; // Only present in near_from_you

  const Market({
    required this.id,
    required this.name,
    required this.mainImage,
    required this.isOpen,
    required this.preparationTime,
    required this.deliveryPrice,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.preOrder,
    required this.rating,
    required this.isStar,
    required this.isPopular,
    required this.isFav,
    required this.marketType,
    this.distance,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    EnumValue enumOrEmpty(dynamic raw) {
      if (raw is Map<String, dynamic>) return EnumValue.fromJson(raw);
      if (raw is Map) {
        return EnumValue.fromJson(Map<String, dynamic>.from(raw));
      }
      final v = raw?.toString() ?? '';
      return EnumValue(value: v, desc: v);
    }

    return Market(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: json['name']?.toString() ?? '',
      mainImage: json['main_image']?.toString() ?? json['image']?.toString() ?? '',
      isOpen: json['is_open'] == true || json['is_open'] == 1,
      preparationTime: json['preparation_time']?.toString() ?? '',
      deliveryPrice: json['delivery_price']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      location: json['location']?.toString() ??
          json['location_title']?.toString() ??
          '',
      preOrder: int.tryParse(json['pre_order']?.toString() ?? '') ?? 0,
      rating: int.tryParse(json['rating']?.toString() ?? '') ?? 0,
      isStar: enumOrEmpty(json['is_star']),
      isPopular: enumOrEmpty(json['is_popular']),
      isFav: json['is_fav'] == true || json['is_fav'] == 1,
      marketType: enumOrEmpty(json['market_type']),
      distance: json['distance'] != null
          ? double.tryParse(json['distance'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'main_image': mainImage,
    'is_open': isOpen,
    'preparation_time': preparationTime,
    'delivery_price': deliveryPrice,
    'latitude': latitude,
    'longitude': longitude,
    'location': location,
    'pre_order': preOrder,
    'rating': rating,
    'is_star': isStar.toJson(),
    'is_popular': isPopular.toJson(),
    'is_fav': isFav,
    'market_type': marketType.toJson(),
    if (distance != null) 'distance': distance,
  };
}

// ---------------------------------------------------------------------------
// HomeData — the `data` node
// ---------------------------------------------------------------------------
class HomeData {
  final List<Offer> offers;
  final List<BannerItem> banners;
  final List<Section> marketSections;
  final List<Section> serviceSections;
  final List<Meal> meals;
  final List<Market> popularBrand;
  final List<Market> nearFromYou;

  const HomeData({
    required this.offers,
    required this.banners,
    required this.marketSections,
    required this.serviceSections,
    required this.meals,
    required this.popularBrand,
    required this.nearFromYou,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    final marketSections = (json['market_sections'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => Section.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    final serviceSections = (json['service_sections'] as List<dynamic>? ?? [])
        .whereType<Map>()
        .map((e) => Section.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return HomeData(
      offers: (json['offers'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => Offer.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      banners: (json['banners'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => BannerItem.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      marketSections: marketSections,
      serviceSections: serviceSections,
      meals: (json['meals'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => Meal.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      popularBrand: (json['popular_brand'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => Market.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      nearFromYou: (json['near_from_you'] as List<dynamic>? ?? [])
          .whereType<Map>()
          .map((e) => Market.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// HomeResponse — top-level API wrapper
// ---------------------------------------------------------------------------
class HomeResponse {
  final String status;
  final String message;
  final HomeData data;

  const HomeResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) => HomeResponse(
    status: json['status']?.toString() ?? '',
    message: json['message']?.toString() ?? '',
    data: HomeData.fromJson(
      Map<String, dynamic>.from(json['data'] as Map? ?? const {}),
    ),
  );
}
