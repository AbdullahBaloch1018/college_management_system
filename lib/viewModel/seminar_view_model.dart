import 'package:flutter/foundation.dart';
import '../model/activity_model.dart';

/// ViewModel for managing seminar/activity data
/// Currently uses mock data, but structured for easy Firebase integration
class SeminarViewModel extends ChangeNotifier {
  List<ActivityModel> _activities = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ActivityModel> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SeminarViewModel() {
    _initializeMockData();
  }

  /// Initialize mock data (current implementation)
  /// This method will be replaced with Firebase fetch when integrating
  void _initializeMockData() {
    _activities = [
      ActivityModel(
        id: '1',
        title: 'Seminar on Machine Learning',
        description:
            'Learn about the latest trends in machine learning and AI.',
        time: '9:00 AM - 11:00 AM',
        category: 'Seminar',
      ),
      ActivityModel(
        id: '2',
        title: 'Workshop on Mobile App Development',
        description: 'Hands-on workshop on building mobile apps using Flutter.',
        time: '11:30 AM - 1:30 PM',
        category: 'Workshop',
      ),
      ActivityModel(
        id: '3',
        title: 'Panel Discussion on Cybersecurity',
        description: 'Join industry experts for a discussion on cybersecurity.',
        time: '2:00 PM - 4:00 PM',
        category: 'Panel Discussion',
      ),
      ActivityModel(
        id: '4',
        title: 'Cultural Event - Dance Competition',
        description: 'Showcase your dancing talent in this competition.',
        time: '4:30 PM - 6:30 PM',
        category: 'Cultural Event',
      ),
      ActivityModel(
        id: '5',
        title: 'Guest Lecture on Entrepreneurship',
        description:
            'Learn from successful entrepreneurs about startup strategies.',
        time: '7:00 PM - 9:00 PM',
        category: 'Guest Lecture',
      ),
    ];
  }

  /// Fetch activities from data source
  /// Currently uses mock data, but will be replaced with Firebase when integrating
  ///
  /// Future Firebase implementation example:
  /// ```dart
  /// Future<void> fetchActivities() async {
  ///   try {
  ///     _isLoading = true;
  ///     _errorMessage = null;
  ///     notifyListeners();
  ///
  ///     final snapshot = await FirebaseFirestore.instance
  ///         .collection('activities')
  ///         .orderBy('date', descending: false)
  ///         .get();
  ///
  ///     _activities = snapshot.docs
  ///         .map((doc) => ActivityModel.fromFirestore(doc.data(), doc.id))
  ///         .toList();
  ///
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   } catch (e) {
  ///     _errorMessage = 'Failed to load activities';
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   }
  /// }
  /// ```
  Future<void> fetchActivities() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Currently using mock data
      _initializeMockData();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching activities: $e');
      }
      _errorMessage = 'Failed to load activities';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh activities list
  Future<void> refresh() async {
    await fetchActivities();
  }
}
