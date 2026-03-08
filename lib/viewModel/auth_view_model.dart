/*
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rise_college/Services/cloudinary_services.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
import '../Services/AuthServices/auth_services.dart';
import '../resources/app_colors.dart';
import '../utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepos = AuthRepository();
  final CloudinaryServices _cloudinary = CloudinaryServices();

  bool _loginLoading = false;
  bool _signupLoading = false;

  // null by default — user must actively pick from dropdown
  String? _selectedFaculty;

  bool get loginLoading => _loginLoading;
  bool get signupLoading => _signupLoading;
  String? get selectedFaculty => _selectedFaculty;

  void _setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  void _setSignupLoading(bool value) {
    _signupLoading = value;
    notifyListeners();
  }

  void setSelectedFaculty(String? faculty) {
    _selectedFaculty = faculty;
    notifyListeners();
  }

  // ── Faculty options stream ─────────────────────────────────────────────────
  // Fetches live from 'classes' collection.
  // Each item is the full "className – classSection" label e.g. "ICS – A".
  // Students are locked to one section so we show all class+section combos.
  // The stored 'faculty' value on the student doc will be "ICS – A" exactly.

  Stream<List<String>> get facultyOptionsStream {
    return FirebaseFirestore.instance
        .collection('classes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        final name = data['className']?.toString() ?? '';
        final section = data['classSection']?.toString() ?? '';
        // Full label e.g. "ICS – A" — saved as faculty on student doc
        return section.isNotEmpty ? '$name – $section' : name;
      }).where((label) => label.isNotEmpty).toList();
    });
  }

  // ── Register ──────────────────────────────────────────────────────────────

  Future<bool> registerWithFirebase(
      String email,
      String password,
      String rollNo,
      String faculty,
      String name,
      String phoneNumber,
      File? selectedImageFile,
      BuildContext context,
      var confettiController,
      ) async {
    _setSignupLoading(true);
    try {
      // 1. Upload image to Cloudinary
      String? imageUrl = await _cloudinary.uploadImageToCloudinary(
        selectedImageFile!,
      );

      if (imageUrl == null) {
        _setSignupLoading(false);
        if (context.mounted) {
          Utils.flushbarMessage(
            context,
            "Image Upload Failed",
            AppColors.error,
            AppColors.black,
          );
        }
        return false;
      }

      if (!context.mounted) {
        _setSignupLoading(false);
        return false;
      }

      // 2. Create Firebase Auth user
      User? user = await _authRepos.registerUser(email, password, context);

      if (user == null) {
        _setSignupLoading(false);
        if (context.mounted) {
          Utils.flushbarMessage(
            context,
            "Sign Up Failed",
            AppColors.error,
            AppColors.black,
          );
        }
        return false;
      }

      // 3. Save profile to Firestore
      // faculty stores full label e.g. "ICS – A"
      await _authRepos.saveUserData(
        uid: user.uid,
        displayName: name,
        rollNo: rollNo,
        faculty: faculty, // e.g. "ICS – A"
        email: email,
        phone: phoneNumber,
        imageUrl: imageUrl,
        role: 'Student',
      );

      _setSignupLoading(false);

      if (context.mounted) {
        Utils.flushbarMessage(
          context,
          "Account Created Successfully",
          AppColors.success,
          AppColors.black,
        );
      }

      return true;
    } catch (e) {
      _setSignupLoading(false);
      if (context.mounted) {
        Utils.flushbarMessage(
          context,
          "Error: $e",
          AppColors.error,
          AppColors.black,
        );
      }
      return false;
    }
  }

  // ── Login ─────────────────────────────────────────────────────────────────

  Future<void> loginWithFirebase(
      String email,
      String password,
      BuildContext context,
      ) async {
    _setLoginLoading(true);
    try {
      User? user = await _authRepos.loginUser(email, password, context);

      if (user == null) {
        _setLoginLoading(false);
        if (context.mounted) {
          Utils.flushbarMessage(
            context,
            "No Account Existed. Kindly Create a New Account!",
            AppColors.error,
            AppColors.black,
          );
        }
        return;
      }

      final role = await _authRepos.getUserRole(user.uid);

      if (!context.mounted) {
        _setLoginLoading(false);
        return;
      }

      if (role == 'Admin') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.adminMainView,
              (route) => false,
        );
      } else if (role == 'Teacher') {
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.teacherDashboardView,
              (route) => false,
        );
      } else {
        Utils.flushbarMessage(
          context,
          "Login Successful!",
          AppColors.success,
          AppColors.black,
        );
        Navigator.pushNamedAndRemoveUntil(
          context,
          RoutesName.navMenu,
              (route) => false,
        );
      }

      _setLoginLoading(false);
    } catch (e) {
      _setLoginLoading(false);
      if (context.mounted) {
        Utils.flushbarMessage(
          context,
          "Login Error: $e",
          AppColors.error,
          AppColors.black,
        );
      }
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout(BuildContext context) async {
    await _authRepos.logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesName.login,
            (route) => false,
      );
    }
  }
}*/
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rise_college/Services/cloudinary_services.dart';
import 'package:rise_college/utils/routes/routes_name.dart';
import '../Services/AuthServices/auth_services.dart';
import '../resources/app_colors.dart';
import '../utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final AuthRepository _authRepos = AuthRepository();
  final CloudinaryServices _cloudinary = CloudinaryServices();

  bool _loginLoading = false;
  bool _signupLoading = false;
  String? _selectedFaculty;

  bool get loginLoading => _loginLoading;
  bool get signupLoading => _signupLoading;
  String? get selectedFaculty => _selectedFaculty;

  void _setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  void _setSignupLoading(bool value) {
    _signupLoading = value;
    notifyListeners();
  }

  void setSelectedFaculty(String? faculty) {
    _selectedFaculty = faculty;
    notifyListeners();
  }

  // Faculty options stream - live from classes collection
  Stream<List<String>> get facultyOptionsStream {
    return FirebaseFirestore.instance
        .collection('classes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        final name = data['className']?.toString() ?? '';
        final section = data['classSection']?.toString() ?? '';
        return section.isNotEmpty ? '$name - $section' : name;
      }).where((label) => label.isNotEmpty).toList();
    });
  }

  // Register
  // rollNo removed - Admin assigns it during approval
  Future<bool> registerWithFirebase(
      String email,
      String password,
      String faculty,
      String name,
      String phoneNumber,
      File? selectedImageFile,
      BuildContext context,
      var confettiController,
      ) async {
    _setSignupLoading(true);
    try {
      String? imageUrl =
      await _cloudinary.uploadImageToCloudinary(selectedImageFile!);

      if (imageUrl == null) {
        _setSignupLoading(false);
        if (context.mounted) {
          Utils.flushbarMessage(
              context, "Image Upload Failed", AppColors.error, AppColors.black);
        }
        return false;
      }

      if (!context.mounted) {
        _setSignupLoading(false);
        return false;
      }

      User? user = await _authRepos.registerUser(email, password, context);

      if (user == null) {
        _setSignupLoading(false);
        if (context.mounted) {
          Utils.flushbarMessage(
              context, "Sign Up Failed", AppColors.error, AppColors.black);
        }
        return false;
      }

      // rollNo saved as empty string - Admin assigns during approval
      await _authRepos.saveUserData(
        uid: user.uid,
        displayName: name,
        faculty: faculty,
        email: email,
        phone: phoneNumber,
        imageUrl: imageUrl,
        role: 'Student',
      );

      _setSignupLoading(false);

      if (context.mounted) {
        Utils.flushbarMessage(context, "Account Created Successfully",
            AppColors.success, AppColors.black);
      }

      return true;
    } catch (e) {
      _setSignupLoading(false);
      if (context.mounted) {
        Utils.flushbarMessage(
            context, "Error: $e", AppColors.error, AppColors.black);
      }
      return false;
    }
  }

  // Login
  // Checks status after login for Students:
  //   pending  -> PendingApprovalView
  //   rejected -> sign out + error message
  //   active   -> normal navigation
  Future<void> loginWithFirebase(
      String email,
      String password,
      BuildContext context,
      ) async {
    _setLoginLoading(true);
    try {
      User? user = await _authRepos.loginUser(email, password, context);

      if (user == null) {
        _setLoginLoading(false);
        if (context.mounted) {
          Utils.flushbarMessage(context,
              "No Account Found. Please create a new account!",
              AppColors.error, AppColors.black);
        }
        return;
      }

      final role = await _authRepos.getUserRole(user.uid);

      // Admins and Teachers skip status check entirely
      if (role == 'Admin' || role == 'Teacher') {
        if (!context.mounted) { _setLoginLoading(false); return; }
        if (role == 'Admin') {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.adminMainView, (route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, RoutesName.teacherDashboardView, (route) => false);
        }
        _setLoginLoading(false);
        return;
      }

      // Students - check approval status
      final status = await _authRepos.getUserStatus(user.uid);
      if (!context.mounted) { _setLoginLoading(false); return; }

      if (status == 'pending') {
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.pendingApprovalView, (route) => false);
      } else if (status == 'rejected') {
        await _authRepos.logout();
        if (context.mounted) {
          Utils.flushbarMessage(
            context,
            "Your account has been rejected. Please contact your college.",
            AppColors.error,
            AppColors.black,
          );
        }
      } else {
        // active
        Utils.flushbarMessage(
            context, "Login Successful!", AppColors.success, AppColors.black);
        Navigator.pushNamedAndRemoveUntil(
            context, RoutesName.navMenu, (route) => false);
      }

      _setLoginLoading(false);
    } catch (e) {
      _setLoginLoading(false);
      if (context.mounted) {
        Utils.flushbarMessage(
            context, "Login Error: $e", AppColors.error, AppColors.black);
      }
    }
  }

  // Logout
  Future<void> logout(BuildContext context) async {
    await _authRepos.logout();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.login, (route) => false);
    }
  }
}
