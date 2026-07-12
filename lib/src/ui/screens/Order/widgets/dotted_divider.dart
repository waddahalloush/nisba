import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// فاصل منقط (Dotted Divider) يُستخدم بين أقسام الكارد
class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: CustomPaint(
        size: Size(double.infinity, 1.h),
        painter: _DottedDividerPainter(color: cs.outlineVariant),
      ),
    );
  }
}

class _DottedDividerPainter extends CustomPainter {
  final Color color;

  const _DottedDividerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 4;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(
          (startX + dashWidth) > size.width ? size.width : startX + dashWidth,
          0,
        ),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedDividerPainter oldDelegate) =>
      color != oldDelegate.color;
}
