import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:merhaba_app/controllers/friends_controller.dart';
import 'package:merhaba_app/locale/app_locale.dart';
import 'package:merhaba_app/main.dart';
import 'package:merhaba_app/providers/post_provider.dart';

class FriendsProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  List<Map<String, dynamic>> _suggestions = [];
  List<Map<String, dynamic>> get suggestions => _suggestions;

  List<Map<String, dynamic>> _friendRequests = [];
  List<Map<String, dynamic>> get friendRequests => _friendRequests;

  setFriendRequests(List<Map<String, dynamic>> value) {
    _friendRequests = value;
    notifyListeners();
  }

  clearFriendRequests() {
    _friendRequests.clear();
    notifyListeners();
  }

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
      getFriendRequests();
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

  Future<void> addFriend(String otherUserId) async {
    setIsLoading(true);

    try {
      var res = await FriendsController.addFriend(otherUserId);

      if (res["result"] == true) {
        Fluttertoast.showToast(
          msg: AppLocale.friend_request_sent_label.getString(
            navigatorKey.currentContext!,
          ),
        );

        await getSuggestions();
      } else {
        Fluttertoast.showToast(msg: res["message"]);
      }
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }

    setIsLoading(false);
  }

  Future<void> getFriendRequests() async {
    setIsLoading(true);

    try {
      var res = await FriendsController.getFriendRequests();

      setFriendRequests(res);
    } catch (e) {
      print(e.toString());
      clearFriendRequests();
    }

    setIsLoading(false);
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
      await getFriendRequests();
    } catch (e) {
      print(e);
    }

    setIsLoading(false);
  }
}
