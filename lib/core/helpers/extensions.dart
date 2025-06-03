import 'package:alagy/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension BuildContextX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  ThemeData get theme => Theme.of(this);
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;
  bool get isDark => theme.brightness == Brightness.dark;
  bool get isLight => theme.brightness == Brightness.light;

  /// Returns the localized specialty name for a given specialty key.
  String getSpecialty(String specialtyKey) {
    final l10n = AppLocalizations.of(this)!;

switch (specialtyKey) {
  case "":
    return l10n.specialtyEmpty;

  case 'internalMedicine':
    return l10n.internalMedicine;
  case 'vascularSurgery':
    return l10n.vascularSurgery;
  case 'orthopedics':
    return l10n.orthopedics;
  case 'gynecologyAndObstetrics':
    return l10n.gynecologyAndObstetrics;
  case 'pediatricsAndNeonatology':
    return l10n.pediatricsAndNeonatology;
  case 'urology':
    return l10n.urology;
  case 'dentistry':
    return l10n.dentistry;
  case 'neurology':
    return l10n.neurology;
  case 'cosmeticSurgery':
    return l10n.cosmeticSurgery;
  case 'ophthalmology':
    return l10n.ophthalmology;
  case 'ent':
    return l10n.ent;
  case 'chestDiseases':
    return l10n.chestDiseases;
  case 'dermatology':
    return l10n.dermatology;
  case 'physiotherapy':
    return l10n.physiotherapy;
  case 'ivf':
    return l10n.ivf;
  case 'speechAndLanguageTherapy':
    return l10n.speechAndLanguageTherapy;

  default:
    return specialtyKey; // fallback
}

    // fallback to the key if not found
  }
  String getDayOfWeek(String day) {
    switch (day) {
      case 'Sunday':
        return l10n.sunday;
      case 'Monday':
        return l10n.monday;
      case 'Tuesday':
        return l10n.tuesday;
      case 'Wednesday':
        return l10n.wednesday;
      case 'Thursday':
        return l10n.thursday;
      case 'Friday':
        return l10n.friday;
      case 'Saturday':
        return l10n.saturday;
      default:
        return day; // fallback
    }
  }
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
