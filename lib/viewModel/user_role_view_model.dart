/*
import 'package:flutter/material.dart';
import '../services/role_service.dart';

class UserRoleViewModel with ChangeNotifier {
  final RoleService _service = RoleService();

  String? role;
  bool loading = false;

  Future<void> loadRole(String uid) async {
    loading = true;
    notifyListeners();

    // Use mock for now
    role = await _service.getRoleMock(uid);

    // To enable Firebase later
    // role = await _service.getUserRole(uid);

    loading = false;
    notifyListeners();
  }
}
*/
