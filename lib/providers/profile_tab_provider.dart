import 'package:flutter/cupertino.dart';
import 'package:merhaba_app/controllers/auth_controller.dart';

class ProfileTabProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _photoUrl = "";
  String get photoUrl => _photoUrl;

  String _email = "test@gmail.com";
  String get email => _email;

  String _username = "Test User";
  String get username => _username;

  String _phone = "0192398483484";
  String get phone => _phone;

  Future<void> getUserData() async {
    try {
      var res = await AuthController.getCurrentUserData();
      if (res["result"] == true) {
        var userData = res["data"]["user_metadata"];

        _email = userData["email"].toString();
        _username = userData["fullName"].toString();
        _phone = userData["phone"].toString();

        notifyListeners();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> getData() async {
    _isLoading = true;
    notifyListeners();

    try {
      await getUserData();
    } catch (e) {
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}
