import 'package:get/get.dart';
import 'package:nisba_app/src/configs/app_enums.dart';
import 'package:nisba_app/src/data/models/Home/home_model.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

/// Routes a home service [Section] by its backend `route_key`.
///
/// - Booking / health / tourism / gifts: `/service-section`
/// - Mall: `/mall`
/// - Commercial centers: `/commercial-centers`
/// - Kiosk: `/kioks`
class ServiceSectionNavigator {
  ServiceSectionNavigator._();

  static void open(Section section) {
    final key = section.routeKey.trim().toLowerCase();

    switch (key) {
      case AppEnums.sectionRouteMall:
        Get.toNamed(
          AppRoutesNames.mall,
          arguments: {'section': section},
        );
        return;
      case AppEnums.sectionRouteCommercialCenter:
        Get.toNamed(
          AppRoutesNames.commercialCenters,
          arguments: {'section': section},
        );
        return;
      case AppEnums.sectionRouteKioks:
      case 'kiosk':
        Get.toNamed(
          AppRoutesNames.kioks,
          arguments: {'section': section},
        );
        return;
      case AppEnums.sectionRouteStore:
      case AppEnums.sectionRouteGrocery:
      case AppEnums.sectionRouteCafe:
        Get.toNamed(
          AppRoutesNames.restorant,
          arguments: {'section': section},
        );
        return;
      case AppEnums.sectionRouteHotel:
      case AppEnums.sectionRouteCinema:
      case AppEnums.sectionRouteEntertainment:
      case AppEnums.sectionRouteTransport:
      case AppEnums.sectionRouteService:
        Get.toNamed(
          AppRoutesNames.serviceSection,
          arguments: {
            'section': section,
            'market_type': key,
          },
        );
        return;
      case AppEnums.sectionRouteTourism:
      case AppEnums.sectionRouteGifts:
        // No MarketType twin — list vendors by section_id only.
        Get.toNamed(
          AppRoutesNames.serviceSection,
          arguments: {'section': section},
        );
        return;
      default:
        Get.toNamed(
          AppRoutesNames.serviceSection,
          arguments: {'section': section},
        );
    }
  }
}
