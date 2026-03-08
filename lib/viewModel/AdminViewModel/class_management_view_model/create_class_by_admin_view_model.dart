import 'package:flutter/material.dart';
import '../../../Services/admin_panel_Services/class_repository.dart';
import '../../../resources/constants.dart';

class CreateClassByAdminViewModel with ChangeNotifier {
  final ClassRepository _repo = ClassRepository();
  List<String> get classOptions => AppConstants.facultyOptions;


  bool _loading = false;
  String? _selectedClass = AppConstants.facultyOptions.first;
  String? _selectedTeacherId;
  String? _selectedTeacherName;

  bool get loading => _loading;

  String? get selectedTeacherId => _selectedTeacherId;
  String? get selectedTeacherName => _selectedTeacherName;
  String? get selectedClass => _selectedClass;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  void setSelectedTeacher(String? uid, String? name) {
    _selectedTeacherId = uid;
    _selectedTeacherName = name;
    notifyListeners();
  }

  void setSelectedClass(String? value) {
    _selectedClass = value;
    notifyListeners();
  }

  /// CREATE CLASS
  // Future<void> createClass({required String name,required String section,}) async {
  Future<void> createClass(Map<String,dynamic> classData) async {
    try {
      setLoading(true);
      await _repo.createClass(classData);
      setLoading(false);
    }
    catch(e){
      setLoading(false);
      rethrow;
    }
  }
  Stream<List<Map<String, dynamic>>> get teacherStream => _repo.watchTeachersStream();
}
