import 'package:flutter/material.dart';

/// App theme — Material 3 with CampusSphere HOD branding.
class AppTheme {
  static ThemeData lightTheme({Color? seedColor}) {
    final seed = seedColor ?? const Color(0xFF6d28d9); // Purple for HOD
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seed,
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 12),
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  static ThemeData darkTheme({Color? seedColor}) {
    final seed = seedColor ?? const Color(0xFF6d28d9);
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seed,
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        margin: const EdgeInsets.only(bottom: 12),
      ),
    );
  }
}
