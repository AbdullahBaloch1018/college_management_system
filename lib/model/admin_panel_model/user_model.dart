class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String department;
  final String status;
  final String? classId;
  final String? rollNo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department = '',
    this.status = 'Active',
    this.classId,
    this.rollNo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      department: json['department'] ?? '',
      status: json['status'] ?? 'Active',
      classId: json['classId'],
      rollNo: json['rollNo'],
    );
  }
}
