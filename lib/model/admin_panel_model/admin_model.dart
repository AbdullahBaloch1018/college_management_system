// models/admin_model.dart
class AdminModel {
  final String id;
  final String name;
  final String email;
  final String role;

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
    );
  }
}