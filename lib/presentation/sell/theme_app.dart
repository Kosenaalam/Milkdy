import 'package:flutter/material.dart';

class AppTheme {

  ///  LIGHT COLORS 
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 243, 176, 219),
  );

  /// 🌙 DARK COLORS (same as your example)
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(155, 5, 99, 125),
  );

  // ================= LIGHT THEME =================
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,

      appBarTheme: AppBarTheme(
        backgroundColor: lightColorScheme.onPrimaryContainer,
        foregroundColor: lightColorScheme.primaryContainer,
      ),

      cardTheme: CardThemeData(
        color: lightColorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
  filled: true,
  fillColor: lightColorScheme.surface, // soft background

  labelStyle: TextStyle(
    color: lightColorScheme.onSurfaceVariant,
  ),

  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: lightColorScheme.outline,
    ),
  ),

  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: lightColorScheme.outline,
    ),
  ),

  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      color: lightColorScheme.primary, // highlight when focused
      width: 2,
    ),
  ),
),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightColorScheme.primaryContainer,
          foregroundColor: lightColorScheme.onPrimaryContainer,
        ),
      ),

      textTheme: ThemeData().textTheme.copyWith(
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          color: lightColorScheme.onSecondaryContainer,
          fontSize: 16,
        ),
      ),
    );
  }

  // ================= DARK THEME =================
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,

      cardTheme: CardThemeData(
        color: darkColorScheme.secondaryContainer,
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkColorScheme.primaryContainer,
          foregroundColor: darkColorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}