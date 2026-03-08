// viewmodels/assignment_viewmodel.dart
import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _assignments = [];
  bool _isLoading = false;
  bool _isCreating = false;
  String _errorMessage = '';

  List<Map<String, dynamic>> get assignments => _assignments;
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  String get errorMessage => _errorMessage;

  // Firebase method - Load assignments
  Future<void> loadAssignments() async {
    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Replace with actual Firebase call
      // final snapshot = await FirebaseFirestore.instance
      //     .collection('assignments')
      //     .where('teacherId', isEqualTo: currentUserId)
      //     .orderBy('dueDate', descending: false)
      //     .get();
      // _assignments = snapshot.docs.map((doc) => {
      //   final data = doc.data();
      //   return {
      //     'id': doc.id,
      //     ...data,
      //   };
      // }).toList();
      
      // Dummy data for now
      await Future.delayed(const Duration(seconds: 1));
      
      _assignments = [
        {
          'id': '1',
          'title': 'Database Design Assignment',
          'subject': 'Database Systems',
          'className': 'BS-CS 2A',
          'dueDate': DateTime.now().add(const Duration(days: 5)),
          'status': 'Active',
          'totalStudents': 30,
          'totalSubmissions': 25,
          'gradedCount': 20,
          'submissions': [
            {
              'studentName': 'Ali Ahmed',
              'rollNo': '001',
              'submittedDate': DateTime.now().subtract(const Duration(days: 2)),
              'fileUrl': 'https://example.com/file1.pdf',
              'status': 'Graded',
            },
            {
              'studentName': 'Fatima Khan',
              'rollNo': '002',
              'submittedDate': DateTime.now().subtract(const Duration(days: 1)),
              'fileUrl': 'https://example.com/file2.pdf',
              'status': 'Pending',
            },
            {
              'studentName': 'Hassan Raza',
              'rollNo': '003',
              'submittedDate': DateTime.now().subtract(const Duration(hours: 5)),
              'fileUrl': 'https://example.com/file3.pdf',
              'status': 'Graded',
            },
          ],
        },
        {
          'id': '2',
          'title': 'OOP Project',
          'subject': 'Object Oriented Programming',
          'className': 'BS-CS 1B',
          'dueDate': DateTime.now().add(const Duration(days: 10)),
          'status': 'Active',
          'totalStudents': 28,
          'totalSubmissions': 15,
          'gradedCount': 10,
          'submissions': [
            {
              'studentName': 'Ayesha Malik',
              'rollNo': '004',
              'submittedDate': DateTime.now().subtract(const Duration(days: 3)),
              'fileUrl': 'https://example.com/file4.pdf',
              'status': 'Graded',
            },
            {
              'studentName': 'Ahmed Ali',
              'rollNo': '005',
              'submittedDate': DateTime.now().subtract(const Duration(days: 1)),
              'fileUrl': 'https://example.com/file5.pdf',
              'status': 'Pending',
            },
          ],
        },
      ];
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Firebase method - Download submission file
  Future<void> downloadSubmission(String fileUrl) async {
    // TODO: Implement file download from Firebase Storage
  }

  // Firebase method - Grade submission
  Future<bool> gradeSubmission(String submissionId, double marks, String feedback) async {
    // TODO: Implement grading in Firestore
    // await FirebaseFirestore.instance
    //     .collection('submissions')
    //     .doc(submissionId)
    //     .update({
    //       'marks': marks,
    //       'feedback': feedback,
    //       'gradedAt': FieldValue.serverTimestamp(),
    //       'status': 'Graded',
    //     });
    return true;
  }

  // Firebase method - Create new assignment
  Future<bool> createAssignment({
    required String title,
    required String description,
    required String classId,
    required String subjectId,
    required double totalMarks,
    required DateTime dueDate,
    String? filePath,
  }) async {
    _isCreating = true;
    notifyListeners();

    try {
      // TODO: Implement Firebase create
      // 1. Upload file to Firebase Storage if filePath is provided
      // String? fileUrl;
      // if (filePath != null) {
      //   final file = File(filePath);
      //   final ref = FirebaseStorage.instance
      //       .ref('assignments/${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}');
      //   await ref.putFile(file);
      //   fileUrl = await ref.getDownloadURL();
      // }
      
      // 2. Save assignment to Firestore
      // await FirebaseFirestore.instance.collection('assignments').add({
      //   'title': title,
      //   'description': description,
      //   'classId': classId,
      //   'subjectId': subjectId,
      //   'totalMarks': totalMarks,
      //   'dueDate': Timestamp.fromDate(dueDate),
      //   'fileUrl': fileUrl,
      //   'teacherId': currentUserId,
      //   'createdAt': FieldValue.serverTimestamp(),
      //   'status': 'Active',
      //   'totalSubmissions': 0,
      //   'gradedCount': 0,
      // });

      // Dummy implementation
      await Future.delayed(const Duration(seconds: 1));
      
      _isCreating = false;
      notifyListeners();
      await loadAssignments(); // Refresh list
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> refresh() async {
    await loadAssignments();
  }
}

