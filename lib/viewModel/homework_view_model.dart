import 'package:flutter/foundation.dart';
import 'package:rise_college/model/homework_data_model.dart';

class HomeworkViewModel with ChangeNotifier {
  // Mock/Dummy homework data
  final Map<String, List<HomeworkDataModel>> _homeworkData = {};
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Getter
  Map<String, List<HomeworkDataModel>> get homeworkData => _homeworkData;

  HomeworkViewModel() {
    _initializeMockData();
  }


  void _initializeMockData() {
    final now = DateTime.now();

    _homeworkData['Telecommunication'] = [
      HomeworkDataModel(
        title: 'Network Protocols Assignment',
        description:
            'Complete the assignment on TCP/IP protocols and submit your analysis.',
        dueDate: now.add(const Duration(days: 5)),
        subject: 'Telecommunication',
      ),
      HomeworkDataModel(
        title: 'Wireless Communication Report',
        description:
            'Write a comprehensive report on 5G technology and its applications.',
        dueDate: now.add(const Duration(days: 10)),
        subject: 'Telecommunication',
      ),
    ];

    _homeworkData['Information System'] = [
      HomeworkDataModel(
        title: 'Database Design Project',
        description:
            'Design and implement a database schema for a library management system.',
        dueDate: now.add(const Duration(days: 7)),
        subject: 'Information System',
      ),
    ];

    _homeworkData['Big Data'] = [
      HomeworkDataModel(
        title: 'Hadoop Cluster Setup',
        description:
            'Set up a OOP cluster and process sample data using MapReduce.',
        dueDate: now.add(const Duration(days: 12)),
        subject: 'Big Data',
      ),
      HomeworkDataModel(
        title: 'Data Analytics Case Study',
        description: 'Analyze a real-world dataset and present your findings.',
        dueDate: now.add(const Duration(days: 14)),
        subject: 'Big Data',
      ),
    ];

    _homeworkData['Multimedia'] = [
      HomeworkDataModel(
        title: 'Video Editing Project',
        description:
            'Create a 5-minute promotional video using Adobe Premiere Pro.',
        dueDate: now.add(const Duration(days: 8)),
        subject: 'Multimedia',
      ),
    ];

    _homeworkData['EPP'] = [
      HomeworkDataModel(
        title: 'Engineering Ethics Essay',
        description:
            'Write an essay on professional ethics in engineering practice.',
        dueDate: now.add(const Duration(days: 6)),
        subject: 'EPP',
      ),
      HomeworkDataModel(
        title: 'Project Management Plan',
        description:
            'Develop a comprehensive project management plan for a software project.',
        dueDate: now.add(const Duration(days: 15)),
        subject: 'EPP',
      ),
    ];

    _homeworkData['Computer Science'] = [
      HomeworkDataModel(
        title: 'Algorithm Analysis',
        description:
            'Analyze the time complexity of sorting algorithms and compare their performance.',
        dueDate: now.add(const Duration(days: 9)),
        subject: 'Computer Science',
      ),
      HomeworkDataModel(
        title: 'Machine Learning Project',
        description:
            'Implement a classification model using supervised learning techniques.',
        dueDate: now.add(const Duration(days: 11)),
        subject: 'Computer Science',
      ),
    ];
  }

  // Fetch homework for a specific subject (now just returns mock data)
  Future<void> fetchHomework(String subject) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_homeworkData.containsKey(subject)) {
      _homeworkData[subject] = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Clear data if needed
  void clearHomework() {
    _homeworkData.clear();
    _initializeMockData();
    notifyListeners();
  }
}
