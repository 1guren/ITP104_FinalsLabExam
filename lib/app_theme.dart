import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xsmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xlarge = 24;
}

class AppRadius {
  AppRadius._();

  static const double card = 18;
  static const double button = 13;
  static const double dialog = 22;
  static const double input = 13;
}

class AppTheme {
  AppTheme._();

  static const Color _pageBackground = Color(0xFFF6F7FB);
  static const Color _cardOutline = Color(0xFFE5E8F0);
  static const Color _seedColor = Color(0xFF4355B9);

  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: Brightness.light,
    ).copyWith(
      surface: Colors.white,
      surfaceContainerHighest: const Color(0xFFEEF0FA),
    );
    final TextTheme baseText = ThemeData.light().textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: _pageBackground,
      textTheme: baseText.copyWith(
        displaySmall: baseText.displaySmall?.copyWith(
          fontSize: 32,
          height: 1.15,
          fontWeight: FontWeight.w800,
          color: scheme.onSurface,
        ),
        headlineSmall: baseText.headlineSmall?.copyWith(
          fontSize: 27,
          height: 1.2,
          fontWeight: FontWeight.w800,
          color: scheme.onSurface,
        ),
        titleLarge: baseText.titleLarge?.copyWith(
          fontSize: 20,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontSize: 16,
          height: 1.3,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        ),
        bodyLarge: baseText.bodyLarge?.copyWith(
          fontSize: 16,
          height: 1.65,
          color: const Color(0xFF34394A),
        ),
        bodyMedium: baseText.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.5,
          color: const Color(0xFF62697B),
        ),
        labelLarge: baseText.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _pageBackground,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 21,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: _cardOutline),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
        titleTextStyle: TextStyle(
          color: scheme.onSurface,
          fontSize: 21,
          fontWeight: FontWeight.w800,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFCFCFE),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.medium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: _cardOutline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: _cardOutline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: _cardOutline,
        thickness: 1,
        space: AppSpacing.xlarge,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
    );
  }
}
