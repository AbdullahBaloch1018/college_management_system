import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class HomeViewModel with ChangeNotifier {
  // final AuthServices _authServices =AuthServices();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _username;
  String? get username => _username;

  String? _profileImage;
  String? get profileImage => _profileImage;

  void setLoading(bool val){
    _isLoading = val;
    notifyListeners();
  }

  Future<void> fetchHomeData() async {
    setLoading(true);

    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        _username = "Guest User";
        _profileImage = null;
      } else {
        // Fetch from users_database for name, email, phone
        final usersDoc = await _firestore.collection("users_database").doc(currentUser.uid).get();
        // Fetch from students_database for rollNumber, faculty, imageUrl (if student)
        final studentsDoc = await _firestore.collection("students_database").doc(currentUser.uid).get();

        if (usersDoc.exists) {
          final usersData = usersDoc.data();
          _username = usersData?['name'] ?? currentUser.displayName ?? currentUser.email?.split('@').first ?? "User";
          if (studentsDoc.exists) {
            final studentsData = studentsDoc.data();
            _profileImage = studentsData?['imageUrl'] as String?;
          } else {
            _profileImage = null;
          }
        } else {
          _username = currentUser.email?.split('@').first ?? "User";
          _profileImage = null;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching user data: $e");
      }
      _username = "Error Loading";
      _profileImage = null;
    } finally {

      setLoading(false);
    }
  }
}
