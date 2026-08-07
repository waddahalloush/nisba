import 'package:get/get.dart';
import 'package:nisba_app/src/data/models/service_model.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// Routes a market by its Laravel [MarketType] value to the matching flow.
class MarketTypeRouter {
  static void open(String? marketType, {dynamic arguments}) {
    final type = _normalize(marketType);

    switch (type) {
      case 'store':
        Get.toNamed(AppRoutesNames.restorantDetails, arguments: arguments);
        break;
      case 'cinema':
        Get.toNamed(AppRoutesNames.cinemaBooking, arguments: arguments);
        break;
      case 'hotel':
        Get.toNamed(AppRoutesNames.hotelBooking, arguments: arguments);
        break;
      case 'entertainment':
      case 'transport':
        Get.toNamed(AppRoutesNames.entertainmentBooking, arguments: arguments);
        break;
      case 'service':
        Get.toNamed(AppRoutesNames.placeDetails, arguments: arguments);
        break;
      case 'kioks':
        // Kioks are product-order vendors (same checkout as store).
        Get.toNamed(AppRoutesNames.restorantDetails, arguments: arguments);
        break;
      case 'mall':
        Get.toNamed(AppRoutesNames.mallDetails, arguments: arguments);
        break;
      case 'commercial_center':
        Get.toNamed(AppRoutesNames.placeDetails, arguments: arguments);
        break;
      default:
        Get.toNamed(AppRoutesNames.placeDetails, arguments: arguments);
    }
  }

  /// Convenience for list cards that already hold a [BaseServiceItem].
  static void openItem(BaseServiceItem item) =>
      open(item.serviceType, arguments: item);

  static String _normalize(String? raw) {
    final v = (raw ?? '').trim().toLowerCase();
    // Legacy UI labels from mock data
    switch (v) {
      case 'market':
        return 'store';
      case 'gift':
      case 'gifts':
      case 'beauty':
      case 'tourism':
        return 'service';
      case 'entertain':
        return 'entertainment';
      default:
        return v;
    }
  }
}
