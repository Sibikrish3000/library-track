import 'package:flutter/material.dart';
import 'package:libarary_gen/services/settings_service.dart';

class SettingsRepository {
  SettingsRepository(this.service);

  final SettingsService service;

  Future<ThemeMode> getThemeMode() async {
    return service.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await service.setThemeMode(mode);
  }
}
