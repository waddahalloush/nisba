import 'package:get/get.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';

/// Loads delivery/payment methods from `GET /markets/{id}` for booking screens.
class BookingCheckoutOptions {
  String deliveryType = 'at_provider';
  String paymentMethod = 'wallet';
  List<String> deliveryTypes = const [];
  List<String> paymentMethods = const [];

  static String _enumValue(dynamic raw) {
    if (raw is Map) return raw['value']?.toString() ?? '';
    return raw?.toString() ?? '';
  }

  Future<void> loadFromMarket(Repository repository, int marketId) async {
    if (marketId <= 0) return;
    try {
      final res = await repository.getMarketDetails(marketId);
      final data = ApiResult.ensureSuccess(res);
      if (data is! Map) return;
      final store = data['store'];
      if (store is! Map) return;

      final dts = (store['delivery_types'] as List? ?? [])
          .map(_enumValue)
          .where((e) => e.isNotEmpty)
          .toList();
      final pms = (store['payment_methods'] as List? ?? [])
          .map(_enumValue)
          .where((e) => e.isNotEmpty)
          .toList();

      deliveryTypes = dts;
      paymentMethods = pms;

      if (dts.contains('at_provider')) {
        deliveryType = 'at_provider';
      } else if (dts.isNotEmpty) {
        deliveryType = dts.first;
      }

      if (pms.contains('wallet')) {
        paymentMethod = 'wallet';
      } else if (pms.contains('cash')) {
        paymentMethod = 'cash';
      } else if (pms.contains('card')) {
        paymentMethod = 'card';
      } else if (pms.isNotEmpty) {
        paymentMethod = pms.first;
      }
    } catch (_) {
      // Keep defaults — booking can still submit with at_provider/wallet.
    }
  }

  static String labelForPayment(String value) {
    switch (value) {
      case 'wallet':
        return 'wallet'.tr;
      case 'cash':
        return 'cash'.tr;
      case 'card':
        return 'card'.tr;
      case 'point':
        return 'points'.tr;
      case 'google_pay':
        return 'Google Pay';
      case 'apple_pay':
        return 'Apple Pay';
      default:
        return value;
    }
  }

  static String labelForDelivery(String value) {
    switch (value) {
      case 'at_provider':
        return 'at_provider'.tr;
      case 'to_home':
        return 'auto_key_282'.tr;
      case 'to_car':
        return 'to_car'.tr;
      case 'pickup':
        return 'pickup'.tr;
      default:
        return value;
    }
  }
}
