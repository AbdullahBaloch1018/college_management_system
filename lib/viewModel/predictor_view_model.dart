import 'package:flutter/foundation.dart';

class PredictorViewModel with ChangeNotifier {
  bool _isPredicting = false;
  String _remark = '';

  bool get isPredicting => _isPredicting;
  String get remark => _remark;

  void clearRemark() {
    _remark = '';
    notifyListeners();
  }

  Future<void> predict({
    required double attendanceScore,
    required double assignmentScore,
    required double assessmentScore,
  }) async {
    _isPredicting = true;
    _remark = '';
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Mock API delay

    try {
      // Future Firebase or API logic here
      // For now, we’ll show mock prediction
      if (attendanceScore + assignmentScore + assessmentScore > 250) {
        _remark = "Excellent! You are performing above expectations.";
      } else if (attendanceScore + assignmentScore + assessmentScore > 180) {
        _remark = "Good Job! Keep improving for better results.";
      } else {
        _remark = "You need to work harder to improve your performance.";
      }
    } catch (e) {
      _remark = 'Error: $e';
    } finally {
      _isPredicting = false;
      notifyListeners();
    }
  }
}
