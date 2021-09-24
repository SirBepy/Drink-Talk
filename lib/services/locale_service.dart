import 'package:drink_n_talk/l10n/l10n.dart';
import 'package:flutter/material.dart';

class LocaleService extends ChangeNotifier {
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en', '');
    notifyListeners();
  }
}
