import 'dart:convert';

import 'package:budgy/models/user.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({ApiService? api}) : _auth = AuthService(api ?? ApiService());

  final AuthService _auth;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('session_user');
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _currentUser = User.fromJson(map);
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final user = await _auth.login(email: email, password: password);
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_user', jsonEncode(user.toJson()));
    notifyListeners();
  }

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required Gender gender,
  }) async {
    final user = await _auth.signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      gender: gender,
    );
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_user', jsonEncode(user.toJson()));
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_user');
    notifyListeners();
  }

  Future<void> setCurrentUser(User user) async {
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_user', jsonEncode(user.toJson()));
    notifyListeners();
  }
}



