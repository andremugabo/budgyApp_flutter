enum SavingsPriority { LOW, MEDIUM, HIGH }

class Saving {
  Saving({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.priority,
    required this.description,
    required this.userId,
  });

  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final SavingsPriority priority;
  final String description;
  final String userId;

  factory Saving.fromJson(Map<String, dynamic> json) {
    String _extractUserId(Map<String, dynamic> json) {
      final usersField = json['users'];
      if (usersField is Map<String, dynamic> && usersField['id'] != null) {
        return usersField['id'] as String;
      }
      final directUserId = json['userId'];
      if (directUserId != null) {
        return directUserId.toString();
      }
      // Backend may omit user reference entirely (e.g. after @JsonIgnore); callers don't rely on userId for UI.
      return '';
    }

    return Saving(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentAmount: (json['currentAmount'] as num).toDouble(),
      targetDate: DateTime.parse(json['targetDate'] as String),
      priority: SavingsPriority.values.firstWhere((e) => e.name == (json['priority'] as String)),
      description: json['description'] as String,
      userId: _extractUserId(json),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'targetDate': targetDate.toIso8601String(),
        'priority': priority.name,
        'description': description,
        'userId': userId,
      };
}



