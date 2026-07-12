import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerController extends GetxController {
  // Mobile scanner controller instance
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  // Observable for flash state tracking
  var isFlashOn = false.obs;

  /// Toggles the device flashlight
  void toggleFlash() async {
    await cameraController.toggleTorch();
    isFlashOn.value = !isFlashOn.value;
  }

  /// Handles barcode detection events
  void onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final String code = barcode.rawValue!;
        // Handle your business logic here (e.g., navigation, API call)
        print('Barcode found: $code');
        
        // Example: Get.back(result: code);
        break; 
      }
    }
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }
}