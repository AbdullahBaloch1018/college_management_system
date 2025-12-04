import 'package:flutter/foundation.dart';
import '../model/notification_model.dart';

class NotificationViewModel with ChangeNotifier {
  final List<NotificationModel> _notifications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<NotificationModel> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  NotificationViewModel() {
    _initializeMockData();
  }

  void _initializeMockData() {
    final now = DateTime.now();
    _notifications.addAll([
      NotificationModel(
        title: "Assignment Submission Reminder",
        description:
        "Don't forget to submit your Big Data assignment before 5 PM today.",
        date: now.subtract(const Duration(hours: 2)),
        category: "Reminder",
      ),
      NotificationModel(
        title: "Seminar on AI Ethics",
        description:
        "Join the seminar on AI Ethics tomorrow at 11 AM in the Auditorium.",
        date: now.subtract(const Duration(days: 1)),
        category: "Event",
      ),
      NotificationModel(
        title: "Midterm Result Published",
        description:
        "The midterm results for Telecommunication are now available.",
        date: now.subtract(const Duration(days: 2)),
        category: "Announcement",
      ),
    ]);
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    // In future:
    // try {
    //   final data = await FirebaseFirestore.instance.collection('notifications').get();
    //   _notifications = data.docs.map((e) => NotificationModel.fromJson(e.data())).toList();
    // } catch (e) {
    //   _errorMessage = e.toString();
    // }

    _isLoading = false;
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    _initializeMockData();
    notifyListeners();
  }
}
