import 'package:flutter/material.dart';

class AppColors {
  /// � Primary (اللون الرئيسي)
  static const Color primaryColor = Color(0xFFFC800A); //67021e

  /// 🟣 Secondary
  static const Color secondaryColor = Color(0xFF6C63FF);

  /// ⚠️ Error
  static const Color errorColor = Color(0xFFEB5757);

  /// ✅ Success
  static const Color successColor = Color(0xFF27AE60);

  /// 🟡 Warning
  static const Color warningColor = Color(0xFFF2C94C);

  /// 🌫️ Background (مثل التصميم)
  static const Color bgColor = Color(0xFFF7F8FC);

  /// ⚪ White
  static const Color white = Colors.white;

  /// ⚫ Black
  static const Color black = Colors.black;

  /// 🪶 Grey درجات
  static const Color grey = Color(0xFF828282);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color extraLightGrey = Color(0xFFF2F2F2);

  /// 🧊 Card
  static const Color cardColor = Colors.white;

  /// 🌙 Dark Mode Colors
  static const Color darkBg = Color(0xFF121212);
  static const Color darkCard = Color(0xFF1E1E1E);

  /// 🔲 Divider
  static const Color divider = Color(0xFFE6E6E6);

  /// 🔘 Icon Background (دوائر الأيقونات)
  static const Color iconBg = Color(0xFFF1F3F6);

  /// ⭐ Rating (نجوم)
  static const Color star = Color(0xFFFFC107);

  /// 🛍️ Discount / Highlight
  static const Color highlight = Color(0xFFFF6F61);

  /// 📘 Facebook brand color
  static const Color facebookColor = Color(0xFF1877F2);

  /// 🔍 Search Field Background
  static const Color searchBg = Colors.white;

  /// 🌊 Shadow (خفيف جدًا)
  static Color shadow = Colors.black.withValues(alpha: 0.05);

  /// 💡 Lighten a [color] by [amount] (0.0 = same, 1.0 = white)
  static Color lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// 🌑 Darken a [color] by [amount] (0.0 = same, 1.0 = black)
  static Color darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}
