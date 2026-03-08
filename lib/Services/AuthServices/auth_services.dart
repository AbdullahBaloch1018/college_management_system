/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rise_college/utils/utils.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get User Role
  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection("users_database").doc(uid).get();
    if (!doc.exists) {
      return null;
    } else {
      return doc.data()?['role'];
    }
  }

  /// SIGNUP USER
  Future<User?> registerUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email,password: password,);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password' && context.mounted) {
        Utils.snackBar("The password provided is too weak.", context);
      } else if (e.code == 'email-already-in-use' && context.mounted) {
        Utils.snackBar("The account already exists for that email.", context);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Firebase Signup Error: $e");
      }
      return null;
    }
  }

  /// SAVE USER DATA TO FIRESTORE
  Future<void> saveUserData({
    required String uid,
    required String displayName,
    required String rollNo,
    required String faculty,
    required String email,
    required String phone,
    required String imageUrl,
    required String role,
  }) async {
    try {
      await _firestore.collection("users_database").doc(uid).set({
        "uid": uid,
        "displayName": displayName,
        "email": email,
        "phone": phone,
        "role": role,
        "rollNo": rollNo,
        "faculty": faculty,
        "imageUrl": imageUrl,
        "createdAt": FieldValue.serverTimestamp(),
      });

    } catch (e) {
      if (kDebugMode) {
        print("Firebase Saving Student Info Error: $e");
      }
    }
  }

  /// LOGIN USER
  Future<User?> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' && context.mounted) {
        Utils.snackBar('No user found for that email.', context);
      } else if (e.code == 'wrong-password' && context.mounted) {
        Utils.snackBar('Wrong password provided for that user.', context);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Firebase Login Error: $e");
      }
      return null;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:rise_college/utils/utils.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Get User Role ─────────────────────────────────────────────────────────

  Future<String?> getUserRole(String uid) async {
    final doc = await _firestore.collection("users_database").doc(uid).get();
    if (!doc.exists) return null;
    return doc.data()?['role'];
  }

  // ── Get User Status ───────────────────────────────────────────────────────
  // Returns 'pending' | 'active' | 'rejected'

  Future<String?> getUserStatus(String uid) async {
    final doc = await _firestore.collection("users_database").doc(uid).get();
    if (!doc.exists) return null;
    return doc.data()?['status'];
  }

  // ── Register User ─────────────────────────────────────────────────────────

  Future<User?> registerUser(
      String email,
      String password,
      BuildContext context,
      ) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password' && context.mounted) {
        Utils.snackBar("The password provided is too weak.", context);
      } else if (e.code == 'email-already-in-use' && context.mounted) {
        Utils.snackBar("The account already exists for that email.", context);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Firebase Signup Error: $e");
      return null;
    }
  }

  // ── Save User Data ────────────────────────────────────────────────────────
  // KEY CHANGE: status is saved as 'pending' for self-registered students.
  // Admin must approve before the student can access features.

  Future<void> saveUserData({
    required String uid,
    required String displayName,
    required String faculty,
    required String email,
    required String phone,
    required String imageUrl,
    required String role,
  }) async {
    try {
      await _firestore.collection("users_database").doc(uid).set({
        "uid": uid,
        "displayName": displayName,
        "email": email,
        "phone": phone,
        "role": role,
        "rollNo": "",        // empty — Admin assigns roll number during approval
        "faculty": faculty,
        "imageUrl": imageUrl,
        "status": "pending", // always pending until Admin approves
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) print("Firebase Saving Student Info Error: $e");
    }
  }

  // ── Login User ────────────────────────────────────────────────────────────

  Future<User?> loginUser(
      String email,
      String password,
      BuildContext context,
      ) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' && context.mounted) {
        Utils.snackBar('No user found for that email.', context);
      } else if (e.code == 'wrong-password' && context.mounted) {
        Utils.snackBar('Wrong password provided for that user.', context);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Firebase Login Error: $e");
      return null;
    }
  }

  // ── Logout ────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    await _auth.signOut();
  }
}