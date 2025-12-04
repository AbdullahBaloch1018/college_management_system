import 'package:flutter/material.dart';
import 'package:rise_college/resources/app_colors.dart';

class MarksViewModel extends ChangeNotifier {
  bool _loading = false;
  Map<String, dynamic>? _marksData;
  double _percentage = 0.0;

  bool get loading => _loading;
  Map<String, dynamic>? get marksData => _marksData;
  double get percentage => _percentage;

  MarksViewModel() {
    _initializeMockData();
  }

  void _initializeMockData() {
    _marksData = {
      'subjects': {
        'Telecommunication': 85,
        'Information System': 92,
        'Big Data': 78,
        'Multimedia': 88,
        'EPP': 90,
        'Computer Science': 95,
      },
    };

    final subjects = _marksData!['subjects'] as Map<String, dynamic>;

    // ✅ Fix type casting
    int totalObtained = (subjects.values.cast<int>()).reduce((a, b) => a + b);
    int totalMarks = subjects.length * 100;

    _marksData!['total_marks'] = totalObtained;
    _percentage = (totalObtained / totalMarks) * 100;
  }

  /// ✅ Fetch marks data (simulated)
  Future<void> fetchUserMarks() async {
    _loading = true;
    notifyListeners();

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    _initializeMockData();

    _loading = false;
    notifyListeners();
  }

  /// ✅ Helper: Get text result
  String get resultText {
    if (_percentage < 35) return 'You Failed';
    if (_percentage < 50) return 'Barely Passed';
    if (_percentage < 70) return 'Good';
    if (_percentage < 90) return 'Great';
    return 'Excellent Result';
  }

  /// ✅ Helper: Get color result
  Color get resultColor {
    if (_percentage < 35) return AppColors.error;
    if (_percentage < 50) return AppColors.accent;
    if (_percentage < 70) return AppColors.primary;
    if (_percentage < 90) return AppColors.success;
    return AppColors.success;
  }
}
