import 'package:flutter/cupertino.dart';

class AppSettingsProvider with ChangeNotifier {
  String _currentLanguage = "English";
  String get currentLanguage => _currentLanguage;

  bool _isDark = true;
  bool get isDark => _isDark;

  updateCurrentLanguage(String value) {
    _currentLanguage = value;
    notifyListeners();
  }

  updateDarkMode(bool value) {
    _isDark = value;
    notifyListeners();
  }
}
