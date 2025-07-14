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

  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> get friends => _friends;

  setFriends(List<Map<String, dynamic>> value) {
    _friends = value;
    notifyListeners();
  }

  clearFriends() {
    _friends.clear();
    notifyListeners();
  }

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
      getFriends();
    } else if (_tabIndex == 1) {
      getFriendRequests();
    } else if (_tabIndex == 2) {
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

  Future<void> unFriend(String otherUserId) async {
    setIsLoading(true);

    try {
      var res = await FriendsController.unFriend(otherUserId);

      if (res["result"] == true) {
        Fluttertoast.showToast(
          msg: AppLocale.unfriend_successfully_label.getString(
            navigatorKey.currentContext!,
          ),
        );

        await getFriends();
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

  Future<void> blockUser(String otherUserId) async {
    setIsLoading(true);

    try {
      var res = await FriendsController.blockUser(otherUserId);

      if (res["result"] == true) {
        Fluttertoast.showToast(msg: res["message"]);

        await getFriends();
        await getSuggestions();
        await getFriendRequests();
      } else {
        Fluttertoast.showToast(msg: res["message"]);
      }
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }

  Future<void> unblockUser(String otherUserId) async {
    setIsLoading(true);

    try {
      var res = await FriendsController.unblockUser(otherUserId);

      if (res["result"] == true) {
        Fluttertoast.showToast(msg: res["message"]);

        await getFriends();
        await getSuggestions();
        await getFriendRequests();
      } else {
        Fluttertoast.showToast(msg: res["message"]);
      }
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }

  Future<void> deleteFriendRequest(int requestId) async {
    setIsLoading(true);

    try {
      var res = await FriendsController.deleteFriendRequest(requestId);

      if (res["result"] == true) {
        await getFriendRequests();
      }
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }

  Future<void> acceptFriendRequest(int requestId) async {
    setIsLoading(true);

    try {
      var res = await FriendsController.acceptFriendRequest(requestId);

      if (res["result"] == true) {
        await getFriendRequests();
      }
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }

  Future<void> getFriends() async {
    setIsLoading(true);

    try {
      var res = await FriendsController.getFriends();

      setFriends(res);
    } catch (e) {
      print(e.toString());
      clearFriends();
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
      await getFriends();
      await getFriendRequests();
      await getSuggestions();
    } catch (e) {
      print(e);
    }

    setIsLoading(false);
  }
}
