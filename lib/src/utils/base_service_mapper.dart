import 'package:get/get.dart';
import 'package:nisba_app/generated/assets.gen.dart';

import '../data/models/service_model.dart';

/// Maps raw Laravel catalog maps into [BaseServiceItem] safely.
class BaseServiceMapper {
  static BaseServiceItem fromMarket(
    Map raw, {
    required String serviceType,
    String? category,
    String? fallbackImage,
  }) {
    final map = Map<String, dynamic>.from(raw);
    final marketType = map['market_type'];
    final typeValue = marketType is Map
        ? marketType['value']?.toString()
        : marketType?.toString();
    final typeDesc = marketType is Map ? marketType['desc']?.toString() : null;

    final distanceRaw = map['distance'];
    final distance = distanceRaw == null ? '' : 'auto_key_691'.tr;

    return BaseServiceItem(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      subTitle: map['location']?.toString() ?? '',
      aboutText: map['location']?.toString() ?? '',
      imageUrl:
          map['main_image']?.toString() ??
          map['image']?.toString() ??
          fallbackImage ??
          Assets.images.sooq1.path,
      address: map['location']?.toString() ?? '',
      rating: double.tryParse(map['rating']?.toString() ?? '') ?? 0,
      reviewsCount: 0,
      distance: distance,
      category: category ?? typeDesc ?? serviceType,
      serviceType: typeValue ?? serviceType,
      hours: map['is_open'] == true ? 'auto_key_280'.tr : 'auto_key_281'.tr,
      features: const [],
    );
  }

  static BaseServiceItem fromMallOrCenter(
    Map raw,
    dynamic iconsax, {
    required String serviceType,
    String category = 'all',
    String? fallbackImage,
  }) {
    final map = Map<String, dynamic>.from(raw);
    final location =
        map['location']?.toString() ?? map['location_title']?.toString() ?? '';
    final distanceRaw = map['distance'];
    final distance = distanceRaw == null ? '' : 'auto_key_691'.tr;
    final isOpen = map['is_open'];
    String? hours;
    if (isOpen == true) {
      hours = 'auto_key_280'.tr;
    } else if (isOpen == false) {
      hours = 'auto_key_281'.tr;
    } else if (map['opening_time'] != null || map['close_time'] != null) {
      hours = '${map['opening_time'] ?? ''} - ${map['close_time'] ?? ''}'
          .trim();
    }

    return BaseServiceItem(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      subTitle: location.isNotEmpty
          ? location
          : (map['name']?.toString() ?? ''),
      aboutText: map['description']?.toString() ?? location,
      imageUrl:
          map['image']?.toString() ??
          map['main_image']?.toString() ??
          fallbackImage ??
          Assets.images.mall11.path,
      address: location,
      rating: double.tryParse(map['rating']?.toString() ?? '') ?? 0,
      reviewsCount: 0,
      distance: distance,
      category: category,
      serviceType: serviceType,
      hours: hours,
      features: [
        if (map['has_parking'] == true)
          ServiceFeature(icon: iconsax.car, label: 'auto_key_309'.tr),
      ],
    );
  }
}
