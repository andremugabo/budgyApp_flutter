class ExpenseCategoryRef {
  ExpenseCategoryRef({required this.id, required this.name, required this.icon});
  final String id;
  final String name;
  final String icon;

  factory ExpenseCategoryRef.fromJson(Map<String, dynamic> json) => ExpenseCategoryRef(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
      );
}

class Expense {
  Expense({
    required this.id,
    required this.amount,
    required this.userId,
    this.category,
  });

  final String id;
  final double amount;
  final String userId;
  final ExpenseCategoryRef? category;

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : double.parse(json['amount'].toString()),
      userId: (json['user'] is Map<String, dynamic>) ? (json['user']['id'] as String) : json['userId'] as String,
      category: json['category'] != null ? ExpenseCategoryRef.fromJson(json['category'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'amount': amount,
      'userId': userId,
      'categoryId': category?.id,
    };
  }
}



