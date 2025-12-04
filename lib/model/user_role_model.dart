class UserRoleModel {
  final String uid;
  final String email;
  final String role; // admin | teacher | student

  UserRoleModel({required this.uid, required this.email, required this.role});
}