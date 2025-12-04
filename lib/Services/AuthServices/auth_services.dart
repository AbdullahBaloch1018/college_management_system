import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/utils.dart';
import '../../viewModel/auth_view_model.dart';

class AuthServices {

  // Login method Functionalities of Firebase
  Future<dynamic> loginWithFirebase(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        // email: emailController.text.trim(),
        email: "thunderball45@gmail.com",
        // password: passwordController.text.trim(),
        password: "adotya",
      );

    } on FirebaseAuthException catch (e) {
          if (kDebugMode) {
            print("'Wrong email or password. Please try again' $e ");
          }
        }
  }

  // Register Methods Functionalities of Firebase
  Future<dynamic> registerWithFirebase(String email, String password, String name,String rollNumber, String faculty, String phoneNumber, BuildContext context, ) async
  {
    final signupProvider = Provider.of<AuthViewModel>(context,listen: false);
    var selectedFaculty = signupProvider.selectedFaculty;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.toString().trim(),
        password: password.toString().trim(),
      );

      // fetching the user
      User? user = userCredential.user;
      String uid = user?.uid ?? '';

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': name.toString().trim(),
        'rollNumber': rollNumber.toString().trim(),
        'faculty': selectedFaculty,
        'email': email.toString().trim(),
        'phoneNumber': phoneNumber.toString().trim(),
        'role': 'student',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // confettiController.play();

      /*ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User created successfully! Welcome to Rise Group Family.'),
          backgroundColor: Colors.green,
        ),
      );*/

      } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already in use.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak. Use at least 6 characters.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      Utils.flushbarMessage(context, "The error in Firebase Exception is $errorMessage", Colors.red, Colors.black);
    } catch (e) {
      rethrow;
    }
  }

//   fetching user role by this method
  Future<dynamic> getUserRole(String uid) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc['role'];
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user role: $e");
      }
      return null;
    }
  }

}
