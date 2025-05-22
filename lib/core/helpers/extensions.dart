import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  case 'specialty_internal_medicine':
    return l10n.specialty_internal_medicine;
  case 'specialty_general_surgery':
    return l10n.specialty_general_surgery;
  case 'specialty_pediatrics':
    return l10n.specialty_pediatrics;
  case 'specialty_gynecology':
    return l10n.specialty_gynecology;
  case 'specialty_orthopedics':
    return l10n.specialty_orthopedics;
  case 'specialty_urology':
    return l10n.specialty_urology;
  case 'specialty_ent':
    return l10n.specialty_ent;
  case 'specialty_dermatology':
    return l10n.specialty_dermatology;
  case 'specialty_ophthalmology':
    return l10n.specialty_ophthalmology;
  case 'specialty_dentistry':
    return l10n.specialty_dentistry;
  case 'specialty_emergency':
    return l10n.specialty_emergency;
  case 'specialty_laboratory':
    return l10n.specialty_laboratory;
  case 'specialty_radiology':
    return l10n.specialty_radiology;
  case 'specialty_cardiology':
    return l10n.specialty_cardiology;
  case 'specialty_cardiothoracic_surgery':
    return l10n.specialty_cardiothoracic_surgery;
  case 'specialty_neurosurgery':
    return l10n.specialty_neurosurgery;
  case 'specialty_oncology':
    return l10n.specialty_oncology;
  case 'specialty_nephrology':
    return l10n.specialty_nephrology;
  case 'specialty_pulmonology':
    return l10n.specialty_pulmonology;
  case 'specialty_rheumatology':
    return l10n.specialty_rheumatology;
  case 'specialty_rehabilitation':
    return l10n.specialty_rehabilitation;
  case 'specialty_psychiatry':
    return l10n.specialty_psychiatry;
  case 'specialty_hematology':
    return l10n.specialty_hematology;
  case 'specialty_infectious_diseases':
    return l10n.specialty_infectious_diseases;
  case 'specialty_endocrinology':
    return l10n.specialty_endocrinology;
  case 'specialty_icu':
    return l10n.specialty_icu;
  case 'specialty_burns_plastic':
    return l10n.specialty_burns_plastic;
  case 'specialty_laparoscopy':
    return l10n.specialty_laparoscopy;
  case 'specialty_vascular_surgery':
    return l10n.specialty_vascular_surgery;
  case 'specialty_geriatrics':
    return l10n.specialty_geriatrics;
  case 'specialty_audiology':
    return l10n.specialty_audiology;
  case 'specialty_neonatology':
    return l10n.specialty_neonatology;
  default:
    return specialtyKey; // fallback
}
 // fallback to the key if not found
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