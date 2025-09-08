import 'dart:convert';

import 'package:budgy/models/user.dart';
import 'package:budgy/services/api_service.dart';

class AuthService {
  AuthService(this._api);

  final ApiService _api;

  Future<User> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required Gender gender,
  }) async {
    final res = await _api.post('/api/users', body: {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'gender': gender.name,
      'role': UserRole.USER.name,
    });
    final map = jsonDecode(res.body) as Map<String, dynamic>;
    return User.fromJson(map);
  }

  Future<User> login({required String email, required String password}) async {
    final res = await _api.post('/api/users/login', body: {
      'email': email,
      'password': password,
    });
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) {
      return User.fromJson(decoded);
    }
    if (decoded is List && decoded.isNotEmpty) {
      return User.fromJson(decoded.first as Map<String, dynamic>);
    }
    throw Exception('Invalid login response');
  }
}



