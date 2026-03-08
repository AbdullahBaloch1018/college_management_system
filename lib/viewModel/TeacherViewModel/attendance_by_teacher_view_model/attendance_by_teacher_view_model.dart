
import 'dart:async';
import 'package:flutter/foundation.dart';

import '../../../Services/teacher_panel_services/attendance_repository/attendance_repository.dart';
import '../../../model/teacher_panel_model/class_model.dart';
import '../../../model/teacher_panel_model/student_attendance_model.dart';
import '../../../model/teacher_panel_model/subject_model.dart';

class AttendanceByTeacherViewModel extends ChangeNotifier {
  final AttendanceRepository _repo = AttendanceRepository();

  // ── Dropdown data ─────────────────────────────
  List<ClassModel> classes = [];
  List<SubjectModel> subjects = [];
  List<StudentAttendanceModel> students = [];

  // ── Selected values ───────────────────────────
  ClassModel? selectedClass;
  SubjectModel? selectedSubject;
  DateTime selectedDate = DateTime.now();

  // ── UI state ──────────────────────────────────
  bool isLoadingClasses = false;
  bool isLoadingSubjects = false;
  bool isLoadingStudents = false;
  bool isSaving = false;
  String? errorMessage;

  // ── Stream subscriptions ──────────────────────
  StreamSubscription? _classSubscription;
  StreamSubscription? _subjectSubscription;
  StreamSubscription? _studentSubscription;

  AttendanceByTeacherViewModel() {
    _listenToClasses();
  }

  // ── Classes ───────────────────────────────────

  void _listenToClasses() {
    isLoadingClasses = true;
    notifyListeners();

    _classSubscription?.cancel();
    _classSubscription = _repo.getClassesStream().listen(
          (data) {
        classes = data;
        isLoadingClasses = false;
        notifyListeners();
      },
      onError: (e) {
        errorMessage = 'Failed to load classes: $e';
        isLoadingClasses = false;
        notifyListeners();
      },
    );
  }

  // ── On class selected ─────────────────────────

  void setSelectedClass(ClassModel classModel) {
    selectedClass = classModel;
    selectedSubject = null;
    subjects = [];
    students = [];
    errorMessage = null;
    notifyListeners();

    // Pass classId for exact subject filtering (section-aware)
    _listenToSubjects(classModel.classId);
  }

  void _listenToSubjects(String classId) {
    isLoadingSubjects = true;
    notifyListeners();

    _subjectSubscription?.cancel();
    _subjectSubscription = _repo.getSubjectsStream(classId).listen(
          (data) {
        subjects = data;
        isLoadingSubjects = false;
        notifyListeners();
      },
      onError: (e) {
        errorMessage = 'Failed to load subjects: $e';
        isLoadingSubjects = false;
        notifyListeners();
      },
    );
  }

  // ── On subject selected ───────────────────────

  void setSelectedSubject(SubjectModel subject) {
    selectedSubject = subject;
    errorMessage = null;
    notifyListeners();

    if (selectedClass != null) {
      // Pass full display label e.g. "ICS – A" to match student 'faculty' field
      _listenToStudents(selectedClass!.displayName);
    }
  }

  void _listenToStudents(String classDisplayName) {
    isLoadingStudents = true;
    students = [];
    notifyListeners();

    _studentSubscription?.cancel();
    _studentSubscription =
        _repo.getStudentsStream(classDisplayName).listen(
              (data) async {
            students = data;
            isLoadingStudents = false;
            await _restoreAttendance();
            notifyListeners();
          },
          onError: (e) {
            errorMessage = 'Failed to load students: $e';
            isLoadingStudents = false;
            notifyListeners();
          },
        );
  }

  // ── Date change ───────────────────────────────

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();

    if (selectedClass != null &&
        selectedSubject != null &&
        students.isNotEmpty) {
      _restoreAttendance().then((_) => notifyListeners());
    }
  }

  // ── Restore previously saved attendance ───────

  Future<void> _restoreAttendance() async {
    if (selectedClass == null || selectedSubject == null) return;

    final saved = await _repo.fetchExistingAttendance(
      classId: selectedClass!.classId,
      subjectId: selectedSubject!.subjectId,
      date: selectedDate,
    );

    if (saved.isEmpty) return;

    for (final student in students) {
      if (saved.containsKey(student.uid)) {
        student.attendanceStatus = saved[student.uid]!;
      }
    }
  }

  // ── Toggle / Mark All ─────────────────────────

  void toggleAttendance(String uid) {
    final index = students.indexWhere((s) => s.uid == uid);
    if (index == -1) return;
    students[index].attendanceStatus =
    students[index].attendanceStatus == 'Present' ? 'Absent' : 'Present';
    notifyListeners();
  }

  void markAllPresent() {
    for (final s in students) {
      s.attendanceStatus = 'Present';
    }
    notifyListeners();
  }

  void markAllAbsent() {
    for (final s in students) {
      s.attendanceStatus = 'Absent';
    }
    notifyListeners();
  }

  // ── Stats ─────────────────────────────────────

  int get presentCount =>
      students.where((s) => s.attendanceStatus == 'Present').length;

  int get absentCount => students.length - presentCount;

  double get presentPercentage =>
      students.isEmpty ? 0 : (presentCount / students.length * 100);

  // ── Save ──────────────────────────────────────

  Future<bool> saveAttendance() async {
    if (selectedClass == null || selectedSubject == null || students.isEmpty) {
      return false;
    }

    isSaving = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _repo.saveAttendance(
        selectedClass: selectedClass!,
        selectedSubject: selectedSubject!,
        date: selectedDate,
        students: students,
      );
      isSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = 'Failed to save: $e';
      isSaving = false;
      notifyListeners();
      return false;
    }
  }

  // ── Cleanup ───────────────────────────────────

  @override
  void dispose() {
    _classSubscription?.cancel();
    _subjectSubscription?.cancel();
    _studentSubscription?.cancel();
    super.dispose();
  }
}
