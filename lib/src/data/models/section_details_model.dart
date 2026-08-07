// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'Home/home_model.dart';
import 'Home/notification_model.dart';

// ---------------------------------------------------------------------------
// Tag — used in sections response (tags array)
// ---------------------------------------------------------------------------
class SectionTag {
  final int id;
  final String name;
  final String image;

  const SectionTag({required this.id, required this.name, required this.image});

  factory SectionTag.fromJson(Map<String, dynamic> json) => SectionTag(
    id: json['id'] as int,
    name: json['name'] as String,
    image: json['image'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'image': image};
}

// ---------------------------------------------------------------------------
// SectionData — the `data` node of sections API response
// ---------------------------------------------------------------------------
class SectionData {
  final List<Offer> offers;
  final List<Market> popularStores;
  final List<SectionTag> tags;
  final List<Market> stores;
  final Pagination pagination;

  const SectionData({
    required this.offers,
    required this.popularStores,
    required this.tags,
    required this.stores,
    required this.pagination,
  });

  factory SectionData.fromJson(Map<String, dynamic> json) => SectionData(
    offers: (json['offers'] as List<dynamic>)
        .map((e) => Offer.fromJson(e as Map<String, dynamic>))
        .toList(),
    popularStores: (json['popular_stores'] as List<dynamic>)
        .map((e) => Market.fromJson(e as Map<String, dynamic>))
        .toList(),
    tags: (json['tags'] as List<dynamic>)
        .map((e) => SectionTag.fromJson(e as Map<String, dynamic>))
        .toList(),
    stores: (json['stores'] as List<dynamic>)
        .map((e) => Market.fromJson(e as Map<String, dynamic>))
        .toList(),
    pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
  );

  Map<String, dynamic> toJson() => {
    'offers': offers.map((e) => e.toJson()).toList(),
    'popular_stores': popularStores.map((e) => e.toJson()).toList(),
    'tags': tags.map((e) => e.toJson()).toList(),
    'stores': stores.map((e) => e.toJson()).toList(),
    'pagination': pagination.toJson(),
  };
}

// ---------------------------------------------------------------------------
// SectionDetailsResponse — top-level API envelope
// ---------------------------------------------------------------------------
class SectionDetailsResponse {
  final String status;
  final String message;
  final SectionData? data;

  const SectionDetailsResponse({
    required this.status,
    required this.message,
    this.data,
  });

  bool get isSuccess => status == 'success';

  factory SectionDetailsResponse.fromApiMap(Map raw) {
    final map = Map<String, dynamic>.from(raw);
    SectionData? data;
    if (map['data'] is Map) {
      data = SectionData.fromJson(map['data'] as Map<String, dynamic>);
    }
    return SectionDetailsResponse(
      status: map['status']?.toString() ?? '',
      message: map['message']?.toString() ?? '',
      data: data,
    );
  }
}
