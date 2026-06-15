import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData from(AppColors colors) {
    final isDark = colors.isDark;
    final surface = colors.surface;
    final text = colors.text;
    final primary = colors.primary;
    final secondary = colors.secondary;
    final error = colors.error;
    final tertiary = Color.lerp(primary, secondary, 0.5)!;

    Color shift(Color c, [double amount = 0.85]) =>
      Color.lerp(c, surface, amount)!;

    final scheme = (isDark ? ColorScheme.dark : ColorScheme.light)(
      primary: primary,
      onPrimary: surface,
      primaryContainer: shift(primary),
      onPrimaryContainer: primary,
      secondary: secondary,
      onSecondary: surface,
      secondaryContainer: shift(secondary),
      onSecondaryContainer: secondary,
      tertiary: tertiary,
      onTertiary: surface,
      tertiaryContainer: shift(tertiary),
      onTertiaryContainer: tertiary,
      error: error,
      onError: surface,
      errorContainer: shift(error),
      onErrorContainer: error,
      surface: surface,
      onSurface: text,
      surfaceVariant: shift(text, isDark ? 0.12 : 0.06),
      onSurfaceVariant: text.withValues(alpha: 0.7),
      outline: text.withValues(alpha: 0.30),
      outlineVariant: text.withValues(alpha: 0.12),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: isDark ? Colors.white : const Color(0xFF1e1e2e),
      onInverseSurface: isDark ? const Color(0xFF1e1e2e) : Colors.white,
      inversePrimary: primary,
      surfaceTint: Colors.transparent,
    );

    final barColor = isDark ? const Color(0xFF1e1e2e) : const Color(0xFFeff1f5);

    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter',
      colorScheme: scheme,
      scaffoldBackgroundColor: colors.background,
      applyElevationOverlayColor: false,
      appBarTheme: AppBarTheme(
        backgroundColor: barColor,
        foregroundColor: text,
        surfaceTintColor: Colors.transparent,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: barColor,
        indicatorColor: shift(primary),
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
