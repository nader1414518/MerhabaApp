import 'package:flutter/material.dart';
import 'package:merhaba_app/controllers/friends_controller.dart';
import 'package:merhaba_app/controllers/public_profile_controller.dart';
import 'package:merhaba_app/main.dart';

class PublicProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isFriend = false;
  bool get isFriend => _isFriend;

  String _uid = "";
  String get uid => _uid;

  Map<String, dynamic> _currentProfile = {};
  Map<String, dynamic> get currentProfile => _currentProfile;

  setIsFriend(bool value) {
    _isFriend = value;
    notifyListeners();
  }

  setCurrentProfile(Map<String, dynamic> value) {
    _currentProfile = value;
    notifyListeners();
  }

  setUID(String value) {
    _currentProfile = {};
    _uid = value;
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

  Future<void> checkIsFriend() async {
    try {
      var res = await FriendsController.isInFriend(uid);

      setIsFriend(res);
    } catch (e) {
      print(e.toString());
      setIsFriend(false);
    }
  }

  Future<void> getUserProfile() async {
    try {
      var res = await PublicProfileController.getPublicProfile(uid);

      if (res["result"] == true) {
        setCurrentProfile(
          Map<String, dynamic>.from(
            res["data"] as Map,
          ),
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getData() async {
    setIsLoading(true);

    try {
      if (!(await FriendsController.isBlocked(uid))) {
        await getUserProfile();
        await checkIsFriend();
      } else {
        setCurrentProfile({});
      }
    } catch (e) {
      print(e.toString());
    }

    setIsLoading(false);
  }
}
