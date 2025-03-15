import 'package:alagy/core/helpers/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GlobalL10n {
  static late AppLocalizations l10n;
  static void init(BuildContext context) {
    l10n = context.l10n;
  }
  static AppLocalizations get instance => l10n;
   GlobalL10n._();
}
