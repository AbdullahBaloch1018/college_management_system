/*
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/admin_panel_model/analytical_by_admin_model.dart';

class AdminAnalyticsRepository {
  final FirebaseFirestore _firestore;

  AdminAnalyticsRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AnalyticsModel> loadAnalytics() async {
    final usersSnapshot = await _firestore.collection('users_database').get();
    final classesSnapshot = await _firestore.collection('classes').get();
    QuerySnapshot subjectsSnapshot;
    try {
      subjectsSnapshot = await _firestore.collection('subjects_database').get();
    } catch (_) {
      subjectsSnapshot = await _firestore.collection('subjects').get();
    }

    final totalStudents = usersSnapshot.docs.where((doc) => (doc.data()['role'] ?? '').toString().toLowerCase() == 'Student').length;
    final totalTeachers = usersSnapshot.docs.where((doc) => (doc.data()['role'] ?? '').toString().toLowerCase() == 'Teacher').length;

    // Placeholders for averages until detailed attendance/grades collections exist
    const double averageAttendance = 0;
    const double averageGrade = 0;

    return AnalyticsModel(
      totalStudents: totalStudents,
      totalTeachers: totalTeachers,
      totalClasses: classesSnapshot.size,
      totalSubjects: subjectsSnapshot.size,
      averageAttendance: averageAttendance,
      averageGrade: averageGrade,
      activeUsers: usersSnapshot.size,
      pendingApprovals: 0,
    );
  }
}

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class AdminAnalyticsRepository {
  final FirebaseFirestore _firestore;
  AdminAnalyticsRepository({FirebaseFirestore? firestore }) : _firestore = firestore ?? FirebaseFirestore.instance;
  // real time users for each count
  Stream<int> watchTotalUsers() {
    return _firestore.collection('users_database').snapshots().map((snap) => snap.size);
  }

  Stream<int> watchTotalStudents() {
    return _firestore
        .collection('users_database')
        .where('role', isEqualTo: 'Student') // case-sensitive — adjust if needed
        .snapshots()
        .map((snap) => snap.size);
  }

  Stream<int> watchTotalTeachers() {
    return _firestore
        .collection('users_database')
        .where('role', isEqualTo: 'Teacher')
        .snapshots()
        .map((snap) => snap.size);
  }

  Stream<int> watchTotalClasses() {
    return _firestore.collection('classes').snapshots().map((snap) => snap.size);
  }

  Stream<int> watchTotalSubjects() {
    return _firestore.collection('subjects_database').snapshots().map((snap) => snap.size);
  }
//   A combined Stream which will be updated if any above of the stream gonna changes up.
  Stream<Map<String, int>> watchDashboardStats(){
    return CombineLatestStream.combine5(
      watchTotalStudents(),
      watchTotalTeachers(),
      watchTotalClasses(),
      watchTotalSubjects(),
      watchTotalUsers(), // optional — can be removed if not needed
      (
          int students,
          int teachers,
          int classes,
          int subjects,
          int totalUsers,
          ) =>
      {
        'students': students,
        'teachers':teachers,
        'classes': classes,
        'subjects': subjects,
        'totalUsers':totalUsers
      },
    );
  }
}