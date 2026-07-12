import 'package:flutter/material.dart';
import 'package:nisba_app/src/configs/dimensions.dart';

/// A grid of brand-color tiles the user can tap to select.
///
/// [onColorSelected] fires with the chosen [Color] on tap.
/// Designed to work in both light and dark themes.
class ColorPalettePicker extends StatelessWidget {
  const ColorPalettePicker({super.key, required this.onColorSelected});

  /// Called when the user taps a color tile.
  final ValueChanged<Color> onColorSelected;

  /// The palette of brand colors available for selection.
  static const List<Color> palette = [
    // Row 1 — Warm & Earthy
    Color(0xFFFC800A), // Amber/Orange (default)
    Color(0xFFE65100), // Deep Orange
    Color(0xFFFF6D00), // Bright Orange
    Color(0xFFF4511E), // Red-Orange
    Color(0xFFD84315), // Burnt Orange
    // Row 2 — Reds & Pinks
    Color(0xFFC62828), // Deep Red
    Color(0xFFE53935), // Red
    Color(0xFFAD1457), // Crimson
    Color(0xFFE91E63), // Pink
    Color(0xFFEC407A), // Light Pink
    // Row 3 — Purples & Indigos
    Color(0xFF7B1FA2), // Purple
    Color(0xFF8E24AA), // Deep Purple
    Color(0xFF6A1B9A), // Dark Purple
    Color(0xFF3F51B5), // Indigo
    Color(0xFF5C6BC0), // Light Indigo
    // Row 4 — Blues
    Color(0xFF1565C0), // Dark Blue
    Color(0xFF1976D2), // Blue
    Color(0xFF1E88E5), // Bright Blue
    Color(0xFF0288D1), // Sky Blue
    Color(0xFF0097A7), // Cyan
    // Row 5 — Teals & Greens
    Color(0xFF00796B), // Teal
    Color(0xFF00897B), // Light Teal
    Color(0xFF2E7D32), // Green
    Color(0xFF43A047), // Bright Green
    Color(0xFF388E3C), // Forest Green
    // Row 6 — Limes & Yellows
    Color(0xFF689F38), // Light Green
    Color(0xFFAFB42B), // Lime
    Color(0xFFFDD835), // Yellow
    Color(0xFFFFB300), // Amber
    Color(0xFFFF8F00), // Dark Amber
    // Row 7 — Browns & Greys
    Color(0xFF795548), // Brown
    Color(0xFF6D4C41), // Dark Brown
    Color(0xFF546E7A), // Blue Grey
    Color(0xFF455A64), // Dark Blue Grey
    Color(0xFF37474F), // Charcoal
    // Row 8 — Accents
    Color(0xFF212121), // Almost Black
    Color(0xFF424242), // Dark Grey
    Color(0xFF616161), // Grey
    Color(0xFF9E9E9E), // Light Grey
    Color(0xFFBDBDBD), // Very Light Grey
  ];

  static const int _columns = 5;
  static const double _tileSpacing = 10;
  static const double _tileRadius = 14;
  static const double _tileSize = 56;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _columns,
        mainAxisSpacing: _tileSpacing,
        crossAxisSpacing: _tileSpacing,
        childAspectRatio: 1,
      ),
      itemCount: palette.length,
      itemBuilder: (context, index) {
        final color = palette[index];
        return _ColorTile(color: color, onTap: () => onColorSelected(color));
      },
    );
  }
}

class _ColorTile extends StatelessWidget {
  const _ColorTile({required this.color, required this.onTap});

  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ColorPalettePicker._tileRadius.r),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              ColorPalettePicker._tileRadius.r,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.35),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
