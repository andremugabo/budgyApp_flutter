import 'dart:convert';

import 'package:budgy/models/saving.dart';
import 'package:budgy/services/api_service.dart';

class SavingService {
  SavingService(this._api);

  final ApiService _api;

  Future<List<Saving>> getAll() async {
    final res = await _api.get('/api/savings');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Saving.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Saving>> getByUser(String userId) async {
    final res = await _api.get('/api/savings/user/$userId');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Saving.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Saving> create({
    required String userId,
    required String name,
    required double targetAmount,
    required double currentAmount,
    required DateTime targetDate,
    required SavingsPriority priority,
    required String description,
  }) async {
    final res = await _api.post('/api/savings', body: {
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'priority': priority.name,
      'description': description,
      'users': {'id': userId},
    });
    return Saving.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Saving> update({
    required String id,
    required String userId,
    required String name,
    required double targetAmount,
    required double currentAmount,
    required DateTime targetDate,
    required SavingsPriority priority,
    required String description,
  }) async {
    final res = await _api.put('/api/savings/$id', body: {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'currentAmount': currentAmount,
      'targetDate': targetDate.toIso8601String(),
      'priority': priority.name,
      'description': description,
      'users': {'id': userId},
    });
    return Saving.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteById(String id) async {
    await _api.delete('/api/savings/$id');
  }
}


