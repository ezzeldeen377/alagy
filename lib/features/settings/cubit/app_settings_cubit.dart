import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'app_settings_state.dart';
@injectable
class AppSettingsCubit extends Cubit<AppSettingsState> {
  AppSettingsCubit()
      : super( AppSettingsState(
        status: AppSettingsStatus.initail,
          themeMode: ThemeMode.light,
          locale: const Locale('ar'),
        ));

  void toggleTheme() {
    final newThemeMode =
        state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    emit(state.copyWith(
      status: AppSettingsStatus.themeChanged,
      themeMode: newThemeMode,
    ));
  }

  void setTheme(ThemeMode themeMode) {
    emit(state.copyWith(
      status: AppSettingsStatus.themeChanged,
      themeMode: themeMode,
    ));
  }

  void toggleLocale() {
    final newLocale =
        state.locale.languageCode == 'en' ? const Locale('ar') : const Locale('en');
    emit(state.copyWith(
      status: AppSettingsStatus.localeChanged,
      locale: newLocale,
    ));
  }

  void setLocale(Locale locale) {
    emit(state.copyWith(
      status: AppSettingsStatus.localeChanged,
      locale: locale,
    ));
  }
}