/*
import 'package:flutter/material.dart';
import 'package:rise_college/Services/admin_panel_Services/admin_user_repository.dart';

import '../../../resources/constants.dart';

class EditUserByAdminViewModel extends ChangeNotifier {

  final AdminUserRepository _repository = AdminUserRepository();
  String? selectedRole = AppConstants.userRoleOptions.first;
  // String? selectedRole;
  String? uid;
  // String? selectedFaculty;
  String? selectedFaculty = AppConstants.facultyOptions.first;

  List<String> get facultyOptions => AppConstants.facultyOptions;


  void initUser(Map<String, dynamic> user) {
    uid = user['uid'];
    selectedRole = user['role'];
    selectedFaculty = user['faculty'];
    notifyListeners();
  }

  void setFaculty(String? value) {
    selectedFaculty = value;
    notifyListeners();
  }

  /// ✅ UPDATED: faculty added
  Future<void> updateUser({
    required String uid,
    required String name,
    required String phone,
    required String? faculty,
  }) async {

    await _repository.updateUser(
      uid: uid,
      displayName: name,
      phone: phone,
      faculty: faculty, // ✅ faculty now updates in Firestore
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:rise_college/Services/admin_panel_Services/admin_user_repository.dart';

class EditUserByAdminViewModel extends ChangeNotifier {
  final AdminUserRepository _repository = AdminUserRepository();

  // ── Faculty stream ────────────────────────────────────────────────────────
  // Live from 'classes' collection — same source as signup and create user
  Stream<List<String>> get facultyOptionsStream =>
      _repository.facultyOptionsStream;

  // ── User state ────────────────────────────────────────────────────────────
  String? uid;
  String? selectedRole;

  // FIX: starts null — initUser() sets it from the actual user doc
  // Previously defaulted to AppConstants.facultyOptions.first which
  // could show the wrong class in the dropdown on open
  String? selectedFaculty;

  void initUser(Map<String, dynamic> user) {
    uid = user['uid']?.toString();
    selectedRole = user['role']?.toString();
    // Restore the exact faculty value stored on the user doc e.g. "ICS – A"
    selectedFaculty = user['faculty']?.toString();
    notifyListeners();
  }

  void setFaculty(String? value) {
    selectedFaculty = value;
    notifyListeners();
  }

  // ── Update user ───────────────────────────────────────────────────────────
  Future<void> updateUser({
    required String uid,
    required String name,
    required String phone,
    required String? faculty,
  }) async {
    await _repository.updateUser(
      uid: uid,
      displayName: name,
      phone: phone,
      faculty: faculty,
    );
  }
}
