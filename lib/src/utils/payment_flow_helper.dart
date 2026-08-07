import 'package:get/get.dart';
import 'package:nisba_app/src/routes/routes_names.dart';

enum PaymentWebViewPurpose { order, wallet }

enum PaymentGatewayResult {
  /// No hosted checkout — cash/wallet/points completed in API.
  notNeeded,
  /// User finished and status became paid.
  paid,
  /// WebView opened then closed without confirmed payment.
  dismissed,
  /// pending but missing pay_url / payment_ref.
  unavailable,
}

/// Opens SkipCash hosted checkout when API returns `pay_url` + `payment_pending`.
class PaymentFlowHelper {
  PaymentFlowHelper._();

  static Map<String, dynamic>? extractPayment(dynamic data) {
    if (data is! Map) return null;
    final payment = data['payment'];
    if (payment is Map) {
      return Map<String, dynamic>.from(payment);
    }
    // Wallet charge returns payment fields at data root.
    if (data['pay_url'] != null || data['payment_ref'] != null) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  static bool isPaymentPending(dynamic data) {
    if (data is! Map) return false;
    if (data['payment_pending'] == true) return true;
    final payment = extractPayment(data);
    return payment != null &&
        (payment['requires_webview'] == true ||
            (payment['pay_url']?.toString().isNotEmpty ?? false));
  }

  static String? payUrl(dynamic data) {
    final payment = extractPayment(data);
    final url = payment?['pay_url']?.toString();
    if (url != null && url.isNotEmpty) return url;
    return null;
  }

  static String? paymentRef(dynamic data) {
    final payment = extractPayment(data);
    final ref = payment?['payment_ref']?.toString();
    if (ref != null && ref.isNotEmpty) return ref;
    return data is Map ? data['payment_ref']?.toString() : null;
  }

  static Future<PaymentGatewayResult> openIfNeeded({
    required dynamic data,
    required PaymentWebViewPurpose purpose,
    int? orderId,
  }) async {
    if (!isPaymentPending(data)) return PaymentGatewayResult.notNeeded;

    final url = payUrl(data);
    final ref = paymentRef(data);
    if (url == null || url.isEmpty || ref == null || ref.isEmpty) {
      return PaymentGatewayResult.unavailable;
    }

    final resolvedOrderId = orderId ??
        (data is Map
            ? int.tryParse(
                data['order_id']?.toString() ??
                    (data['order'] is Map
                        ? data['order']['id']?.toString() ?? ''
                        : '') ??
                    '',
              )
            : null);

    final result = await Get.toNamed(
      AppRoutesNames.paymentWebView,
      arguments: {
        'pay_url': url,
        'payment_ref': ref,
        'purpose': purpose.name,
        if (resolvedOrderId != null) 'order_id': resolvedOrderId,
      },
    );

    return result == true
        ? PaymentGatewayResult.paid
        : PaymentGatewayResult.dismissed;
  }

  /// Hosts / paths that mean the user left SkipCash hosted page.
  static bool isReturnUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains('payments/success') ||
        lower.contains('payment/return') ||
        lower.contains('payment/success') ||
        lower.contains('nisbaa.com/payments') ||
        lower.startsWith('myapp://') ||
        lower.startsWith('nisba://');
  }
}
