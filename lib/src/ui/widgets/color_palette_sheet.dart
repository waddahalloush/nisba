import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/configs/dimensions.dart';
import 'package:nisba_app/src/ui/widgets/color_palette_picker.dart';

/// A reusable color palette bottom sheet that lets the user pick
/// a brand color and returns it as a hex string (e.g. "#FC800A").
class ColorPaletteSheet extends StatelessWidget {
  const ColorPaletteSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 20.h,
        bottom: MediaQuery.of(context).padding.bottom + 20.h,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 5.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'choose_color'.tr,
            style: theme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ColorPalettePicker(
            onColorSelected: (Color color) {
              final hex =
                  '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
              Navigator.of(context).pop(hex);
            },
          ),
        ],
      ),
    );
  }

  /// Shows the color palette as a modal bottom sheet and returns
  /// the selected hex color string, or `null` if dismissed.
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ColorPaletteSheet(),
    );
  }
}
