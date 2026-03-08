/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class TeacherDashboardRepository {
  final FirebaseFirestore _firestore;

  TeacherDashboardRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Teacher profile (real-time)
  Stream<Map<String, dynamic>?> watchTeacherProfile(String teacherId) {
    return _firestore
        .collection('users_database')
        .doc(teacherId)
        .snapshots()
        .map((snap) {
      if (!snap.exists) return null;
      final data = snap.data() ?? {};
      data['uid'] = snap.id;
      return data;
    });
  }

  // Assigned classes count / list (real-time)
  // ──────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> watchAssignedClasses(String teacherName) {
    return _firestore.collection('classes').snapshots().map((snap) {
      return snap.docs
          .map((doc) {
        final data = doc.data();
        data['classId'] = doc.id;

        final assigned = (data['assignedTeacher'] ?? data['assignedTeacherName'] ?? '').toString();
        if (!assigned.contains(teacherName) && assigned != teacherName) return null;
        return data;
      })
          .whereType<Map<String, dynamic>>()
          .toList();
    });
  }


  // Assigned subjects count / list (real-time)
  Stream<List<Map<String, dynamic>>> watchAssignedSubjects(String teacherName) {
    return _firestore.collection('subjects_database').snapshots().map((snap) {
      return snap.docs
          .map((doc) {
        final data = doc.data();
        data['subjectId'] = doc.id;

        final assigned = (data['assignedTeacherName'] ?? '').toString();
        if (!assigned.contains(teacherName) && assigned != teacherName) return null;
        return data;
      }).whereType<Map<String, dynamic>>().toList();
    });
  }

  // Today's timetable entries (real-time)
  Stream<List<Map<String, dynamic>>> watchTodayTimetable(String teacherName, String day) {
    return _firestore
        .collection('timetable')
        .where('day', isEqualTo: day)
        .snapshots()
        .map((snap) {
      return snap.docs
          .map((doc) {
        final data = doc.data();
        data['id'] = doc.id;

        final t = (data['teacherId'] ?? data['assignedTeacherId'] ?? data['teacher'] ?? '').toString();
        if (!t.contains(teacherName) && t != teacherName) return null;
        return data;
      })
          .whereType<Map<String, dynamic>>()
          .toList();
    });
  }

  // Combined dashboard data stream (recommended pattern)

  Stream<Map<String, dynamic>> watchDashboardData(String teacherId, String teacherName, String today) {
    return CombineLatestStream.combine4(
      watchTeacherProfile(teacherId),
      watchAssignedClasses(teacherName),
      watchAssignedSubjects(teacherName),
      watchTodayTimetable(teacherName, today),
          (
          Map<String, dynamic>? profile,
          List<Map<String, dynamic>> classes,
          List<Map<String, dynamic>> subjects,
          List<Map<String, dynamic>> timetable,
          ) =>
      {
        'profile': profile,
        'totalClasses': classes.length,
        'totalSubjects': subjects.length,
        'todaySchedule': timetable.map((e) {
          return {
            'subject': e['subjectId'] ?? e['subject'] ?? 'Unknown',
            'class': e['classId'] ?? e['class'] ?? 'N/A',
            'room': e['room'] ?? 'N/A',
            'time': e['timeSlot'] ?? e['time'] ?? '--',
          };
        }).toList(),
      },
    );
  }

  // Placeholder / future real queries
  Future<int?> getTotalStudentsCount() async {
    try {
      final snap = await _firestore
          .collection('users_database')
          .where('role', isEqualTo: 'Student')
          .count()
          .get();
      return snap.count;
    } catch (_) {
      return 0;
    }
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class TeacherDashboardRepository {
  final FirebaseFirestore _firestore;

  TeacherDashboardRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ── Teacher profile (real-time) ──────────────────────────────────────────
  Stream<Map<String, dynamic>?> watchTeacherProfile(String teacherId) {
    return _firestore
        .collection('users_database')
        .doc(teacherId)
        .snapshots()
        .map((snap) {
      if (!snap.exists) return null;
      final data = snap.data() ?? {};
      data['uid'] = snap.id;
      return data;
    });
  }

  // ── Assigned classes (real-time) ─────────────────────────────────────────
  // FIX: match by teacherId (UID) instead of loose name-contains check
  Stream<List<Map<String, dynamic>>> watchAssignedClasses(String teacherId) {
    return _firestore
        .collection('classes')
        .where('assignedTeacherId', isEqualTo: teacherId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      data['classId'] = doc.id;
      return data;
    }).toList());
  }

  // ── Assigned subjects (real-time) ────────────────────────────────────────
  // FIX: match by teacherId (UID)
  Stream<List<Map<String, dynamic>>> watchAssignedSubjects(String teacherId) {
    return _firestore
        .collection('subjects_database')
        .where('assignedTeacherId', isEqualTo: teacherId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      data['subjectId'] = doc.id;
      return data;
    }).toList());
  }

  // ── Today's timetable entries (real-time) ────────────────────────────────
  // FIX: match by teacherId (UID)
  Stream<List<Map<String, dynamic>>> watchTodayTimetable(
      String teacherId, String day) {
    return _firestore
        .collection('timetable')
        .where('day', isEqualTo: day)
        .where('assignedTeacherId', isEqualTo: teacherId)
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList());
  }

  // ── Combined dashboard stream ────────────────────────────────────────────
  // FIX: all three sub-streams now receive teacherId (UID), not name
  Stream<Map<String, dynamic>> watchDashboardData(
      String teacherId, String teacherName, String today) {
    return CombineLatestStream.combine4(
      watchTeacherProfile(teacherId),
      watchAssignedClasses(teacherId),   // ← teacherId, not name
      watchAssignedSubjects(teacherId),  // ← teacherId, not name
      watchTodayTimetable(teacherId, today), // ← teacherId, not name
          (
          Map<String, dynamic>? profile,
          List<Map<String, dynamic>> classes,
          List<Map<String, dynamic>> subjects,
          List<Map<String, dynamic>> timetable,
          ) =>
      {
        'profile': profile,
        'totalClasses': classes.length,
        'totalSubjects': subjects.length,
        'todaySchedule': timetable
            .map((e) => {
          'subject': e['subjectId'] ?? e['subject'] ?? 'Unknown',
          'class': e['classId'] ?? e['class'] ?? 'N/A',
          'room': e['room'] ?? 'N/A',
          'time': e['timeSlot'] ?? e['time'] ?? '--',
        })
            .toList(),
      },
    );
  }

  // ── Total students count ─────────────────────────────────────────────────
  Future<int?> getTotalStudentsCount() async {
    try {
      final snap = await _firestore
          .collection('users_database')
          .where('role', isEqualTo: 'Student')
          .count()
          .get();
      return snap.count;
    } catch (_) {
      return 0;
    }
  }
}
