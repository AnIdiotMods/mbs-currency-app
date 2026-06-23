import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF121212);
  static const Color surface = Color(0xFF1E1E1E);

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      cardColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: Color(0xFF90CAF9),
        surface: surface,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(),
      ),
      useMaterial3: true,
    );
  }
}
