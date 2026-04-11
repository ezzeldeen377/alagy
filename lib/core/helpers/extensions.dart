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

  String getAppointmentType(String type) {
    switch (type) {
      case 'consultation':
        return l10n.consultation;
      case 'returning':
        return l10n.returning;
      default:
        return type;
    }
  }
}

extension StringX on String {
  String tr(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case 'consultation':
        return l10n.consultation;
      case 'returning':
        return l10n.returning;
      case 'pending':
        return l10n.pending;
      case 'confirmed':
        return l10n.confirmed;
      case 'cancelled':
        return l10n.cancelled;
      case 'completed':
        return l10n.completed;
      default:
        return this;
    }
  }

  String trDescription(BuildContext context) {
    final l10n = context.l10n;
    if (startsWith('withdrawDescriptionArg:')) {
      final methodKey = split(':')[1];
      String localizedMethod = methodKey;
      switch (methodKey) {
        case 'bankAccount':
          localizedMethod = l10n.bankAccount;
          break;
        case 'instaPay':
          localizedMethod = l10n.instaPay;
          break;
        case 'mobileWallet':
          localizedMethod = l10n.mobileWallet;
          break;
      }
      return l10n.withdrawDescription(localizedMethod);
    }
    if (startsWith('paymentDescriptionArg:')) {
      final id = split(':')[1];
      return l10n.paymentDescription(id);
    }
    if (this == 'refundDescription') {
      return l10n.refundDescription;
    }
    return tr(context);
  }
}
