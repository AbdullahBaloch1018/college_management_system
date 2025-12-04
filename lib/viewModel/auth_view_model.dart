import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import '../Services/AuthServices/auth_services.dart';
import '../repos/auth_repository.dart';
import '../resources/app_colors.dart';
import '../utils/routes/routes_name.dart';
import '../utils/utils.dart';

class AuthViewModel with ChangeNotifier {
  final _authRepository = AuthRepository();
  final AuthServices _authServices = AuthServices();

  bool _loginLoading = false;
  bool _signupLoading = false;
  final List<String> facultyOptions = [
    'Electronics Engineering',
    'Computer Engineering',
    'Civil Engineering',
    'Electrical Engineering',
  ];
  String? _selectedFaculty;
  String? get selectedFaculty => _selectedFaculty;
  bool get loginLoading => _loginLoading;
  bool get signupLoading => _signupLoading;

  void _setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  void _setSignupLoading(bool value) {
    _signupLoading = value;
    notifyListeners();
  }

  // selecting the faculty method
  void setSelectedFaculty(String? faculty) {
    _selectedFaculty = faculty;
    notifyListeners();
  }

  /// Api Methods
  Future<void> loginWithApi(dynamic data, BuildContext context) async {
    _setLoginLoading(true);
    _authRepository
        .loginApi(data)
        .then((value) {
          if (kDebugMode) {
            print(value);
          }
          _setLoginLoading(false);

          Utils.flushbarMessage(
            context,
            "Login SuccessFully with Api",
            AppColors.success,
            AppColors.black,
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.home,
            (Route<dynamic> route) => false,
          );
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print(error);
          }

          _setLoginLoading(false);

          Utils.flushbarMessage(
            context,
            "Login Failed",
            AppColors.error,
            AppColors.black,
          );
        });
  }

  Future<void> registerWithApi(dynamic data, BuildContext context) async {
    if (kDebugMode) {
      print("Sign up btn loading");
    }
    _setSignupLoading(true);
    _authRepository
        .registerApi(data)
        .then((value) {
          if (kDebugMode) {
            print(value);
          }
          _setSignupLoading(false);

          Utils.flushbarMessage(
            context,
            "Sign Up SuccessFully",
            AppColors.success,
            AppColors.black,
          );

          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.home,
            (Route<dynamic> route) => false,
          );
        })
        .onError((error, stackTrace) {
          if (kDebugMode) {
            print(error);
          }

          _setSignupLoading(false);

          Utils.flushbarMessage(
            context,
            "Sign Up Failed",
            AppColors.error,
            AppColors.black,
          );
        });
  }

  /// Firebase Auth methods
  Future loginWithFirebase(
    String email,
    String password,
    BuildContext context,
  ) async {
    _setLoginLoading(true);
    try{
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      String uid = userCredential.user!.uid;

    //   Fetching user data from firestore
      var userDoc = await FirebaseFirestore.instance.collection("users").doc(uid).get();
      if (!userDoc.exists) {
        throw Exception("User data not found in Firestore");
      }

      String role = userDoc['role'] ?? 'student'; // default to student

      // ✅ Role-based navigation
      if (role == 'admin') {
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.adminDashboardMobileView, (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, RoutesName.navMenu, (route) => false);
      }
      Utils.flushbarMessage(context, "Welcome $role", AppColors.success, AppColors.black);
    }
    on FirebaseAuthException catch (e) {
      _setLoginLoading(false);
      Utils.flushbarMessage(context, "Login Failed: ${e.message}", AppColors.error, AppColors.black);
    } catch (e) {
      _setLoginLoading(false);
      Utils.flushbarMessage(context, "Error: $e", AppColors.error, AppColors.black);
    }
    _authServices.loginWithFirebase(email.toString().trim(), password.toString().trim()).then((value) {
          if (kDebugMode) {
            print(value);
          }
          _setLoginLoading(false);
          Utils.flushbarMessage(
            context,
            "Login SuccessFully with Firebase",
            AppColors.success,
            AppColors.black,
          );
          Navigator.pushNamedAndRemoveUntil(
            context,
            RoutesName.navMenu,
            (route) => false,
          );
        }).onError((error, stackTrace) {
          if (kDebugMode) {
            print("The Error is $error");
          }
          _setLoginLoading(false);
          Utils.flushbarMessage(
            context,
            "Login Failed :( with Firebase",
            AppColors.error,
            AppColors.black,
          );
        });
  }

  Future registerWithFirebase(
    String email,
    String password,
    var rollNumber,
    var faculty,
    String name,
    var phoneNumber,
    BuildContext context,
    var confettiController,
  ) async {
    _setSignupLoading(true);
    try {
      _authServices
          .registerWithFirebase(
            email,
            password,
            name,
            rollNumber,
            faculty,
            phoneNumber,
            context,
          )
          .then((value) async {
            _setSignupLoading(false);
            confettiController.play();
            Utils.flushbarMessage(
              context,
              "Account Created SuccessFully! Welcome To Rise Family",
              AppColors.success,
              AppColors.black,
            );
            // Wait for the confetti animation to finish before navigating away
            await Future.delayed(const Duration(seconds: 4));
            await Navigator.pushNamedAndRemoveUntil(
              context,
              RoutesName.navMenu,
              (route) => false,
            );
          })
          .onError((error, stackTrace) {
            _setSignupLoading(false);
            Utils.flushbarMessage(
              context,
              "Error in account Creation ",
              AppColors.error,
              AppColors.black,
            );
          });
    } catch (e) {
      rethrow;
    }
  }
}
