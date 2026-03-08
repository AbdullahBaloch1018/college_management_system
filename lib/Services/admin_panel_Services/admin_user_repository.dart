/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Faculty options stream ─────────────────────────────────────────────────
  // Single source of truth for ALL faculty dropdowns across the Admin panel.
  // Returns full "className – classSection" labels e.g. ["ICS – A", "ICS – B"]
  // Matches exactly what students store in their 'faculty' field.

  Stream<List<String>> get facultyOptionsStream {
    return _firestore
        .collection('classes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((doc) {
        final data = doc.data();
        final name = data['className']?.toString() ?? '';
        final section = data['classSection']?.toString() ?? '';
        return section.isNotEmpty ? '$name – $section' : name;
      }).where((label) => label.isNotEmpty).toList();
    });
  }

  // ── Create user ───────────────────────────────────────────────────────────

  Future<void> createUserByAdmin({
    required String displayName,
    required String email,
    required String phone,
    required String password,
    required String role, // 'Teacher' | 'Student'
    String? faculty,      // only relevant for Students
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await _firestore.collection("users_database").doc(uid).set({
        "uid": uid,
        "displayName": displayName,
        "email": email,
        "phone": phone,
        "role": role,
        "faculty": faculty ?? "",
        "status": "Active",
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Authentication failed";
    } catch (e) {
      throw "Failed to create user: $e";
    }
  }

  // ── Read all users ────────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> getAllUsersExceptCurrent() {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid == null) {
      return _firestore
          .collection("users_database")
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList());
    }

    return _firestore
        .collection("users_database")
        .where(FieldPath.documentId, isNotEqualTo: currentUid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['uid'] = doc.id;
      return data;
    }).toList());
  }

  // ── Update user ───────────────────────────────────────────────────────────

  Future<void> updateUser({
    required String uid,
    String? displayName,
    String? phone,
    String? status,
    String? faculty,
  }) async {
    final data = <String, dynamic>{
      "updatedAt": FieldValue.serverTimestamp(),
    };

    if (displayName != null) data["displayName"] = displayName;
    if (phone != null) data["phone"] = phone;
    if (status != null) data["status"] = status;
    if (faculty != null) data["faculty"] = faculty;

    if (data.length > 1) {
      await _firestore.collection("users_database").doc(uid).update(data);
    }
  }

  // ── Delete user ───────────────────────────────────────────────────────────

  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection("users_database").doc(uid).delete();
    } catch (e) {
      throw "Failed to Delete user: $e";
    }
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Faculty options stream - live from classes collection
  // Returns full "className - classSection" labels e.g. ["ICS - A", "ICS - B"]
  Stream<List<String>> get facultyOptionsStream {
    return _firestore
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

  // Create user - Admin-created users are active immediately
  Future<void> createUserByAdmin({
    required String displayName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? faculty,
    String? rollNo,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      await _firestore.collection("users_database").doc(uid).set({
        "uid": uid,
        "displayName": displayName,
        "email": email,
        "phone": phone,
        "role": role,
        "faculty": faculty ?? "",
        "rollNo": rollNo ?? "",
        "status": "active", // Admin-created users skip approval
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Authentication failed";
    } catch (e) {
      throw "Failed to create user: $e";
    }
  }

  // Read all users except current logged-in Admin
  Stream<List<Map<String, dynamic>>> getAllUsersExceptCurrent() {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUid == null) {
      return _firestore
          .collection("users_database")
          .orderBy("createdAt", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList());
    }

    return _firestore
        .collection("users_database")
        .where(FieldPath.documentId, isNotEqualTo: currentUid)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['uid'] = doc.id;
      return data;
    }).toList());
  }

  // Approve user - sets status active + saves Admin-assigned roll number
  Future<void> approveUser(String uid, String rollNo) async {
    await _firestore.collection("users_database").doc(uid).update({
      "status": "active",
      "rollNo": rollNo.trim(),
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // Reject user - blocks student from accessing app
  Future<void> rejectUser(String uid) async {
    await _firestore.collection("users_database").doc(uid).update({
      "status": "rejected",
      "updatedAt": FieldValue.serverTimestamp(),
    });
  }

  // Update user fields
  Future<void> updateUser({
    required String uid,
    String? displayName,
    String? phone,
    String? status,
    String? faculty,
    String? rollNo,
  }) async {
    final data = <String, dynamic>{
      "updatedAt": FieldValue.serverTimestamp(),
    };

    if (displayName != null) data["displayName"] = displayName;
    if (phone != null) data["phone"] = phone;
    if (status != null) data["status"] = status;
    if (faculty != null) data["faculty"] = faculty;
    if (rollNo != null) data["rollNo"] = rollNo;

    if (data.length > 1) {
      await _firestore.collection("users_database").doc(uid).update(data);
    }
  }

  // Delete user document from Firestore
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection("users_database").doc(uid).delete();
    } catch (e) {
      throw "Failed to Delete user: $e";
    }
  }
}
