import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:alagy/core/helpers/secure_storage_helper.dart';
import 'app_settings_state.dart';

@injectable
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit()
      : super(AppSettingsState(
          status: AppSettingsStatus.initail,
          themeMode: ThemeMode.light,
          locale: const Locale('ar'),
        )) {
    _loadPreferences();
  }

  // Load both theme and language preferences from storage
  Future<void> _loadPreferences() async {
    await Future.wait([
      _loadThemePreference(),
      _loadLocalePreference(),
    ]);
  }

  // Load theme preference from storage
  Future<void> _loadThemePreference() async {
    final result = await SecureStorageHelper.getThemeMode();
    result.fold(
      (error) {
        // If error loading, keep default theme
      },
      (themeString) {
        if (themeString != null) {
          final themeMode = _stringToThemeMode(themeString);
          emit(state.copyWith(
            status: AppSettingsStatus.themeChanged,
            themeMode: themeMode,
          ));
        }
      },
    );
  }

  // Load language preference from storage
  Future<void> _loadLocalePreference() async {
    final result = await SecureStorageHelper.getLocale();
    result.fold(
      (error) {
        // If error loading, keep default locale
      },
      (languageCode) {
        if (languageCode != null) {
          final locale = Locale(languageCode);
          emit(state.copyWith(
            status: AppSettingsStatus.localeChanged,
            locale: locale,
          ));
        }
      },
    );
  }

  // Convert string to ThemeMode
  ThemeMode _stringToThemeMode(String themeString) {
    switch (themeString) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  // Convert ThemeMode to string
  String _themeModeToString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.system:
        return 'system';
    }
  }

  void toggleTheme() {
    final newThemeMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveAndEmitTheme(newThemeMode);
  }

  void setTheme(ThemeMode themeMode) {
    _saveAndEmitTheme(themeMode);
  }

  // Save theme preference and emit new state
  Future<void> _saveAndEmitTheme(ThemeMode themeMode) async {
    // Save to storage
    await SecureStorageHelper.saveThemeMode(_themeModeToString(themeMode));
    
    // Emit new state
    emit(state.copyWith(
      status: AppSettingsStatus.themeChanged,
      themeMode: themeMode,
    ));
  }

  void toggleLocale() {
    final newLocale =
        state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    _saveAndEmitLocale(newLocale);
  }

  void setLocale(Locale locale) {
    _saveAndEmitLocale(locale);
  }

  // Save language preference and emit new state
  Future<void> _saveAndEmitLocale(Locale locale) async {
    // Save to storage
    await SecureStorageHelper.saveLocale(locale.languageCode);
    
    // Emit new state
    emit(state.copyWith(
      status: AppSettingsStatus.localeChanged,
      locale: locale,
    ));
  }
}