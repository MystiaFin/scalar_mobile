import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData from(AppColors colors) => ThemeData(
    useMaterial3: true,
    colorScheme: colors.isDark
      ? ColorScheme.dark(
          primary:     colors.primary,
          secondary:   colors.secondary,
          surface:     colors.surface,
          error:       colors.error,
          onPrimary:   colors.background,
          onSecondary: colors.background,
          onSurface:   colors.text,
          onError:     colors.background,
        )
      : ColorScheme.light(
          primary:     colors.primary,
          secondary:   colors.secondary,
          surface:     colors.surface,
          error:       colors.error,
          onPrimary:   colors.background,
          onSecondary: colors.background,
          onSurface:   colors.text,
          onError:     colors.background,
        ),
    scaffoldBackgroundColor: colors.background,
  );
}
