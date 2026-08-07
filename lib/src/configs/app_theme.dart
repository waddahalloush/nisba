import 'package:flutter/material.dart';
import 'package:nisba_app/generated/fonts.gen.dart';
import 'package:nisba_app/src/configs/app_colors.dart';
import 'package:nisba_app/src/configs/theme_extensions.dart';

import 'dimensions.dart';

String? appFont = FontFamily.notoSansArabic;

class ThemesData {
  static ThemeData lightTheme(Color primaryColor) =>
      _buildLightTheme(primaryColor);
  static ThemeData darkTheme(Color primaryColor) =>
      _buildDarkTheme(primaryColor);

  static ThemeData _buildLightTheme(Color primaryColor) {
    final scheme = ColorScheme.light(
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFFFF3E0),
      onPrimaryContainer: const Color(0xFF1A1A1A),
      secondary: AppColors.secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFFFFF8E1),
      onSecondaryContainer: const Color(0xFF8D6E32),
      tertiary: AppColors.star,
      onTertiary: Colors.black,
      surface: Colors.white,
      onSurface: const Color(0xFF1A1A1A),
      surfaceContainerHighest: Colors.white,
      surfaceContainerHigh: const Color(0xFFF2F4F8),
      error: AppColors.errorColor,
      onError: Colors.white,
      outline: AppColors.divider,
      outlineVariant: const Color(0xFFE0E4EB),
      shadow: Colors.black,
      inverseSurface: const Color(0xFF1E2740),
      onInverseSurface: Colors.white,
      primaryFixed: AppColors.primaryRose,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: appFont,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: scheme.surface,
      hintColor: AppColors.grey.withValues(alpha: 0.6),
      dividerColor: scheme.outline,
      extensions: const [ZatheExtras.light],
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: TextStyle(
          color: scheme.onSurface.withValues(alpha: 0.45),
          fontFamily: appFont,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.45)),
        ),
      ),
      iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return scheme.onPrimary;
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return scheme.primary.withValues(alpha: 0.45);
          }
          return scheme.surfaceContainerHigh;
        }),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w800,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        titleMedium: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        titleSmall: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          color: scheme.onSurface.withValues(alpha: 0.78),
          fontFamily: appFont,
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp,
          color: scheme.onSurface.withValues(alpha: 0.55),
          fontFamily: appFont,
        ),
        labelLarge: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        labelMedium: TextStyle(
          fontSize: 12.sp,
          color: scheme.onSurface.withValues(alpha: 0.7),
          fontFamily: appFont,
        ),
        labelSmall: TextStyle(
          fontSize: 11.sp,
          color: scheme.onSurface.withValues(alpha: 0.55),
          fontFamily: appFont,
        ),
        headlineSmall: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        headlineMedium: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
      ),
    );
  }

  static ThemeData _buildDarkTheme(Color primaryColor) {
    final scheme = ColorScheme.dark(
      primary: primaryColor,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFF3D2E00),
      onPrimaryContainer: Colors.white,
      secondary: AppColors.secondaryColor,
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFF2A2A4A),
      onSecondaryContainer: const Color(0xFFB8C9FF),
      tertiary: AppColors.star,
      onTertiary: Colors.black,
      surface: AppColors.darkCard,
      onSurface: Colors.white,
      surfaceContainerHighest: Colors.transparent,
      surfaceContainerHigh: const Color(0xFF252525),
      error: AppColors.errorColor,
      onError: Colors.white,
      outline: const Color(0xFF3D3D3D),
      outlineVariant: const Color(0xFF404040),
      shadow: Colors.black,
      inverseSurface: const Color(0xFFE8E8E8),
      onInverseSurface: const Color(0xFF1A1A1A),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: appFont,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: scheme.surface,
      hintColor: Colors.white.withValues(alpha: 0.45),
      dividerColor: scheme.outline,
      extensions: const [ZatheExtras.dark],
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: scheme.onSurface,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontFamily: appFont,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary.withValues(alpha: 0.55)),
        ),
      ),
      iconTheme: IconThemeData(color: scheme.onSurface, size: 22),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return scheme.onPrimary;
          return scheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return scheme.primary.withValues(alpha: 0.45);
          }
          return scheme.surfaceContainerHigh;
        }),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.w800,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        titleMedium: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        titleSmall: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        bodyLarge: TextStyle(
          fontSize: 16.sp,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        bodyMedium: TextStyle(
          fontSize: 14.sp,
          color: scheme.onSurface.withValues(alpha: 0.85),
          fontFamily: appFont,
        ),
        bodySmall: TextStyle(
          fontSize: 12.sp,
          color: scheme.onSurface.withValues(alpha: 0.6),
          fontFamily: appFont,
        ),
        labelLarge: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        labelMedium: TextStyle(
          fontSize: 12.sp,
          color: scheme.onSurface.withValues(alpha: 0.75),
          fontFamily: appFont,
        ),
        labelSmall: TextStyle(
          fontSize: 11.sp,
          color: scheme.onSurface.withValues(alpha: 0.55),
          fontFamily: appFont,
        ),
        headlineSmall: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
        headlineMedium: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: scheme.onSurface,
          fontFamily: appFont,
        ),
      ),
    );
  }
}
