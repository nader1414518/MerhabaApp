import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:merhaba_app/utils/globals.dart';

class AppSettingsProvider with ChangeNotifier {
  String _currentLanguage = "English";
  String get currentLanguage => _currentLanguage;

  bool _isDark = false;
  bool get isDark => _isDark;

  setIsDark(bool value) {
    _isDark = value;
    notifyListeners();
  }

  updateCurrentLanguage(String value) {
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
