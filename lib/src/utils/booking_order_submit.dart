import 'package:get/get.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/payment_flow_helper.dart';

/// Shared post-store handling for booking screens (hotel/cinema/entertainment).
class BookingOrderSubmit {
  BookingOrderSubmit._();

  static int? _orderIdFrom(dynamic data) {
    if (data is! Map) return null;
    final direct = data['order_id'];
    if (direct != null) return int.tryParse(direct.toString());
    final order = data['order'];
    if (order is Map) {
      return int.tryParse(order['id']?.toString() ?? '');
    }
    return null;
  }

  /// Returns true if the flow finished successfully (paid or no gateway needed).
  static Future<bool> afterStore({
    required dynamic storeResponse,
    required String successFallback,
  }) async {
    final data = ApiResult.ensureSuccess(storeResponse);
    final orderId = _orderIdFrom(data);

    final gateway = await PaymentFlowHelper.openIfNeeded(
      data: data is Map ? data : storeResponse,
      purpose: PaymentWebViewPurpose.order,
      orderId: orderId,
    );

    switch (gateway) {
      case PaymentGatewayResult.paid:
        AppSnackbar.showSuccess(message: 'auto_key_486'.tr);
        Get.back();
        return true;
      case PaymentGatewayResult.notNeeded:
        final msg = ApiResult.message(storeResponse);
        AppSnackbar.showSuccess(
          message: msg.isNotEmpty ? msg : successFallback,
        );
        Get.back();
        return true;
      case PaymentGatewayResult.dismissed:
        AppSnackbar.showInfo(
          message: 'auto_key_692'.tr,
        );
        Get.back();
        return false;
      case PaymentGatewayResult.unavailable:
        AppSnackbar.showError(message: 'auto_key_67'.tr);
        return false;
    }
  }

  static Future<bool> storeAndSettle({
    required Repository repository,
    required Map body,
    required String successFallback,
  }) async {
    final res = await repository.storeOrder(body: body);
    return afterStore(storeResponse: res, successFallback: successFallback);
  }
}
