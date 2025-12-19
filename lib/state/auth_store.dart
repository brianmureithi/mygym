import 'package:flutter/material.dart';

class AuthStore extends ChangeNotifier {
  String? token;
  Map<String, dynamic>? user;

  bool get isLoggedIn => token != null && user != null;

  void setAuth({
    required String token,
    required Map<String, dynamic> user,
  }) {
    this.token = token;
    this.user = user;
    notifyListeners();
  }

  void logout() {
    token = null;
    user = null;
    notifyListeners();
  }
}
