import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/payment_flow_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewController extends GetxController {
  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  late final WebViewController webViewController;

  final isLoading = true.obs;
  final isCheckingStatus = false.obs;
  final statusLabel = 'auto_key_512'.tr.obs;

  String payUrl = '';
  String paymentRef = '';
  PaymentWebViewPurpose purpose = PaymentWebViewPurpose.order;
  int? orderId;

  Timer? _pollTimer;
  int _pollAttempts = 0;
  static const _maxPollAttempts = 40;
  bool _finished = false;

  @override
  void onInit() {
    super.onInit();
    _resolveArgs();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
          onPageFinished: (_) => isLoading.value = false,
          onNavigationRequest: (request) {
            _onUrl(request.url);
            return NavigationDecision.navigate;
          },
          onUrlChange: (change) {
            final url = change.url;
            if (url != null) _onUrl(url);
          },
        ),
      );

    if (payUrl.isNotEmpty) {
      webViewController.loadRequest(Uri.parse(payUrl));
      _startPolling();
    } else {
      statusLabel.value = 'auto_key_513'.tr;
      AppSnackbar.showError(message: 'auto_key_513'.tr);
    }
  }

  void _resolveArgs() {
    final args = Get.arguments;
    if (args is! Map) return;
    final map = Map<String, dynamic>.from(args);
    payUrl = map['pay_url']?.toString() ?? '';
    paymentRef = map['payment_ref']?.toString() ?? '';
    orderId = int.tryParse(map['order_id']?.toString() ?? '');
    final purposeRaw = map['purpose']?.toString() ?? 'order';
    purpose = purposeRaw == PaymentWebViewPurpose.wallet.name
        ? PaymentWebViewPurpose.wallet
        : PaymentWebViewPurpose.order;
  }

  void _onUrl(String url) {
    if (_finished) return;
    if (PaymentFlowHelper.isReturnUrl(url)) {
      statusLabel.value = 'auto_key_514'.tr;
      _checkStatus(force: true);
    }
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollAttempts = 0;
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkStatus();
    });
  }

  Future<void> _checkStatus({bool force = false}) async {
    if (_finished || paymentRef.isEmpty) return;
    if (isCheckingStatus.value && !force) return;
    if (_pollAttempts >= _maxPollAttempts) {
      _pollTimer?.cancel();
      statusLabel.value = 'auto_key_515'.tr;
      return;
    }
    _pollAttempts++;
    isCheckingStatus.value = true;
    try {
      if (!await connectionChecker.hasConnection) return;

      if (purpose == PaymentWebViewPurpose.wallet) {
        final res = await repository.chargeStatus(paymentRef);
        final data = ApiResult.ensureSuccess(res);
        final status = data is Map ? data['status']?.toString() : null;
        final charged = data is Map && data['wallet_charged'] == true;
        if (status == 'paid' || charged) {
          await _onSuccess(
            ApiResult.message(res).isNotEmpty
                ? ApiResult.message(res)
                : 'auto_key_68'.tr,
          );
          return;
        }
        if (status == 'failed' || status == 'cancelled') {
          await _onFailure(
            ApiResult.message(res).isNotEmpty
                ? ApiResult.message(res)
                : 'auto_key_516'.tr,
          );
          return;
        }
      } else {
        final res = await repository.paymentStatus(paymentRef);
        final data = ApiResult.ensureSuccess(res);
        final status = data is Map ? data['status']?.toString() : null;
        final paid = data is Map && data['order_paid'] == true;
        if (status == 'paid' || paid) {
          await _onSuccess(
            ApiResult.message(res).isNotEmpty
                ? ApiResult.message(res)
                : 'auto_key_486'.tr,
          );
          return;
        }
        if (status == 'failed' || status == 'cancelled') {
          await _onFailure(
            ApiResult.message(res).isNotEmpty
                ? ApiResult.message(res)
                : 'auto_key_516'.tr,
          );
          return;
        }
      }
      statusLabel.value = 'auto_key_512'.tr;
    } on DioException catch (e) {
      log('payment webview status: $e');
    } on ApiException catch (e) {
      log('payment webview status: ${e.message}');
    } catch (e) {
      log('payment webview status: $e');
    } finally {
      isCheckingStatus.value = false;
    }
  }

  Future<void> _onSuccess(String message) async {
    if (_finished) return;
    _finished = true;
    _pollTimer?.cancel();
    statusLabel.value = message;
    AppSnackbar.showSuccess(message: message);
    Get.back(result: true);
  }

  Future<void> _onFailure(String message) async {
    if (_finished) return;
    _finished = true;
    _pollTimer?.cancel();
    statusLabel.value = message;
    AppSnackbar.showError(message: message);
    Get.back(result: false);
  }

  Future<void> manualCheck() => _checkStatus(force: true);

  void closeWithoutFinish() {
    _pollTimer?.cancel();
    Get.back(result: false);
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}
