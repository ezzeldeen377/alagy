import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  ThemeData get theme => Theme.of(this);
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;
  bool get isDark => theme.brightness == Brightness.dark;
  bool get isLight => theme.brightness == Brightness.light;
}

extension StringX on String {
  String tr(BuildContext context) => context.l10n.toString();
  
  String plural(BuildContext context, int count) {
    // You can implement plural logic here based on your ARB file structure
    return this;
  }
  
  String args(List<String> arguments) {
    String result = this;
    for (var i = 0; i < arguments.length; i++) {
      result = result.replaceAll('{$i}', arguments[i]);
    }
    return result;
  }
}