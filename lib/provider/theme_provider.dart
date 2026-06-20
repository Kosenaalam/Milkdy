import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark) {
    _loadTheme();
  }

  static const _themeKey = "theme_mode_key";

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isLight = prefs.getBool(_themeKey) ?? false;
    state = isLight ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> toggleTheme() async {
    final isCurrentlyDark = state == ThemeMode.dark;
    state = isCurrentlyDark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, state == ThemeMode.light);
  }
}
