import 'package:flutter/material.dart';

class CustomColorScheme {
  static const Color primary = Color(0xFF80F856);
  static const Color onPrimary = Color(0xFF99F978);
  static const Color secondary = Colors.white;
  static const Color onSecondary = Color(0xFFFDDCDC);
  static const Color error = Color(0xFFFF0000);
  static const Color onError = Color(0xFFAC2020);
  static const Color surface = Color(0xFF0D0D0D);
  static const Color onSurface = Color(0xFF6E6E6E);

  static ColorScheme get darkScheme => const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: onError,
        surface: surface,
        onSurface: onSurface,
      );
}
