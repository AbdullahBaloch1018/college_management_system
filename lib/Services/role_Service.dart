/*
import 'package:cloud_firestore/cloud_firestore.dart';

class RoleService {
  // Mock Data (Remove this when Firebase is enabled)
  Future<String> getRoleMock(String uid) async {
    await Future.delayed(Duration(milliseconds: 600));
    if (uid == "admin123") return "admin";
    if (uid == "teacher123") return "teacher";
    return "unknown";
  }

// Firebase Implementation (use later)
  Future<String> getUserRole(String uid) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection("users").doc(uid).get();
    return snap["role"];
  }
}
*/
