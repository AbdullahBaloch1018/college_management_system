// viewmodels/plagiarism_viewmodel.dart
import 'dart:io';

import 'package:flutter/foundation.dart';

class PlagiarismViewModel extends ChangeNotifier {
  File? _selectedFile;
  bool _isChecking = false;
  double _similarityScore = 0;
  List<String> _matchedSources = [];

  File? get selectedFile => _selectedFile;
  bool get isChecking => _isChecking;
  double get similarityScore => _similarityScore;
  List<String> get matchedSources => _matchedSources;

  void setFile(File file) {
    _selectedFile = file;
    notifyListeners();
  }

  Future<bool> checkPlagiarism() async {
    if (_selectedFile == null) return false;

    _isChecking = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(seconds: 2));
      _similarityScore = 15.5;
      _matchedSources = [
        'Wikipedia - Programming Concepts',
        'GeeksforGeeks - Data Structures',
      ];
      _isChecking = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isChecking = false;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    _selectedFile = null;
    _similarityScore = 0;
    _matchedSources = [];
    notifyListeners();
  }
}
