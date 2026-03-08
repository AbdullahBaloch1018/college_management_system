import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../model/teacher_panel_model/student_model.dart';
class AttendanceByTeacherRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Real-time stream of students by classId
  Stream<List<StudentModel>> streamStudentsByClass(String classId) {
    return _firestore
        .collection('students')
        .where('classId', isEqualTo: classId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => StudentModel.fromJson(doc.data(), doc.id))
        .toList());
  }

  /// Real-time stream of existing attendance for a session
  /// Emits a map of { studentId: attendanceStatus }
  Stream<Map<String, String>> streamExistingAttendance(String attendanceDocId) {
    return _firestore
        .collection('attendance')
        .doc(attendanceDocId)
        .collection('students')
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return {};
      return {
        for (var doc in snapshot.docs)
          doc.id: doc.data()['status'] ?? 'Present'
      };
    });
  }

  /// Save attendance session + each student's status using batch write
  Future<void> saveAttendance({
    required String attendanceDocId,
    required String classId,
    required String subject,
    required DateTime date,
    required List<StudentModel> students,
  }) async {
    final batch = _firestore.batch();
    final dateStr = date.toIso8601String().split('T').first;

    final sessionRef = _firestore
        .collection('attendance')
        .doc(attendanceDocId);

    batch.set(sessionRef, {
      'classId': classId,
      'subject': subject,
      'date': Timestamp.fromDate(date),
      'dateStr': dateStr,
      'totalStudents': students.length,
      'presentCount': students
          .where((s) => s.attendanceStatus == 'Present')
          .length,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    for (var student in students) {
      final studentRef = sessionRef
          .collection('students')
          .doc(student.id);
      batch.set(studentRef, student.toJson());
    }

    await batch.commit();
  }


  /// Classes Stream


  Stream<List<Map<String, dynamic>>> watchClasses(){

    return _firestore.collection("classes").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['classId'] = doc.id;
        return data;
      },).toList();
    },);
  }



}