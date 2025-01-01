import 'package:flutter/cupertino.dart';

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
}
