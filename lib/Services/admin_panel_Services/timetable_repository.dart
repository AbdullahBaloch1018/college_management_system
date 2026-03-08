import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/admin_panel_model/time_table_by_admin_model.dart';

/// Repository for Timetable entries - Admin creates, Teacher sees in real time.
/// Flow: Admin adds timetable → Firestore → snapshots() emits → Teacher's todaySchedule updates.
class TimetableRepository {
  final FirebaseFirestore _firestore;

  TimetableRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('timetables');

  // ========== REAL-TIME: snapshots() ==========
  // Why snapshots(): Firestore emits whenever Admin adds/updates/deletes timetable entries.
  // Teacher panel subscribes; today's schedule updates automatically.
  // Data flow: Admin addEntry() → Firestore → snapshots() emits → Teacher ViewModel → notifyListeners() → Consumer rebuilds.
  Stream<List<TimetableByAdminModel>> watchTimetableStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return TimetableByAdminModel(
          id: data['id'] ?? doc.id,
          classId: data['classId'] ?? '',
          subjectId: data['subjectId'] ?? '',
          teacherId: data['teacherId'] ?? '',
          day: data['day'] ?? '',
          timeSlot: data['timeSlot'] ?? '',
          room: data['room'] ?? '',
        );
      }).toList();
    });
  }

  Future<List<TimetableByAdminModel>> fetchTimetable() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return TimetableByAdminModel(
        id: data['id'] ?? doc.id,
        classId: data['classId'] ?? '',
        subjectId: data['subjectId'] ?? '',
        teacherId: data['teacherId'] ?? '',
        day: data['day'] ?? '',
        timeSlot: data['timeSlot'] ?? '',
        room: data['room'] ?? '',
      );
    }).toList();
  }

  Future<bool> addEntry(TimetableByAdminModel entry) async {
    try {
      await _collection.doc(entry.id).set({
        'id': entry.id,
        'classId': entry.classId,
        'subjectId': entry.subjectId,
        'teacherId': entry.teacherId,
        'day': entry.day,
        'timeSlot': entry.timeSlot,
        'room': entry.room,
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteEntry(String entryId) async {
    try {
      await _collection.doc(entryId).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}

