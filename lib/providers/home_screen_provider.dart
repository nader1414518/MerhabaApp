import 'package:flutter/cupertino.dart';

class HomeScreenProvider with ChangeNotifier {
  bool _isVisible = true;
  bool get isVisible => _isVisible;

  setVisible(bool value) {
    _isVisible = value;
    notifyListeners();
  }
}
