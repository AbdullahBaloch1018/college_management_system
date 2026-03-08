library;
/// For Mock Data
/*
import 'package:flutter/foundation.dart';

import '../../../model/teacher_panel_model/student_model.dart';

class AttendanceViewModel extends ChangeNotifier {
  List<StudentModel> _students = [];
  String _selectedClass = '';
  String _selectedSubject = '';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  List<StudentModel> get students => _students;
  String get selectedClass => _selectedClass;
  String get selectedSubject => _selectedSubject;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  void setSelectedClass(String classId) {
    _selectedClass = classId;
    notifyListeners();
    loadStudents();
  }

  void setSelectedSubject(String subjectId) {
    _selectedSubject = subjectId;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  Future<void> loadStudents() async {
    if (_selectedClass.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(milliseconds: 500));
      _students = [
        StudentModel(id: '1', name: 'Ali Ahmed', rollNo: '001', classId: _selectedClass),
        StudentModel(id: '2', name: 'Fatima Khan', rollNo: '002', classId: _selectedClass),
        StudentModel(id: '3', name: 'Hassan Raza', rollNo: '003', classId: _selectedClass, attendanceStatus: 'Absent'),
        StudentModel(id: '4', name: 'Ayesha Malik', rollNo: '004', classId: _selectedClass),
        StudentModel(id: '5', name: 'Ahmed Ali', rollNo: '005', classId: _selectedClass),
      ];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleAttendance(String studentId) {
    final index = _students.indexWhere((s) => s.id == studentId);
    if (index != -1) {
      _students[index].attendanceStatus = _students[index].attendanceStatus == 'Present' ? 'Absent' : 'Present';
      notifyListeners();
    }
  }

  // Firebase method - Save attendance to Firestore
  Future<bool> saveAttendance() async {
    try {
      // TODO: Implement Firebase save
      // final batch = FirebaseFirestore.instance.batch();
      // for (var student in _students) {
      //   final docRef = FirebaseFirestore.instance
      //       .collection('attendance')
      //       .doc('${_selectedDate.toString()}_${_selectedClass}_${_selectedSubject}_${student.id}');
      //   batch.set(docRef, {
      //     'studentId': student.id,
      //     'classId': _selectedClass,
      //     'subjectId': _selectedSubject,
      //     'date': Timestamp.fromDate(_selectedDate),
      //     'status': student.attendanceStatus,
      //     'createdAt': FieldValue.serverTimestamp(),
      //   });
      // }
      // await batch.commit();
      
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }
}
*/
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:rise_college/Services/teacher_panel_services/attendance_repository/attendance_by_teacher_repo.dart';
import '../../../model/teacher_panel_model/student_model.dart';

class AttendanceViewModel extends ChangeNotifier {
  final AttendanceByTeacherRepo _attendanceService = AttendanceByTeacherRepo();

  List<StudentModel> _students = [];
  String _selectedClass = '';
  String _selectedSubject = '';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _isSaving = false;

  // Stream subscriptions — cancelled when no longer needed
  StreamSubscription? _studentsSubscription;
  StreamSubscription? _attendanceSubscription;

  List<StudentModel> get students => _students;
  String get selectedClass => _selectedClass;
  String get selectedSubject => _selectedSubject;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  // Builds doc ID: e.g. "ICS_Math_2026-02-24"
  String get _attendanceDocId {
    final dateStr = _selectedDate.toIso8601String().split('T').first;
    return '${_selectedClass}_${_selectedSubject}_$dateStr';
  }

  void setSelectedClass(String classId) {
    _selectedClass = classId;
    notifyListeners();
    _listenToStudents();
  }

  void setSelectedSubject(String subject) {
    _selectedSubject = subject;
    notifyListeners();
    // Re-subscribe attendance stream with new doc ID
    if (_students.isNotEmpty) _listenToAttendance();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    // Re-subscribe attendance stream with new doc ID
    if (_students.isNotEmpty) _listenToAttendance();
  }

  /// Listens to students collection in real time
  void _listenToStudents() {
    if (_selectedClass.isEmpty) return;

    // Cancel previous subscription before starting a new one
    _studentsSubscription?.cancel();
    _attendanceSubscription?.cancel();

    _isLoading = true;
    _students = [];
    notifyListeners();

    _studentsSubscription = _attendanceService.streamStudentsByClass(_selectedClass).listen( (fetchedStudents) {
        _students = fetchedStudents;
        _isLoading = false;
        notifyListeners();

        // Once students are loaded, start listening to attendance
        _listenToAttendance();
      },
      onError: (e) {
        debugPrint('Error streaming students: $e');
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  /// Listens to attendance subcollection in real time
  /// and merges status into the current student list
  void _listenToAttendance() {
    if (_selectedSubject.isEmpty || _students.isEmpty) return;

    // Cancel previous attendance subscription
    _attendanceSubscription?.cancel();

    _attendanceSubscription = _attendanceService.streamExistingAttendance(_attendanceDocId).listen( (existingStatus) {
        for (var student in _students) {
          student.attendanceStatus = existingStatus[student.id] ?? 'Present';
        }
        notifyListeners();
      },
      onError: (e) {
        debugPrint('Error streaming attendance: $e');
      },
    );
  }

  void toggleAttendance(String studentId) {
    final index = _students.indexWhere((s) => s.id == studentId);
    if (index != -1) {
      _students[index].attendanceStatus = _students[index].attendanceStatus == 'Present' ? 'Absent' : 'Present';
      notifyListeners();
    }
  }

  Future<bool> saveAttendance() async {
    if (_selectedClass.isEmpty || _selectedSubject.isEmpty) return false;

    _isSaving = true;
    notifyListeners();

    try {
      await _attendanceService.saveAttendance(
        attendanceDocId: _attendanceDocId,
        classId: _selectedClass,
        subject: _selectedSubject,
        date: _selectedDate,
        students: _students,
      );
      return true;
    } catch (e) {
      debugPrint('Error saving attendance: $e');
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  /// Always cancel subscriptions when ViewModel is disposed to prevent memory leaks

  @override
  void dispose() {
    _studentsSubscription?.cancel();
    _attendanceSubscription?.cancel();
    super.dispose();
  }
}