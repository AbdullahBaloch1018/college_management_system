import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../Services/teacher_panel_services/teacher_dashboard_repository.dart';

class TeacherDashboardViewModel extends ChangeNotifier {
  final TeacherDashboardRepository _repo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TeacherDashboardViewModel({TeacherDashboardRepository? repo})
      : _repo = repo ?? TeacherDashboardRepository();

  bool _isLoading = true;
  String _error = '';

  Map<String, dynamic>? _profile;
  int _totalStudents = 0;
  int _totalClasses = 0;
  int _totalSubjects = 0;

  // ── Mock / Dummy data (replace with real streams later) ──────────────────
  final double _averageAttendance = 86.4;
  final Map<String, double> _attendanceSummary = {
    'Present': 78.0,
    'Absent': 14.0,
    'Late': 8.0,
  };
  final int _atRiskCount = 4;
  final List<Map<String, dynamic>> _atRiskStudents = [
    {'displayName': 'Ali Hassan', 'rollNo': '2101', 'classId': 'FA - Simple'},
    {'displayName': 'Sara Ahmed', 'rollNo': '2112', 'classId': 'FA'},
    {'displayName': 'Muhammad Usman', 'rollNo': '110', 'classId': 'ICS'},
  ];
  // ─────────────────────────────────────────────────────────────────────────

  List<Map<String, dynamic>> _todaySchedule = [];

  // Getters
  bool get isLoading => _isLoading;
  String get error => _error;

  Map<String, dynamic>? get profile => _profile;
  int get totalStudents => _totalStudents;
  int get totalClasses => _totalClasses;
  int get totalSubjects => _totalSubjects;
  double get averageAttendance => _averageAttendance;
  Map<String, double> get attendanceSummary => _attendanceSummary;
  int get atRiskStudents => _atRiskCount;
  List<Map<String, dynamic>> get atRiskStudentsList => _atRiskStudents;
  List<Map<String, dynamic>> get todaySchedule => _todaySchedule;

  StreamSubscription<Map<String, dynamic>>? _sub;

  Future<void> loadTeacherData() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      _error = "No user logged in";
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // ── Fetch teacher profile
      final profileSnap = await _firestore.collection('users_database').doc(uid).get();
      final data = profileSnap.data() ?? {};
      final name = data['displayName']?.toString() ?? data['name']?.toString() ?? 'Teacher';
      final faculty = data['faculty']?.toString() ?? data['department']?.toString() ?? '';

      // FIX #1: use consistent keys ('department') so the View can read them
      _profile = {
        'uid': uid,
        'displayName': name,
        'email': data['email'] ?? '',
        'faculty': faculty,
      };

      // ── Total students count ─────────────────────────────────────────────
      _totalStudents = (await _repo.getTotalStudentsCount()) ?? 0;

      // ── Real-time combined stream ────────────────────────────────────────
      final today = _getDayName(DateTime.now().weekday);

      // FIX #2: cancel any existing subscription before creating a new one
      await _sub?.cancel();
      _sub = null;

      _sub = _repo.watchDashboardData(uid, name, today).listen(
            (snapshot) {
          _totalClasses = snapshot['totalClasses'] ?? 0;
          _totalSubjects = snapshot['totalSubjects'] ?? 0;
          _todaySchedule = List<Map<String, dynamic>>.from(snapshot['todaySchedule'] ?? []);

          // FIX #3: set loading false inside the stream callback so the first
          // real data frame is shown — not an empty intermediate state.
          if (_isLoading) {
            _isLoading = false;
          }
          notifyListeners();
        },
        onError: (Object e) {
          _error = e.toString();
          _isLoading = false;
          notifyListeners();
        },
      );

      // Safety: if stream hasn't emitted yet, stop the spinner after profile load
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  String _getDayName(int weekday) {
    const days = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[weekday];
  }

  Future<void> refresh() async {
    await loadTeacherData();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}