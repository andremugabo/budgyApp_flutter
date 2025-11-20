
enum Gender { MALE, FEMALE }
enum UserRole { ADMIN, USER }

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.gender,
    this.dob,
    this.image,
    required this.role,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final Gender gender;
  final DateTime? dob;
  final String? image;
  final UserRole role;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      gender: Gender.values.firstWhere((g) => g.name == (json['gender'] as String)),
      dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : null,
      image: json['image'] as String?,
      role: UserRole.values.firstWhere((r) => r.name == (json['role'] as String)),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'gender': gender.name,
      'dob': dob?.toIso8601String(),
      'image': image,
      'role': role.name,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

