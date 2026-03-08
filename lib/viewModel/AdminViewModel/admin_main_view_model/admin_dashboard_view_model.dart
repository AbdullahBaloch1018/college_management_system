import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  String? _adminName;
  String? _adminEmail;
  bool _isLoading = true;

  String? get adminName  => _adminName;
  String? get adminEmail => _adminEmail;
  bool    get isLoading  => _isLoading;

  final _firestore = FirebaseFirestore.instance;

  AdminDashboardViewModel() {
    _loadAdminInfo();
  }

  Future<void> _loadAdminInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _adminName  = 'Administrator';
      _adminEmail = null;
      _isLoading  = false;
      notifyListeners();
      return;
    }

    _adminEmail = user.email;

    try {
      final doc = await _firestore.collection("users_database").doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        // _adminName = (data['displayName'] as String?)?.trim().isNotEmpty == true ? data['displayName'] : 'Administrator';
        _adminName = data['displayName'];
        _adminEmail = data['email'];
      } else {
        _adminName = 'Administrator';
        _adminEmail = 'Administrator';
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error loading admin name: $e");
      }
      _adminName = 'Administrator';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshAdminInfo() async {
    _isLoading = true;
    notifyListeners();
    await _loadAdminInfo();
  }
}