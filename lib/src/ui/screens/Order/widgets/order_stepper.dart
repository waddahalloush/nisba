import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// متتبع حالة الطلب (Stepper) مكون من 4 مراحل بخطوط منقطة
class OrderStepper extends StatelessWidget {
  final int currentStep;

  const OrderStepper({super.key, required this.currentStep});

  static const List<_StepData> _steps = [
    _StepData(title: 'تم استلام الطلب', icon: Icons.receipt_long_rounded),
    _StepData(title: 'جاري التحضير', icon: Icons.restaurant_rounded),
    _StepData(title: 'جاري التوصيل', icon: Icons.delivery_dining_rounded),
    _StepData(title: 'تم التوصيل', icon: Icons.check_circle_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(_steps.length, (i) {
        final isCompleted = i < currentStep;
        final isCurrent = i == currentStep;
        final isActive = isCompleted || isCurrent;

        return Expanded(
          child: Column(
            children: [
              // الدائرة مع الأيقونة
              Row(
                children: [
                  if (i > 0) Expanded(child: _buildDottedLine(cs, isCompleted)),
                  Container(
                    width: 32.r,
                    height: 32.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? cs.primary : cs.surfaceContainerHighest,
                      border: Border.all(
                        color: isActive ? cs.primary : cs.outlineVariant,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      _steps[i].icon,
                      size: 16.sp,
                      color: isActive
                          ? cs.onPrimary
                          : cs.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                  if (i < _steps.length - 1)
                    Expanded(child: _buildDottedLine(cs, i < currentStep)),
                ],
              ),
              SizedBox(height: 6.h),
              // العنوان أسفل الدائرة
              Text(
                _steps[i].title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9.sp,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive
                      ? cs.primary
                      : cs.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDottedLine(ColorScheme cs, bool isActive) {
    return CustomPaint(
      size: Size(double.infinity, 2.h),
      painter: _DottedLinePainter(
        color: isActive ? cs.primary : cs.outlineVariant,
      ),
    );
  }
}

class _StepData {
  final String title;
  final IconData icon;

  const _StepData({required this.title, required this.icon});
}

/// رسام الخط المنقط بين مراحل الـ Stepper
class _DottedLinePainter extends CustomPainter {
  final Color color;

  const _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const double dashWidth = 4;
    const double dashSpace = 3;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, size.height / 2),
        Offset(
          (startX + dashWidth) > size.width ? size.width : startX + dashWidth,
          size.height / 2,
        ),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedLinePainter oldDelegate) =>
      color != oldDelegate.color;
}
