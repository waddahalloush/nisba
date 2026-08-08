import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nisba_app/src/data/local/constants/storages.dart';
import 'package:nisba_app/src/data/local/get_storage_helper.dart';
import 'package:nisba_app/src/data/repository.dart';
import 'package:nisba_app/src/routes/routes_names.dart';
import 'package:nisba_app/src/utils/api_result.dart';
import 'package:nisba_app/src/utils/app_snackbar.dart';
import 'package:nisba_app/src/utils/dio_error_util.dart';

class ScannerController extends GetxController {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  var isFlashOn = false.obs;
  var isHandling = false.obs;

  final GetStorageHelper storageHelper = Get.find();
  final Repository repository = Get.find();
  final InternetConnectionChecker connectionChecker = Get.find();

  void toggleFlash() async {
    await cameraController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  void onBarcodeDetected(BarcodeCapture capture) {
    if (isHandling.value) return;
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final code = barcode.rawValue?.trim();
      if (code == null || code.isEmpty) continue;
      isHandling.value = true;
      _handleScannedCode(code);
      break;
    }
  }

  Future<void> _handleScannedCode(String code) async {
    try {
      if (_looksLikeUserQr(code)) {
        await Get.toNamed(
          AppRoutesNames.giftCredit,
          arguments: {'qr': code},
        );
      } else {
        await storageHelper.write(Storages.scannedOrderQr, code);
        await _openOrderPaymentPage(code);
      }
    } finally {
      Future.delayed(const Duration(seconds: 2), () {
        isHandling.value = false;
      });
    }
  }

  /// Resolves an order QR to its order via `openPaymentPage`, then routes
  /// to the payment screen with the order + client data.
  Future<void> _openOrderPaymentPage(String code) async {
    if (!await connectionChecker.hasConnection) {
      AppSnackbar.showError(message: 'check_connection'.tr);
      return;
    }
    try {
      final res = await repository.openPaymentPage(data: {'qr': code});
      final data = ApiResult.ensureSuccess(res);
      final order = data is Map ? data['order'] : null;
      final client = data is Map ? data['client'] : null;
      if (order is! Map || order.isEmpty) {
        AppSnackbar.showInfo(title: 'auto_key_519'.tr, message: code);
        return;
      }
      await Get.toNamed(
        AppRoutesNames.payment,
        arguments: {'order': order, 'client': client, 'qr': code},
      );
    } on ApiException catch (e) {
      AppSnackbar.showError(message: e.message);
    } on DioException catch (e) {
      AppSnackbar.showError(message: DioErrorUtil.handleError(e));
    } catch (e) {
      log('openPaymentPage: $e');
    }
  }

  /// User gift QR codes are typically UUID-like or long alphanumeric tokens.
  /// Order payment QR codes are often shorter numeric / prefixed order codes.
  bool _looksLikeUserQr(String code) {
    final lower = code.toLowerCase();
    if (lower.startsWith('user:') ||
        lower.startsWith('gift:') ||
        lower.startsWith('nisba-user')) {
      return true;
    }
    final uuidLike = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    if (uuidLike.hasMatch(code)) return true;
    // Long alphanumeric (not pure digits) → treat as user QR
    if (code.length >= 16 && !RegExp(r'^\d+$').hasMatch(code)) {
      return true;
    }
    return false;
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}
