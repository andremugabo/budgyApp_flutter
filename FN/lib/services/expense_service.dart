import 'dart:convert';

import 'package:budgy/models/expense.dart';
import 'package:budgy/services/api_service.dart';

class ExpenseService {
  ExpenseService(this._api);

  final ApiService _api;

  Future<List<Expense>> getAll() async {
    final res = await _api.get('/api/expenses');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Expense>> getByUser(String userId) async {
    final res = await _api.get('/api/expenses/user/$userId');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => Expense.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Expense> create({
    required String userId,
    required double amount,
    required String categoryId,
  }) async {
    final res = await _api.post('/api/expenses', body: {
      'amount': amount,
      'category': {'id': categoryId},
      'user': {'id': userId},
    });
    return Expense.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<Expense?> update({
    required String id,
    required String userId,
    required double amount,
    required String categoryId,
  }) async {
    final res = await _api.put('/api/expenses/$id', body: {
      'amount': amount,
      'category': {'id': categoryId},
      'user': {'id': userId},
    });
    final decoded = jsonDecode(res.body);
    if (decoded is Map<String, dynamic>) {
      return Expense.fromJson(decoded);
    }
    return null;
  }

  Future<void> deleteById(String id) async {
    await _api.delete('/api/expenses/$id');
  }
}


