class ExpenseCategoryModel {
  ExpenseCategoryModel({required this.id, required this.name, required this.icon});
  final String id;
  final String name;
  final String icon;

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) => ExpenseCategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'icon': icon,
      };
}



