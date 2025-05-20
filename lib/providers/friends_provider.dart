import 'package:fluent_ui/fluent_ui.dart';
import 'package:merhaba_app/controllers/friends_controller.dart';

class FriendsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  List<Map<String, dynamic>> _suggestions = [];
  List<Map<String, dynamic>> get suggestions => _suggestions;

  setSuggestions(List<Map<String, dynamic>> value) {
    _suggestions = value;
    notifyListeners();
  }

  addToSuggestions(Map<String, dynamic> value) {
    _suggestions.add(value);
    notifyListeners();
  }

  clearSuggestions() {
    _suggestions.clear();
    notifyListeners();
  }

  setTabIndex(int value) {
    _tabIndex = value;
    if (_tabIndex == 0) {
      // TODO: refresh friends
    } else if (_tabIndex == 1) {
      // TODO: refresh friend requests
    } else if (_tabIndex == 2) {
      // TODO: refresh suggestions
      getSuggestions();
    }
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

  Future<void> getSuggestions() async {
    setIsLoading(true);

    try {
      var res = await FriendsController.getSuggestions();

      setSuggestions(res);
    } catch (e) {
      print(e.toString());
      clearSuggestions();
    }

    setIsLoading(false);
  }

  Future<void> getData() async {
    setIsLoading(true);
    try {
      await getSuggestions();
    } catch (e) {
      print(e);
    }

    setIsLoading(false);
  }
}
