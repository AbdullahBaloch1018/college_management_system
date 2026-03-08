// viewmodels/result_viewmodel.dart
import 'package:flutter/foundation.dart';

import '../../../model/teacher_panel_model/result_model.dart';

class ResultViewModel extends ChangeNotifier {

  List<ResultModel> _results = [];
  String _selectedClass = '';
  String _selectedSubject = '';
  bool _isLoading = false;

  List<ResultModel> get results => _results;
  String get selectedClass => _selectedClass;
  String get selectedSubject => _selectedSubject;
  bool get isLoading => _isLoading;

  void setSelectedClass(String classId) {
    _selectedClass = classId;
    notifyListeners();
    loadResults();
  }

  void setSelectedSubject(String subjectId) {
    _selectedSubject = subjectId;
    notifyListeners();
  }

  Future<void> loadResults() async {
    if (_selectedClass.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(Duration(milliseconds: 500));
      _results = [
        ResultModel(studentId: '1', studentName: 'Ali Ahmed', rollNo: '001'),
        ResultModel(studentId: '2', studentName: 'Fatima Khan', rollNo: '002'),
        ResultModel(studentId: '3', studentName: 'Hassan Raza', rollNo: '003'),
        ResultModel(studentId: '4', studentName: 'Ayesha Malik', rollNo: '004'),
      ];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateMarks(String studentId, double marks) {
    final index = _results.indexWhere((r) => r.studentId == studentId);
    if (index != -1) {
      _results[index].marks = marks;
      _results[index].calculateGrade();
      notifyListeners();
    }
  }

  // Firebase method - Generate and save report cards as PDF
  Future<bool> generateReportCards() async {
    try {
      // TODO: Implement PDF generation using pdf package
      // Example:
      // final pdf = pdf.Document();
      // for (var result in _results) {
      //   pdf.addPage(_buildReportCardPage(result));
      // }
      // final bytes = await pdf.save();
      // await _uploadPDFToFirebase(bytes, result.studentId);
      
      // Dummy implementation for now
      await Future.delayed(const Duration(seconds: 1));
      
      // TODO: Save to Firebase Storage
      // await FirebaseStorage.instance
      //     .ref('report_cards/${_selectedClass}/${_selectedSubject}/${DateTime.now().millisecondsSinceEpoch}.pdf')
      //     .putData(bytes);
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Firebase method - Save results to Firestore
  Future<bool> saveResults() async {
    try {
      // TODO: Implement Firebase save
      // final batch = FirebaseFirestore.instance.batch();
      // for (var result in _results) {
      //   final docRef = FirebaseFirestore.instance
      //       .collection('results')
      //       .doc('${_selectedClass}_${_selectedSubject}_${result.studentId}');
      //   batch.set(docRef, {
      //     'studentId': result.studentId,
      //     'classId': _selectedClass,
      //     'subjectId': _selectedSubject,
      //     'marks': result.marks,
      //     'grade': result.grade,
      //     'updatedAt': FieldValue.serverTimestamp(),
      //   });
      // }
      // await batch.commit();
      
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Firebase method - Publish results
  Future<bool> publishResults() async {
    try {
      // TODO: Implement Firebase publish
      // await FirebaseFirestore.instance
      //     .collection('results')
      //     .where('classId', isEqualTo: _selectedClass)
      //     .where('subjectId', isEqualTo: _selectedSubject)
      //     .get()
      //     .then((snapshot) {
      //   final batch = FirebaseFirestore.instance.batch();
      //   for (var doc in snapshot.docs) {
      //     batch.update(doc.reference, {
      //       'published': true,
      //       'publishedAt': FieldValue.serverTimestamp(),
      //     });
      //   }
      //   return batch.commit();
      // });
      
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }
}
