enum AlertType { INFO, WARNING, ERROR, SUCCESS }

class AlertModel {
  AlertModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.alert,
    required this.isRead,
  });

  final String id;
  final String userId;
  final String title;
  final String message;
  final AlertType alert;
  final bool isRead;

  factory AlertModel.fromJson(Map<String, dynamic> json) => AlertModel(
        id: json['id'] as String,
        userId: (json['users'] is Map<String, dynamic>) ? (json['users']['id'] as String) : json['userId'] as String,
        title: json['title'] as String,
        message: json['message'] as String,
        alert: AlertType.values.firstWhere((e) => e.name == (json['alert'] as String)),
        isRead: (json['isRead'] as bool? ?? false),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'userId': userId,
        'title': title,
        'message': message,
        'alert': alert.name,
        'isRead': isRead,
      };
}



