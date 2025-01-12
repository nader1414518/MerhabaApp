import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/utils/globals.dart';
import 'package:flutter_localization/flutter_localization.dart';

class AppSettingsProvider with ChangeNotifier {
  String _currentLanguage = "English";
  String get currentLanguage => _currentLanguage;

  bool _isDark = false;
  bool get isDark => _isDark;

  setIsDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  getCurrentLanguage() {
    if (localization.currentLocale!.localeIdentifier == "en") {
      _currentLanguage = "English";
    } else if (localization.currentLocale!.localeIdentifier == "ar") {
      _currentLanguage = "العربية";
    }

    notifyListeners();
  }

  updateCurrentLanguage(String value) {
    if (value == "English") {
      localization.translate("en");
    } else if (value == "العربية") {
      localization.translate("ar");
    }

    _currentLanguage = value;
    notifyListeners();
  }

  updateDarkMode(bool value, BuildContext context) {
    _isDark = value;
    if (_isDark) {
      AdaptiveTheme.of(context).setDark();
      Globals.theme = "Dark";
    } else {
      AdaptiveTheme.of(context).setLight();
      Globals.theme = "Light";
    }
    notifyListeners();
  }
}
