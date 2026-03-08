/*
// Admin User Management View Model
import 'package:flutter/foundation.dart';
import 'package:rise_college/Services/admin_panel_Services/admin_user_repository.dart';
import 'package:rise_college/resources/app_colors.dart';
import 'package:rise_college/utils/utils.dart';

import '../../../resources/constants.dart';

class UserManagementViewModel with ChangeNotifier {
  final AdminUserRepository _repository = AdminUserRepository();
  List<String> get facultyOptions => AppConstants.facultyOptions;

  String? _selectedFaculty = AppConstants.facultyOptions.first;

  bool _loading = false;
  String _selectedRole = 'All';

  bool get loading => _loading;
  String get selectedRole => _selectedRole;

  String? get selectedFaculty => _selectedFaculty;

  void setSelectedFaculty(String? value) {
    _selectedFaculty = value;
    notifyListeners();
  }

  void filterByRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // Get All User
  Stream<List<Map<String, dynamic>>> get allUsersStream =>
      _repository.getAllUsersExceptCurrent();

  // Delete User
  Future<void> deleteUserByAdmin(String uid) async {
    try {
      setLoading(true);
      await _repository.deleteUser(uid);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      if (kDebugMode) {
        print("The Error in Deletion is ${e.toString()}");
      }
      Utils.toastMessage(
        "The Error in Deletion is ${e.toString()}",
        AppColors.warning,
        AppColors.black,
      );
      // handle error if needed
    }
    setLoading(false);
  }

  // UPDATE
  Future<void> updateUserByAdmin({
    required String uid,
    required String name,
    required String phone,
    required String status,
    required String faculty,
  }) async {
    await _repository.updateUser(
      uid: uid,
      displayName: name,
      phone: phone,
      status: status,
      faculty: faculty,
    );
  }
}
*/
import 'package:flutter/foundation.dart';
import 'package:rise_college/Services/admin_panel_Services/admin_user_repository.dart';
import 'package:rise_college/resources/app_colors.dart';
import 'package:rise_college/utils/utils.dart';

class UserManagementViewModel with ChangeNotifier {
  final AdminUserRepository _repository = AdminUserRepository();

  bool _loading = false;
  String _selectedRole = 'All';
  String _selectedStatus = 'all';

  bool get loading => _loading;
  String get selectedRole => _selectedRole;
  String get selectedStatus => _selectedStatus;

  void filterByRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  void filterByStatus(String status) {
    _selectedStatus = status;
    notifyListeners();
  }

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Stream<List<Map<String, dynamic>>> get allUsersStream =>
      _repository.getAllUsersExceptCurrent();

  // Approve - now requires rollNo assigned by Admin
  Future<void> approveUser(String uid, String rollNo) async {
    try {
      setLoading(true);
      await _repository.approveUser(uid, rollNo);
      setLoading(false);
      Utils.toastMessage(
          "Student Approved Successfully", AppColors.success, AppColors.black);
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("Approve error: $e");
      Utils.toastMessage(
          "Failed to approve user", AppColors.warning, AppColors.black);
    }
  }

  Future<void> rejectUser(String uid) async {
    try {
      setLoading(true);
      await _repository.rejectUser(uid);
      setLoading(false);
      Utils.toastMessage("Student Rejected", AppColors.warning, AppColors.black);
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("Reject error: $e");
      Utils.toastMessage(
          "Failed to reject user", AppColors.warning, AppColors.black);
    }
  }

  Future<void> deleteUserByAdmin(String uid) async {
    try {
      setLoading(true);
      await _repository.deleteUser(uid);
      setLoading(false);
      Utils.toastMessage("User Deleted", AppColors.warning, AppColors.black);
    } catch (e) {
      setLoading(false);
      if (kDebugMode) print("Delete error: $e");
      Utils.toastMessage(
          "Delete failed: ${e.toString()}", AppColors.warning, AppColors.black);
    }
  }

  Future<void> updateUserByAdmin({
    required String uid,
    required String name,
    required String phone,
    required String status,
    required String faculty,
  }) async {
    await _repository.updateUser(
      uid: uid,
      displayName: name,
      phone: phone,
      status: status,
      faculty: faculty,
    );
  }
}
