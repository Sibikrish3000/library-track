import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libarary_gen/providers/providers.dart';
import 'package:libarary_gen/repositories/settings_repository.dart';

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._settingsRepository) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final SettingsRepository _settingsRepository;

  Future<void> _loadThemeMode() async {
    state = await _settingsRepository.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _settingsRepository.setThemeMode(mode);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(settingsRepositoryProvider));
});
