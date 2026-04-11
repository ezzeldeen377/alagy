// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

enum AppSettingsStatus{
  initail,
  success,
  error,
  loading,
  themeChanged,
  localeChanged,

}
extension AppSettingsStateX on AppSettingsState{
  bool get isInitail => status == AppSettingsStatus.initail;
  bool get isLoading => status == AppSettingsStatus.loading;
  bool get isSuccess => status == AppSettingsStatus.success;
  bool get isError => status == AppSettingsStatus.error;
  bool get isThemeChanged => status == AppSettingsStatus.themeChanged;
  bool get isLocaleChanged => status == AppSettingsStatus.localeChanged;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isLightMode => themeMode == ThemeMode.light;
} 
class AppSettingsState {
  final AppSettingsStatus status;
  final ThemeMode themeMode;
  final Locale locale;
  final String? errorMessage;
  AppSettingsState({
    required this.status,
    required this.themeMode,
    required this.locale,
    this.errorMessage,
  }); 

  AppSettingsState copyWith({
    AppSettingsStatus? status,
    ThemeMode? themeMode,
    Locale? locale,
    String? errorMessage,
  }) {
    return AppSettingsState(
      status: status ?? this.status,
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'AppSettingsState(status: $status, themeMode: $themeMode, locale: $locale, errorMessage: $errorMessage)';
  }
}
