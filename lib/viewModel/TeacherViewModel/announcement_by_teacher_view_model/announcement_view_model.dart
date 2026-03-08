// viewmodels/announcement_viewmodel.dart
import 'package:flutter/material.dart';

class AnnouncementViewModel extends ChangeNotifier {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final List<String> _selectedClasses = [];
  bool _isSending = false;

  List<String> get selectedClasses => _selectedClasses;
  bool get isSending => _isSending;

  void toggleClass(String classId) {
    if (_selectedClasses.contains(classId)) {
      _selectedClasses.remove(classId);
    } else {
      _selectedClasses.add(classId);
    }
    notifyListeners();
  }

  Future<bool> sendAnnouncement(String teacherId) async {
    if (titleController.text.trim().isEmpty ||
        messageController.text.trim().isEmpty ||
        _selectedClasses.isEmpty) {
      return false;
    }

    _isSending = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 1));
      titleController.clear();
      messageController.clear();
      _selectedClasses.clear();
      _isSending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isSending = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
