import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:libarary_gen/utils/app_constants.dart';

abstract class SettingsService {
  Future<ThemeMode> getThemeMode();
  Future<void> setThemeMode(ThemeMode mode);
}

class SettingsServiceImpl implements SettingsService {
  SettingsServiceImpl(this._box);

  final Box<dynamic> _box;

  @override
  Future<ThemeMode> getThemeMode() async {
    final themeModeIndex = _box.get(
      AppConstants.themeModeKey,
      defaultValue: ThemeMode.system.index,
    ) as int;
    return ThemeMode.values[themeModeIndex];
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    await _box.put(AppConstants.themeModeKey, mode.index);
  }
}
