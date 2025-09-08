import 'dart:convert';

import 'package:budgy/models/user.dart';
import 'package:budgy/services/api_service.dart';

class UserService {
  UserService(this._api);

  final ApiService _api;

  Future<User> updateUser(User user) async {
    final res = await _api.put('/api/users/${user.id}', body: user.toJson());
    return User.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }
}



