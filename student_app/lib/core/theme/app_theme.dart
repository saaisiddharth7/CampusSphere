import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Dynamic theming based on tenant configuration.
/// Colors, fonts, and branding are loaded from the real tenant record in Supabase.

class TenantThemeConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String fontFamily;
  final String? logoUrl;
  final String? faviconUrl;
  final String? appName;
  final double attendanceMinimum;

  TenantThemeConfig({
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.fontFamily = 'Inter',
    this.logoUrl,
    this.faviconUrl,
    this.appName,
    this.attendanceMinimum = 75.0,
  });

  factory TenantThemeConfig.fromJson(Map<String, dynamic> json) {
    return TenantThemeConfig(
      primaryColor: _parseColor(json['primary_color'] ?? '#1E40AF'),
      secondaryColor: _parseColor(json['secondary_color'] ?? '#3B82F6'),
      accentColor: _parseColor(json['accent_color'] ?? '#F59E0B'),
      fontFamily: json['font_family'] ?? 'Inter',
      logoUrl: json['logo_url'],
      faviconUrl: json['favicon_url'],
      appName: json['app_name'],
      attendanceMinimum:
          (json['attendance_minimum'] ?? 75.0).toDouble(),
    );
  }

  factory TenantThemeConfig.defaultTheme() {
    return TenantThemeConfig(
      primaryColor: const Color(0xFF1E40AF),
      secondaryColor: const Color(0xFF3B82F6),
      accentColor: const Color(0xFFF59E0B),
    );
  }

  static Color _parseColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}

/// Generates Material 3 ThemeData from tenant config.
ThemeData buildLightTheme(TenantThemeConfig config) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: config.primaryColor,
    brightness: Brightness.light,
    primary: config.primaryColor,
    secondary: config.secondaryColor,
    tertiary: config.accentColor,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.getTextTheme(config.fontFamily),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        textStyle: GoogleFonts.getFont(
          config.fontFamily,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        side: BorderSide(color: config.primaryColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: config.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: config.primaryColor,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      showUnselectedLabels: true,
      elevation: 8,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: config.primaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: colorScheme.outlineVariant.withOpacity(0.5),
      thickness: 1,
    ),
  );
}

ThemeData buildDarkTheme(TenantThemeConfig config) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: config.primaryColor,
    brightness: Brightness.dark,
    primary: config.primaryColor,
    secondary: config.secondaryColor,
    tertiary: config.accentColor,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: GoogleFonts.getTextTheme(config.fontFamily, ThemeData.dark().textTheme),
    scaffoldBackgroundColor: const Color(0xFF0F1117),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: const Color(0xFF0F1117),
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF1A1D27),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.2)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: config.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1D27),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: config.primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: config.primaryColor,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      showUnselectedLabels: true,
      backgroundColor: const Color(0xFF0F1117),
    ),
  );
}

/// Provider for tenant theme configuration.
final tenantThemeProvider = StateProvider<TenantThemeConfig>((ref) {
  return TenantThemeConfig.defaultTheme();
});

/// Provider for current theme mode.
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});
