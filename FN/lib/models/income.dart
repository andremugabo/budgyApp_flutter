enum IncomeType { SALARY, ALLOWANCE, INVESTMENT, INTEREST, OTHER }

class Income {
  Income({
    required this.id,
    required this.amount,
    required this.source,
    required this.incomeType,
    required this.description,
    required this.userId,
  });

  final String id;
  final double amount;
  final String source;
  final IncomeType incomeType;
  final String description;
  final String userId;

  factory Income.fromJson(Map<String, dynamic> json) {
    String _extractUserId(Map<String, dynamic> json) {
      final usersField = json['users'];
      if (usersField is Map<String, dynamic> && usersField['id'] != null) {
        return usersField['id'] as String;
      }
      final directUserId = json['userId'];
      if (directUserId != null) {
        return directUserId.toString();
      }
      // Backend may omit user reference entirely (e.g. after @JsonIgnore); caller doesn't rely on userId.
      return '';
    }

    return Income(
      id: json['id'] as String,
      amount: (json['amount'] is num) ? (json['amount'] as num).toDouble() : double.parse(json['amount'].toString()),
      source: json['source'] as String,
      incomeType: IncomeType.values.firstWhere((e) => e.name == (json['incomeType'] as String)),
      description: json['description'] as String,
      userId: _extractUserId(json),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'amount': amount,
        'source': source,
        'incomeType': incomeType.name,
        'description': description,
        'userId': userId,
      };
}



