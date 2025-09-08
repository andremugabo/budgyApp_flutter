import 'dart:convert';

import 'package:budgy/models/expense_category.dart';
import 'package:budgy/services/api_service.dart';

class ExpenseCategoryService {
  ExpenseCategoryService(this._api);

  final ApiService _api;

  Future<List<ExpenseCategoryModel>> getAll() async {
    final res = await _api.get('/api/expense-categories');
    final list = jsonDecode(res.body) as List<dynamic>;
    return list.map((e) => ExpenseCategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}



