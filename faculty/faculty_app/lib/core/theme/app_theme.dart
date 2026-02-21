import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tenant branding config loaded from API or defaults.
class TenantThemeConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final String fontFamily;
  final String? appName;
  final String? logoUrl;

  const TenantThemeConfig({
    this.primaryColor = const Color(0xFF1E40AF),
    this.secondaryColor = const Color(0xFF3B82F6),
    this.accentColor = const Color(0xFFF59E0B),
    this.fontFamily = 'Inter',
    this.appName,
    this.logoUrl,
  });
}

/// Provider for tenant theme configuration.
final tenantThemeProvider = StateProvider<TenantThemeConfig>((ref) {
  return const TenantThemeConfig();
});

/// Provider for theme mode (light/dark).
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);

/// Build light theme from tenant config.
ThemeData buildLightTheme(TenantThemeConfig config) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: config.primaryColor,
    brightness: Brightness.light,
    secondary: config.secondaryColor,
    tertiary: config.accentColor,
  );

  final textTheme = GoogleFonts.getTextTheme(config.fontFamily);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      titleTextStyle: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurface,
      ),
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
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: colorScheme.outline),
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
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: colorScheme.primaryContainer,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      showDragHandle: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
  );
}

/// Build dark theme from tenant config.
ThemeData buildDarkTheme(TenantThemeConfig config) {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: config.primaryColor,
    brightness: Brightness.dark,
    secondary: config.secondaryColor,
    tertiary: config.accentColor,
  );

  final textTheme = GoogleFonts.getTextTheme(config.fontFamily, ThemeData.dark().textTheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorScheme.surfaceContainerLow,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
