import 'package:flutter/material.dart';
import 'package:worksmart/service/auth_service.dart';
import 'package:worksmart/data/model/app_user.dart';

class UserProvider extends ChangeNotifier {
  static final _authService = AuthService();

  AppUser? _user;
  AppUser? get user => _user;

  void getCurrentUser() async {
    _user = await _authService.getCurrentUserById();
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
