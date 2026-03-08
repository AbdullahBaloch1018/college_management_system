import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../Services/admin_panel_Services/class_repository.dart';

class ClassManagementByAdminViewModel extends ChangeNotifier {
  final ClassRepository _repository = ClassRepository();

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoadingState(bool value){
    _isLoading = value;
    notifyListeners();
  }
  /// DELETE CLASS
  Future<void> deleteClass(String docId) async {
    try {
      await _repository.deleteClass(docId);
    } catch (e) {
      debugPrint("Error deleting class: $e");
      rethrow;
    }
  }

  /// UPDATE CLASS SECTION
  Future<void> updateClass(Map<String, dynamic> classData) async {
    try {
      await _repository.updateClass(classData);
    } catch (e) {
      debugPrint("Error updating class: $e");
      rethrow;
    }
  }
}
