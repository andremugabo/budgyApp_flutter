import 'dart:convert';

import 'package:budgy/models/income.dart';
import 'package:budgy/services/api_service.dart';

class IncomeService {
  IncomeService(this._api);

  final ApiService _api;

  Future<List<Income>> getAll() async {
    final res = await _api.get('/api/incomes');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Income.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Income>> getByUser(String userId) async {
    final res = await _api.get('/api/incomes/user/$userId');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Income.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Income> create({
    required String userId,
    required double amount,
    required String source,
    required IncomeType incomeType,
    required String description,
  }) async {
    final res = await _api.post('/api/incomes', body: {
      'amount': amount,
      'source': source,
      'incomeType': incomeType.name,
      'description': description,
      'users': {'id': userId},
    });
    return Income.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Income> update({
    required String id,
    required String userId,
    required double amount,
    required String source,
    required IncomeType incomeType,
    required String description,
  }) async {
    final res = await _api.put('/api/incomes/$id', body: {
      'amount': amount,
      'source': source,
      'incomeType': incomeType.name,
      'description': description,
      'users': {'id': userId},
    });
    return Income.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteById(String id) async {
    await _api.delete('/api/incomes/$id');
  }
}


