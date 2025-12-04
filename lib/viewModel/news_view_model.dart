import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

/// ViewModel for managing news/announcements data
/// Currently uses API, but structured for easy Firebase integration
class NewsViewModel extends ChangeNotifier {
  List<NewsModel> _news = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<NewsModel> get news => _news;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  NewsViewModel() {
    fetchNews();
  }

  /// Initialize mock data for preview/demo purposes
  /// This will be used when API fails or returns empty data
  void _initializeMockData() {
    final now = DateTime.now();
    _news = [
      NewsModel(
        id: '1',
        title: 'Important: Mid-Term Examination Schedule Released',
        description:
            'The mid-term examination schedule for all courses has been released. Please check the notice board or college website for detailed timings. All students are required to be present 15 minutes before the scheduled time. For any queries, contact the examination department.',
        date: now.subtract(const Duration(days: 2)),
        category: 'Announcement',
        author: 'Examination Department',
        isImportant: true,
      ),
      NewsModel(
        id: '2',
        title: 'Annual College Cultural Festival - Registration Open',
        description:
            'We are excited to announce the Annual College Cultural Festival 2024! Registration is now open for various events including music, dance, drama, and art competitions. Students can register at the student affairs office or through the online portal. Last date for registration is 15 days from today. Don\'t miss this opportunity to showcase your talents!',
        date: now.subtract(const Duration(days: 5)),
        category: 'Event',
        author: 'Student Affairs',
        isImportant: false,
      ),
      NewsModel(
        id: '3',
        title: 'Library Hours Extended During Examination Period',
        description:
            'To support students during the examination period, the library will remain open from 8:00 AM to 10:00 PM starting from next week. Additional study spaces have been arranged. Please maintain silence and follow library rules. Group study rooms are available on first-come-first-serve basis.',
        date: now.subtract(const Duration(days: 1)),
        category: 'Notice',
        author: 'Library Department',
        isImportant: false,
      ),
      NewsModel(
        id: '4',
        title: 'Guest Lecture: "Future of AI in Engineering" by Dr. John Smith',
        description:
            'We are pleased to invite all students to attend a guest lecture on "Future of AI in Engineering" by renowned researcher Dr. John Smith from MIT. The lecture will be held in the main auditorium on Friday at 2:00 PM. This is a great opportunity to learn about cutting-edge research and network with industry experts. Attendance is mandatory for final year students.',
        date: now.add(const Duration(days: 3)),
        category: 'Event',
        author: 'Academic Department',
        isImportant: false,
      ),
      NewsModel(
        id: '5',
        title: 'Fee Payment Deadline Reminder',
        description:
            'This is a reminder that the last date for fee payment for the current semester is approaching. Students who have not yet paid their fees are requested to complete the payment by the end of this month to avoid any late fees or penalties. Payment can be made online through the student portal or at the accounts office.',
        date: now.subtract(const Duration(days: 3)),
        category: 'Notice',
        author: 'Accounts Department',
        isImportant: true,
      ),
      NewsModel(
        id: '6',
        title: 'Workshop on "Career Development and Interview Skills"',
        description:
            'The placement cell is organizing a comprehensive workshop on career development and interview skills. Learn how to prepare for interviews, write effective resumes, and develop professional skills. The workshop will be conducted by industry experts and includes mock interview sessions. Limited seats available, register early!',
        date: now.add(const Duration(days: 7)),
        category: 'Event',
        author: 'Placement Cell',
        isImportant: false,
      ),
    ];
  }

  /// Fetch news from data source
  /// Currently uses API, but will be replaced with Firebase when integrating
  ///
  /// Future Firebase implementation example:
  /// ```dart
  /// Future<void> fetchNews() async {
  ///   try {
  ///     _isLoading = true;
  ///     _errorMessage = null;
  ///     notifyListeners();
  ///
  ///     final snapshot = await FirebaseFirestore.instance
  ///         .collection('news')
  ///         .orderBy('date', descending: true)
  ///         .get();
  ///
  ///     _news = snapshot.docs
  ///         .map((doc) => NewsModel.fromFirestore(doc.data(), doc.id))
  ///         .toList();
  ///
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   } catch (e) {
  ///     _errorMessage = 'Failed to load news';
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   }
  /// }
  /// ```
  Future<void> fetchNews() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await http
          .get(Uri.parse("https://shres58tha.pythonanywhere.com/news"))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData.isEmpty) {
          _initializeMockData();
        } else {
          _news = jsonData
              .asMap()
              .entries
              .map(
                (entry) => NewsModel.fromApiJson(
                  entry.value as Map<String, dynamic>,
                  entry.key.toString(),
                ),
              )
              .toList();
        }
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching news: $e');
        print('Using mock data for preview...');
      }
      // Use mock data when API fails so user can see the UI
      _initializeMockData();
      _errorMessage = null; // Don't show error, just use mock data
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh news list
  Future<void> refresh() async {
    await fetchNews();
  }

  /// Get news for a specific date (for calendar filtering)
  List<NewsModel> getNewsForDate(DateTime date) {
    return _news.where((news) {
      if (news.date == null) return false;
      return news.date!.year == date.year &&
          news.date!.month == date.month &&
          news.date!.day == date.day;
    }).toList();
  }
}
