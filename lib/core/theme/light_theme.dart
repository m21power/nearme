import 'package:flutter/material.dart';

class AppLightTheme {
  static const Color primary = Color(0xFF2B6CEE);
  static const Color primaryHover = Color(0xFF1A5BBD);
  static const Color primaryLight = Color(0xFFEEF4FE);

  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSubtle = Color(0xFFF8F9FC);

  static const Color textMain = Color(0xFF0D121B);
  static const Color textMuted = Color(0xFF4C669A);

  static const Color borderColor = Color(0xFFE0E6ED);

  static ThemeData theme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: background,
    primaryColor: primary,

    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: primary,
      surface: background,
      onPrimary: Colors.white,
      onSurface: textMain,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      foregroundColor: textMain,
      centerTitle: true,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textMain,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textMain),
      bodyMedium: TextStyle(fontSize: 14, color: textMuted),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: backgroundSubtle,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      hintStyle: const TextStyle(color: textMuted),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: primary.withOpacity(0.4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),

    cardTheme: CardThemeData(
      color: background,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
