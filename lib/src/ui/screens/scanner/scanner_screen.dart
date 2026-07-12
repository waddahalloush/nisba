import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

import 'scanner_controller.dart';

class ScannerScreen extends GetView<ScannerController> {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 8.h),
                _buildHeader(theme),
                SizedBox(height: 12.h),
                _buildScannerViewport(context, theme),
                SizedBox(height: 12.h),
                _buildTipsSection(theme),
                SizedBox(height: 12.h),
                _buildBottomSupportCard(theme),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Iconsax.arrow_right_1, color: theme.colorScheme.onPrimary),
          style: IconButton.styleFrom(
            backgroundColor: primaryColor,
            padding: EdgeInsets.all(12.r),
          ),
        ),
        Column(
          children: [
            Text(
              'مسح الباركود',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'وجّه الكاميرا نحو الباركود داخل الإطار',
              style: TextStyle(
                fontSize: 13.sp,
                color: onSurface.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Iconsax.lamp_charge, color: primaryColor),
          style: IconButton.styleFrom(
            side: BorderSide(color: theme.colorScheme.outlineVariant),
            padding: EdgeInsets.all(12.r),
          ),
        ),
      ],
    );
  }

  Widget _buildScannerViewport(BuildContext context, ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    final double viewportHeight = MediaQuery.of(context).size.height * 0.45;

    return Container(
      height: viewportHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        color: theme.colorScheme.onSurface,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          MobileScanner(
            controller: controller.cameraController,
            onDetect: controller.onBarcodeDetected,
          ),
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.all(36.r),
              child: CustomPaint(
                painter: ScannerOverlayPainter(lineColor: primaryColor),
              ),
            ),
          ),
          Positioned(
            top: 16.h,
            left: 0,
            right: 0,
            child: Center(
              child: Obx(() {
                final bool isFlash = controller.isFlashOn.value;
                return ElevatedButton.icon(
                  onPressed: controller.toggleFlash,
                  icon: Icon(
                    isFlash ? Iconsax.flash_15 : Iconsax.flash_1,
                    size: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                  label: Text(
                    'فلاش',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    elevation: 0,
                    shape: const StadiumBorder(),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 8.h,
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Iconsax.scan_barcode,
                      color: theme.colorScheme.surface,
                      size: 20,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'سيتعرف تلقائياً على الباركود',
                      style: TextStyle(
                        color: theme.colorScheme.surface,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipsSection(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نصائح للمسح',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildTipCard(
                theme,
                icon: Iconsax.scan_barcode,
                title: 'وضوح الباركود',
                desc: 'تأكد من أن الباركود واضح وخالي من التشويش',
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildTipCard(
                theme,
                icon: Iconsax.sun_1,
                title: 'إضاءة مناسبة',
                desc: 'تأكد من وجود إضاءة كافية وتجنب الانعكاسات',
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _buildTipCard(
                theme,
                icon: Iconsax.mobile,
                title: 'ثبت الجهاز',
                desc: 'حافظ على ثبات الجهاز للحصول على أفضل نتيجة',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTipCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String desc,
  }) {
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: primaryColor.withValues(alpha: 0.1),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp,
              color: onSurface,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            desc,
            style: TextStyle(
              fontSize: 10.sp,
              color: onSurface.withValues(alpha: 0.55),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSupportCard(ThemeData theme) {
    final primaryColor = theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Iconsax.barcode,
              color: onSurface.withValues(alpha: 0.87),
              size: 36,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'يدعم أنواع متعددة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: primaryColor,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'يدعم التطبيق مسح جميع أنواع الباركود بما في ذلك QR و Code2 و EAN ووغيرها',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: onSurface.withValues(alpha: 0.55),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Icon(Iconsax.shield_security, color: primaryColor, size: 28),
        ],
      ),
    );
  }
}

/// Helper Custom Painter to render the bounding reticle brackets and scanning line
class ScannerOverlayPainter extends CustomPainter {
  final Color lineColor;
  ScannerOverlayPainter({required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double cornerLength = 24.0;

    // Top-Left corner bracket
    canvas.drawPath(
      Path()
        ..moveTo(0, cornerLength)
        ..lineTo(0, 0)
        ..lineTo(cornerLength, 0),
      paint,
    );

    // Top-Right corner bracket
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width, cornerLength),
      paint,
    );

    // Bottom-Left corner bracket
    canvas.drawPath(
      Path()
        ..moveTo(0, size.height - cornerLength)
        ..lineTo(0, size.height)
        ..lineTo(cornerLength, size.height),
      paint,
    );

    // Bottom-Right corner bracket
    canvas.drawPath(
      Path()
        ..moveTo(size.width - cornerLength, size.height)
        ..lineTo(size.width, size.height)
        ..lineTo(size.width, size.height - cornerLength),
      paint,
    );

    // Animated/Static Laser Line down the middle
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerHeight = size.height / 2;
    canvas.drawLine(
      Offset(0, centerHeight),
      Offset(size.width, centerHeight),
      linePaint,
    );

    // Center laser pin node
    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, centerHeight), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
