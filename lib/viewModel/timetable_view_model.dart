import 'package:flutter/foundation.dart';
import '../model/timetable_model.dart';

/// ViewModel for managing timetable data
/// Currently uses local asset, but structured for easy Firebase integration
class TimetableViewModel extends ChangeNotifier {
  TimetableModel? _timetable;
  bool _isLoading = false;
  String? _errorMessage;

  TimetableModel? get timetable => _timetable;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TimetableViewModel() {
    _initializeMockData();
  }

  /// Initialize mock data (current implementation)
  /// This method will be replaced with Firebase fetch when integrating
  void _initializeMockData() {
    _timetable = TimetableModel(
      id: '1',
      localAssetPath: 'svgimage/academic_calendar.png',
      title: 'Academic Time Table 2080',
      academicYear: '2080',
    );
  }

  /// Fetch timetable from data source
  /// Currently uses local asset, but will be replaced with Firebase when integrating
  ///
  /// Future Firebase implementation example:
  /// ```dart
  /// Future<void> fetchTimetable() async {
  ///   try {
  ///     _isLoading = true;
  ///     _errorMessage = null;
  ///     notifyListeners();
  ///
  ///     // Fetch the latest timetable from Firebase
  ///     final snapshot = await FirebaseFirestore.instance
  ///         .collection('timetables')
  ///         .orderBy('lastUpdated', descending: true)
  ///         .limit(1)
  ///         .get();
  ///
  ///     if (snapshot.docs.isNotEmpty) {
  ///       final doc = snapshot.docs.first;
  ///       _timetable = TimetableModel.fromFirestore(doc.data(), doc.id);
  ///     } else {
  ///       // Fallback to local asset if no Firebase data
  ///       _initializeMockData();
  ///     }
  ///
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   } catch (e) {
  ///     _errorMessage = 'Failed to load timetable';
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   }
  /// }
  /// ```
  Future<void> fetchTimetable() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Currently using local asset
      _initializeMockData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching timetable: $e');
      }
      _errorMessage = 'Failed to load timetable';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh timetable data
  Future<void> refresh() async {
    await fetchTimetable();
  }
}
