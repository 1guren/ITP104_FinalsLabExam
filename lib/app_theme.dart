import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const double xsmall = 4;
  static const double small = 8;
  static const double medium = 12;
  static const double large = 16;
  static const double xlarge = 24;
  static const double xxlarge = 32;
}

class AppRadius {
  AppRadius._();

  static const double card = 20;
  static const double button = 14;
  static const double dialog = 24;
  static const double input = 14;
  static const double pill = 100;
}

class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF17324D);
  static const Color navyDeep = Color(0xFF10263B);
  static const Color teal = Color(0xFF167D78);
  static const Color tealSoft = Color(0xFFE3F3F1);
  static const Color gold = Color(0xFFC89B50);
  static const Color page = Color(0xFFF4F6F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFFE1E7EF);
  static const Color textPrimary = Color(0xFF1B2B3D);
  static const Color textSecondary = Color(0xFF647386);
  static const Color noteBackground = Color(0xFFFFF7E9);
  static const Color noteBorder = Color(0xFFF1E2C3);
  static const Color success = Color(0xFF18794E);
  static const Color danger = Color(0xFFB42332);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.navy,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFE7EDF5),
      onPrimaryContainer: AppColors.navyDeep,
      secondary: AppColors.teal,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.tealSoft,
      onSecondaryContainer: const Color(0xFF0F514E),
      tertiary: AppColors.gold,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: const Color(0xFFEBF0F5),
      outline: AppColors.outline,
      outlineVariant: const Color(0xFFEDF0F4),
      error: AppColors.danger,
    );
    final TextTheme base = ThemeData.light().textTheme;

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.page,
      visualDensity: VisualDensity.standard,
      textTheme: base.copyWith(
        displaySmall: base.displaySmall?.copyWith(
          fontSize: 32,
          height: 1.12,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.8,
          color: AppColors.textPrimary,
        ),
        headlineSmall: base.headlineSmall?.copyWith(
          fontSize: 27,
          height: 1.2,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.55,
          color: AppColors.textPrimary,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontSize: 20,
          height: 1.25,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
          color: AppColors.textPrimary,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontSize: 16,
          height: 1.35,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        titleSmall: base.titleSmall?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          fontSize: 16,
          height: 1.7,
          color: const Color(0xFF344458),
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
        bodySmall: base.bodySmall?.copyWith(
          fontSize: 12,
          height: 1.4,
          color: AppColors.textSecondary,
        ),
        labelLarge: base.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelMedium: base.labelMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.35,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.page,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 68,
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 21,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.35,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.navy,
          size: 23,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.dialog),
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 21,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.large,
          vertical: AppSpacing.medium,
        ),
        labelStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: const TextStyle(color: Color(0xFF8A96A6)),
        prefixIconColor: AppColors.textSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.teal, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.input),
          borderSide: const BorderSide(color: AppColors.danger, width: 1.6),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFE7EDF5),
          disabledForegroundColor: AppColors.navy,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navy,
          side: const BorderSide(color: AppColors.outline),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.large,
            vertical: AppSpacing.medium,
          ),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.navy,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.medium,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.button),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.navy,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.teal,
        foregroundColor: Colors.white,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.outline,
        thickness: 1,
        space: AppSpacing.xlarge,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.navyDeep,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.teal,
        linearTrackColor: AppColors.tealSoft,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFE7EDF5),
        selectedColor: AppColors.tealSoft,
        labelStyle: const TextStyle(
          color: AppColors.navy,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill),
        ),
      ),
    );
  }
}
