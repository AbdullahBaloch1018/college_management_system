import 'package:flutter/foundation.dart';
import '../model/chart_data_model.dart';

/// ViewModel for managing student marks chart data
/// Currently uses mock data, but structured for easy Firebase integration
class ChartViewModel extends ChangeNotifier {
  List<ChartDataModel> _chartData = [];
  bool _isLoading = false;
  String? _errorMessage;
  double _averageMarks = 0.0;
  double _highestMarks = 0.0;
  double _lowestMarks = 0.0;
  double _totalProgress = 0.0;

  List<ChartDataModel> get chartData => _chartData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  double get averageMarks => _averageMarks;
  double get highestMarks => _highestMarks;
  double get lowestMarks => _lowestMarks;
  double get totalProgress => _totalProgress;

  ChartViewModel() {
    _initializeMockData();
  }

  /// Initialize mock data (current implementation)
  /// This method will be replaced with Firebase fetch when integrating
  void _initializeMockData() {
    // Multiple data sets for variety
    final List<List<ChartDataModel>> dataOptions = [
      [
        ChartDataModel(id: '1', semester: 'Sem 1', marks: 70),
        ChartDataModel(id: '2', semester: 'Sem 2', marks: 75),
        ChartDataModel(id: '3', semester: 'Sem 3', marks: 80),
        ChartDataModel(id: '4', semester: 'Sem 4', marks: 85),
        ChartDataModel(id: '5', semester: 'Sem 5', marks: 90),
        ChartDataModel(id: '6', semester: 'Sem 6', marks: 95),
        ChartDataModel(id: '7', semester: 'Sem 7', marks: 92),
      ],
      [
        ChartDataModel(id: '1', semester: 'Sem 1', marks: 65),
        ChartDataModel(id: '2', semester: 'Sem 2', marks: 68),
        ChartDataModel(id: '3', semester: 'Sem 3', marks: 72),
        ChartDataModel(id: '4', semester: 'Sem 4', marks: 80),
        ChartDataModel(id: '5', semester: 'Sem 5', marks: 85),
        ChartDataModel(id: '6', semester: 'Sem 6', marks: 90),
        ChartDataModel(id: '7', semester: 'Sem 7', marks: 92),
      ],
      [
        ChartDataModel(id: '1', semester: 'Sem 1', marks: 72),
        ChartDataModel(id: '2', semester: 'Sem 2', marks: 78),
        ChartDataModel(id: '3', semester: 'Sem 3', marks: 82),
        ChartDataModel(id: '4', semester: 'Sem 4', marks: 88),
        ChartDataModel(id: '5', semester: 'Sem 5', marks: 91),
        ChartDataModel(id: '6', semester: 'Sem 6', marks: 94),
        ChartDataModel(id: '7', semester: 'Sem 7', marks: 96),
      ],
    ];

    // Select first dataset by default (can be randomized if needed)
    _chartData = dataOptions[0];
    _calculateStats();
  }

  /// Calculate statistics from chart data
  void _calculateStats() {
    if (_chartData.isEmpty) {
      _averageMarks = 0.0;
      _highestMarks = 0.0;
      _lowestMarks = 0.0;
      _totalProgress = 0.0;
      return;
    }

    _highestMarks = _chartData
        .map((e) => e.marks)
        .reduce((a, b) => a > b ? a : b);
    _lowestMarks = _chartData
        .map((e) => e.marks)
        .reduce((a, b) => a < b ? a : b);
    _averageMarks =
        _chartData.map((e) => e.marks).reduce((a, b) => a + b) /
        _chartData.length;

    // Calculate progress (improvement from first to last semester)
    if (_chartData.length > 1) {
      final firstSemester = _chartData.first.marks;
      final lastSemester = _chartData.last.marks;
      _totalProgress = ((lastSemester - firstSemester) / firstSemester) * 100;
    }
  }

  /// Fetch chart data from data source
  /// Currently uses mock data, but will be replaced with Firebase when integrating
  ///
  /// Future Firebase implementation example:
  /// ```dart
  /// Future<void> fetchChartData() async {
  ///   try {
  ///     _isLoading = true;
  ///     _errorMessage = null;
  ///     notifyListeners();
  ///
  ///     final currentUser = FirebaseAuth.instance.currentUser;
  ///     if (currentUser != null) {
  ///       final snapshot = await FirebaseFirestore.instance
  ///           .collection('students')
  ///           .doc(currentUser.uid)
  ///           .collection('semester_marks')
  ///           .orderBy('semester', descending: false)
  ///           .get();
  ///
  ///       _chartData = snapshot.docs
  ///           .map((doc) => ChartDataModel.fromFirestore(doc.data(), doc.id))
  ///           .toList();
  ///
  ///       _calculateStats();
  ///     }
  ///
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   } catch (e) {
  ///     _errorMessage = 'Failed to load chart data';
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   }
  /// }
  /// ```
  Future<void> fetchChartData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));

      // Currently using mock data
      _initializeMockData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching chart data: $e');
      }
      _errorMessage = 'Failed to load chart data';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh chart data
  Future<void> refresh() async {
    await fetchChartData();
  }
}
