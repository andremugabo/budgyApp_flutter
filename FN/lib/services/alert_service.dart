import 'dart:convert';

import 'package:budgy/models/alert.dart';
import 'package:budgy/services/api_service.dart';

class AlertService {
  AlertService(this._api);

  final ApiService _api;

  Future<List<AlertModel>> getByUser(String userId) async {
    final res = await _api.get('/api/alerts/user/$userId');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => AlertModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AlertModel?> markRead(AlertModel alert) async {
    final res = await _api.put('/api/alerts/${alert.id}', body: {
      'id': alert.id,
      'userId': alert.userId,
      'title': alert.title,
      'message': alert.message,
      'alert': alert.alert.name,
      'isRead': true,
    });
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) {
      return AlertModel.fromJson(decoded);
    }
    return null;
  }
}



