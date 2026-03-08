import 'package:flutter/foundation.dart';
import 'dart:math';

class AttendanceViewModelOriginal extends ChangeNotifier {
  bool isLoading = false;
  int attendanceCount = 0;
  double attendancePercentage = 0.0;
  Map<DateTime, bool> markedDates = {};

  AttendanceViewModelOriginal() {
    loadLocalAttendance();
  }

  /// Load or generate local attendance data (no Firebase)
  Future<void> loadLocalAttendance() async {
    try {
      isLoading = true;
      notifyListeners();

      // Simulate generating attendance for the current month
      final DateTime now = DateTime.now();
      final DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      final DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

      final Random random = Random(now.day + now.month + now.year);
      markedDates.clear();

      for (int i = 0; i < lastDayOfMonth.day; i++) {
        final day = firstDayOfMonth.add(Duration(days: i));
        // ~75% chance attended
        final bool attended = random.nextDouble() < 0.75;
        markedDates[DateTime(day.year, day.month, day.day)] = attended;
      }

      final int totalDays = markedDates.length;
      attendanceCount = markedDates.values.where((v) => v).length;
      attendancePercentage = totalDays == 0
          ? 0.0
          : (attendanceCount / totalDays) * 100.0;
    } catch (e) {
      if (kDebugMode) {
        print("Error loading local attendance: $e");
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
