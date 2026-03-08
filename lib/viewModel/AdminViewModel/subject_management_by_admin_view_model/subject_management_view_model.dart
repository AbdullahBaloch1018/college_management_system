/*
import 'package:flutter/material.dart';
import '../../../Services/admin_panel_Services/subject_repository.dart';

class SubjectManagementViewModel extends ChangeNotifier {
  final SubjectRepository _repository;

  SubjectManagementViewModel({SubjectRepository? repository}) : _repository = repository ?? SubjectRepository();

  String? _selectedTeacherId;
  String? _selectedTeacherName;
  String? _selectedClass;

  String? get selectedTeacherId => _selectedTeacherId;
  String? get selectedTeacherName => _selectedTeacherName;
  String? get selectedClass => _selectedClass;

  void setSelectedTeacher(String? uid, String? name) {
    _selectedTeacherId = uid;
    _selectedTeacherName = name;
    notifyListeners();
  }

  void setSelectedClass(String? value) {
    _selectedClass = value;
    notifyListeners();
  }

  Future<bool> addSubject(Map<String, dynamic> subjectData) async {
    return await _repository.addSubject(subjectData);
  }

  Future<bool> updateSubject(Map<String, dynamic> subjectData) async {
    return await _repository.updateSubject(subjectData);
  }

  Future<bool> deleteSubject(String id) async {
    return await _repository.deleteSubject(id);
  }

  // Streams
  Stream<List<Map<String, dynamic>>> get subjectsStream => _repository.watchSubjectsStream();

  Stream<List<Map<String, dynamic>>> get teacherStream => _repository.watchTeachersStream();

  Stream<List<Map<String, dynamic>>> get classesStream => _repository.watchClassesStream();
}*/
//By Claude
import 'package:flutter/material.dart';
import '../../../Services/admin_panel_Services/subject_repository.dart';

class SubjectManagementViewModel extends ChangeNotifier {
  final SubjectRepository _repository;

  SubjectManagementViewModel({SubjectRepository? repository})
      : _repository = repository ?? SubjectRepository();

  // ── Teacher selection ─────────────────────────
  String? _selectedTeacherId;
  String? _selectedTeacherName;

  String? get selectedTeacherId => _selectedTeacherId;
  String? get selectedTeacherName => _selectedTeacherName;

  void setSelectedTeacher(String? uid, String? name) {
    _selectedTeacherId = uid;
    _selectedTeacherName = name;
    notifyListeners();
  }

  // ── Class selection ───────────────────────────
  // KEY CHANGE: store the full class map instead of just className string.
  // This gives access to classId + className + classSection for subjects.

  Map<String, dynamic>? _selectedClassMap;

  Map<String, dynamic>? get selectedClassMap => _selectedClassMap;

  /// Display label shown in the dropdown e.g. "ICS – A"
  String? get selectedClassLabel {
    if (_selectedClassMap == null) return null;

    final name = _selectedClassMap!['className']?.toString() ?? '';
    final section = _selectedClassMap!['classSection']?.toString() ?? '';
    return '$name – $section';
  }

  /// classId of the selected class (used as FK on subject doc)
  String? get selectedClassId => _selectedClassMap?['classId']?.toString();

  /// className of the selected class e.g. "ICS"
  String? get selectedClassName => _selectedClassMap?['className']?.toString();

  /// classSection of the selected class e.g. "A"
  String? get selectedClassSection => _selectedClassMap?['classSection']?.toString();

  void setSelectedClassMap(Map<String, dynamic>? classMap) {
    _selectedClassMap = classMap;
    notifyListeners();
  }

  // ── Subject CRUD ──────────────────────────────

  Future<bool> addSubject(Map<String, dynamic> subjectData) async {
    return await _repository.addSubject(subjectData);
  }

  Future<bool> updateSubject(Map<String, dynamic> subjectData) async {
    return await _repository.updateSubject(subjectData);
  }

  Future<bool> deleteSubject(String id) async {
    return await _repository.deleteSubject(id);
  }

  // ── Streams ───────────────────────────────────

  Stream<List<Map<String, dynamic>>> get subjectsStream => _repository.watchSubjectsStream();

  Stream<List<Map<String, dynamic>>> get teacherStream => _repository.watchTeachersStream();

  /// Returns full class documents including classId, className, classSection.
  Stream<List<Map<String, dynamic>>> get classesStream => _repository.watchClassesStream();
}