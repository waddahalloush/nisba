import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmerWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;

  const CustomShimmerWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  /// كود مصنّع (Factory) مخصص لعمل Shimmer دائري بسهولة (مثل الصور الشخصية)
  factory CustomShimmerWidget.circular({
    required double size,
  }) {
    return CustomShimmerWidget(
      width: size,
      height: size,
      shape: BoxShape.circle,
    );
  }

  @override
  Widget build(BuildContext context) {
    // جلب الـ ColorScheme الخاص بالثيم الحالي للتطبيق
    final scheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHigh,
      highlightColor: scheme.surfaceContainerLow,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: scheme.surface,
          shape: shape,
          // لا يتم تطبيق الـ borderRadius إذا كان الشكل دائرياً لتجنب الأخطاء
          borderRadius: shape == BoxShape.circle 
              ? null 
              : (borderRadius ?? BorderRadius.circular(8)), // القيمة الافتراضية للحواف الدائرية
        ),
      ),
    );
  }
}