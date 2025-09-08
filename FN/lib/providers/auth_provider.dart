import 'dart:convert';

import 'package:budgy/models/user.dart';
import 'package:budgy/services/api_service.dart';
import 'package:budgy/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({ApiService? api}) : _auth = AuthService(api ?? ApiService()) {
    initialize(); // Auto-load session on creation
  }

  final AuthService _auth;
  User? _currentUser;
  bool _isLoading = true; // Track initialization state

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading; // Non-nullable bool

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners(); // Notify for loading UI

    try {
      await _loadSession();
      // Optional: Verify session with backend (add to AuthService if needed)
      // if (_currentUser != null) await _auth.verifySession(_currentUser!);
    } catch (e) {
      if (kDebugMode) print('Auth init error: $e');
      await logout(); // Clear invalid session
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI to proceed
    }
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('session_user');
    if (raw != null) {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _currentUser = User.fromJson(map);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final user = await _auth.login(email: email, password: password);
      await _saveSession(user);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Login error: $e');
      rethrow; // Let UI (e.g., LoginScreen) handle errors
    }
  }

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required Gender gender,
  }) async {
    try {
      final user = await _auth.signup(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        gender: gender,
      );
      await _saveSession(user);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Signup error: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('session_user');
    notifyListeners();
  }

  Future<void> setCurrentUser(User user) async {
    try {
      await _saveSession(user);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) print('Set user error: $e');
      rethrow;
    }
  }

  Future<void> _saveSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_user', jsonEncode(user.toJson()));
    _currentUser = user;
  }
}
