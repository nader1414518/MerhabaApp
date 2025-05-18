import 'package:fluent_ui/fluent_ui.dart';

class FriendsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  setTabIndex(int value) {
    _tabIndex = value;
    notifyListeners();
  }

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  toggleLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  Future<void> getData() async {
    setIsLoading(true);
    try {} catch (e) {
      print(e);
    }

    setIsLoading(false);
  }
}
