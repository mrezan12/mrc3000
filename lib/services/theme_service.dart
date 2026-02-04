import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// MR3000 tema yönetimi servisi.
/// Tema tercihini kalıcı olarak saklar ve reaktif güncellemeler sağlar.
class ThemeService {
  static const _key = 'theme_mode';
  static final ThemeService _instance = ThemeService._internal();

  factory ThemeService() => _instance;
  ThemeService._internal();

  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier(ThemeMode.system);

  /// Kaydedilmiş tema tercihini yükler.
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    themeModeNotifier.value = _parseThemeMode(value);
  }

  /// Tema modunu değiştirir ve kalıcı olarak kaydeder.
  Future<void> setThemeMode(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  /// Light ve dark tema arasında geçiş yapar.
  Future<void> toggleTheme() async {
    final current = themeModeNotifier.value;
    final next = current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(next);
  }

  ThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
