import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  late final SharedPreferences _prefs;

  AuthProvider(SharedPreferences prefs) : _prefs = prefs;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isSeller => _user?.userType == 'seller';
  bool get isCustomer => !isSeller; 

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final email = _prefs.getString('user_email');
      final name = _prefs.getString('user_name');
      final userType = _prefs.getString('user_type');
      final password = _prefs.getString('user_password');

      if (email != null && name != null && userType != null && password != null) {
        _user = User(
          email: email,
          password: password,
          name: name,
          userType: userType,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password, String name, String userType) async {
  _isLoading = true;
  notifyListeners();

  try {
    await _prefs.setString('user_email', email);
    await _prefs.setString('user_password', password);
    await _prefs.setString('user_name', name);
    await _prefs.setString('user_type', userType);

    _user = User(
      email: email,
      password: password,
      name: name,
      userType: userType,
    );

    notifyListeners();
    return true;
  } catch (e) {
    _isLoading = false;
    notifyListeners();
    return false;
  }
}

  Future<void> logout() async {
    await _prefs.remove('user_email');
    await _prefs.remove('user_password');
    await _prefs.remove('user_name');
    await _prefs.remove('user_type');

    _user = null;
    notifyListeners();
  }
}

class User {
  final String email;
  final String password;
  final String name;
  final String userType;

  User({
    required this.email,
    required this.password,
    required this.name,
    required this.userType,
  });
}