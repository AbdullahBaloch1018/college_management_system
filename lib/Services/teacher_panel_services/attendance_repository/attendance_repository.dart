import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/teacher_panel_model/class_model.dart';
import '../../../model/teacher_panel_model/student_attendance_model.dart';
import '../../../model/teacher_panel_model/subject_model.dart';

class AttendanceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Classes ───────────────────────────────────────────────────────────────

  Stream<List<ClassModel>> getClassesStream() {
    return _firestore
        .collection('classes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      data['classId'] = doc.id;
      return ClassModel.fromMap(data);
    }).toList());
  }

  // ── Subjects ──────────────────────────────────────────────────────────────
  // NOW filters by 'classId' (exact, section-aware) instead of 'assignClass'.
  // This works because CreateSubjectByAdminView now stores classId on every subject.

  Stream<List<SubjectModel>> getSubjectsStream(String classId) {
    return _firestore.collection('subjects_database').where('classId', isEqualTo: classId) // ← exact classId match
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      data['subjectId'] = doc.id;
      return SubjectModel.fromMap(data);
    }).toList());
  }

  // ── Students ──────────────────────────────────────────────────────────────
  // Filters by faculty == className (e.g. "ICS").
  // Students belong to a class by name — section is handled at subject level.

  Stream<List<StudentAttendanceModel>> getStudentsStream(String classDisplayName) {
    return _firestore
        .collection('users_database')
        .where('role', isEqualTo: 'Student')
        .where('status', isEqualTo: 'active')
        .where('faculty', isEqualTo: classDisplayName)
        .orderBy('displayName')
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      data['uid'] = doc.id;
      return StudentAttendanceModel.fromMap(data);
    }).toList());
  }

  // ── Attendance ────────────────────────────────────────────────────────────

  String _attendanceDocId(String classId, String subjectId, DateTime date) {
    final d = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '${classId}_${subjectId}_$d';
  }

  Future<void> saveAttendance({
    required ClassModel selectedClass,
    required SubjectModel selectedSubject,
    required DateTime date,
    required List<StudentAttendanceModel> students,
  }) async {
    final teacherId = _auth.currentUser?.uid ?? '';
    final docId = _attendanceDocId(selectedClass.classId, selectedSubject.subjectId, date);

    final records = students.map((s) => {
      'studentId': s.uid,
      'studentName': s.name,
      'rollNo': s.rollNo,
      'status': s.attendanceStatus,
    }).toList();

    await _firestore.collection('attendance').doc(docId).set({
      'classId': selectedClass.classId,
      'className': selectedClass.className,
      'classSection': selectedClass.classSection,
      'subjectId': selectedSubject.subjectId,
      'subjectName': selectedSubject.subjectName,
      'subjectCode': selectedSubject.subjectCode,
      'date': Timestamp.fromDate(date),
      'teacherId': teacherId,
      'records': records,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, String>> fetchExistingAttendance({
    required String classId,
    required String subjectId,
    required DateTime date,
  }) async {
    final docId = _attendanceDocId(classId, subjectId, date);
    final doc = await _firestore.collection('attendance').doc(docId).get();

    if (!doc.exists) return {};

    final records = List<Map<String, dynamic>>.from(doc.data()?['records'] ?? []);
    return {
      for (final r in records) r['studentId'] as String: r['status'] as String,
    };
  }
}



