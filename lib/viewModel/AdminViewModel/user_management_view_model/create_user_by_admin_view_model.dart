/*
import 'package:flutter/material.dart';
import 'package:rise_college/resources/app_colors.dart';
import 'package:rise_college/utils/utils.dart';
import '../../../Services/admin_panel_Services/admin_user_repository.dart';
import '../../../resources/constants.dart';

class CreateUserByAdminViewModel extends ChangeNotifier {
  final AdminUserRepository _repo = AdminUserRepository();

  String? userRole = AppConstants.userRoleOptions.first;
  List<String> get userRoleOptions => AppConstants.userRoleOptions;

  bool _loading = false;

  List<String> get facultyOptions => AppConstants.facultyOptions;

  String? _selectedFaculty = AppConstants.facultyOptions.first;


  bool get loading => _loading;
  String? get selectedFaculty => _selectedFaculty;


  // Setting User Role
  void setUserRole(String? value) {
    userRole = value;
    notifyListeners();
  }
  void setLoading(bool value){
    _loading = value;
    notifyListeners();
  }

// selecting the Programs method
  void setSelectedFaculty(String? faculty) {
    _selectedFaculty = faculty;
    notifyListeners();
  }

  // Resetting the form
  void resetForm() {
    _selectedFaculty =AppConstants.facultyOptions.first;
    userRole = AppConstants.userRoleOptions.first;
    notifyListeners();
  }


  // Creating User
  Future<bool> createUser({required String name, required String email, required String password, required String phone, required String role, required String faculty, required BuildContext context,}) async
  {
    try {
    setLoading(true);
      await _repo.createUserByAdmin(displayName: name.toString().trim(),email: email.toString().trim(),password: password.toString().trim(),phone: phone.toString().trim(),role: role.toString(),faculty: faculty.toString(),);

      if(context.mounted) {
      setLoading(false);
        Navigator.pop(context);
        Utils.toastMessage("User Created Successfully", AppColors.success, AppColors.black);
        return true;
      }
        return true;
    } catch (e) {
      setLoading(false);
      if(context.mounted) {
        Utils.toastMessage(e.toString(), AppColors.warning, AppColors.black);
      }
    }
    setLoading(false);
      return false;
  }


}
*/
import 'package:flutter/material.dart';
import 'package:rise_college/resources/app_colors.dart';
import 'package:rise_college/utils/utils.dart';
import '../../../Services/admin_panel_Services/admin_user_repository.dart';
import '../../../resources/constants.dart';

class CreateUserByAdminViewModel extends ChangeNotifier {
  final AdminUserRepository _repo = AdminUserRepository();

  // ── Role ──────────────────────────────────────────────────────────────────
  String? userRole = AppConstants.userRoleOptions.first;
  List<String> get userRoleOptions => AppConstants.userRoleOptions;

  void setUserRole(String? value) {
    userRole = value;
    // Reset faculty when role changes — Teachers don't need a class section
    if (value == 'Teacher') _selectedFaculty = null;
    notifyListeners();
  }

  // ── Faculty ───────────────────────────────────────────────────────────────
  // Live stream from 'classes' collection via repository.
  // Returns full "className – classSection" labels e.g. "ICS – A"
  Stream<List<String>> get facultyOptionsStream => _repo.facultyOptionsStream;

  String? _selectedFaculty;
  String? get selectedFaculty => _selectedFaculty;

  void setSelectedFaculty(String? faculty) {
    _selectedFaculty = faculty;
    notifyListeners();
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  bool _loading = false;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // ── Reset form ────────────────────────────────────────────────────────────
  void resetForm() {
    _selectedFaculty = null;
    userRole = AppConstants.userRoleOptions.first;
    notifyListeners();
  }

  // ── Create user ───────────────────────────────────────────────────────────
  Future<bool> createUser({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String role,
    required String? faculty, // nullable — Teachers may not have a class
    required BuildContext context,
  }) async {
    try {
      setLoading(true);
      await _repo.createUserByAdmin(
        displayName: name.trim(),
        email: email.trim(),
        password: password.trim(),
        phone: phone.trim(),
        role: role,
        faculty: faculty ?? "",
      );

      if (context.mounted) {
        setLoading(false);
        Navigator.pop(context);
        Utils.toastMessage(
            "User Created Successfully", AppColors.success, AppColors.black);
        return true;
      }
      return true;
    } catch (e) {
      setLoading(false);
      if (context.mounted) {
        Utils.toastMessage(e.toString(), AppColors.warning, AppColors.black);
      }
      return false;
    }
  }
}
