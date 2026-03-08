/*
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for Subjects - shared between Admin and Teacher panels.
class SubjectRepository {
  final FirebaseFirestore _firestore;

  SubjectRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('subjects_database');

  // Real-time stream of subjects (now List<Map>)
  Stream<List<Map<String, dynamic>>> watchSubjectsStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['subjectId'] = doc.id; // always store id in the map
        return data;
      }).toList();
    });
  }

  // Teachers stream (unchanged)
  Stream<List<Map<String, dynamic>>> watchTeachersStream() {
    return _firestore
        .collection('users_database')
        .where('role', isEqualTo: 'Teacher')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList();
    });
  }

  // Classes stream (unchanged)
  Stream<List<Map<String, dynamic>>> watchClassesStream() {
    return _firestore.collection('classes').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['classId'] = doc.id;
        return data;
      }).toList();
    });
  }

  // One-time fetch (now returns List<Map>)
  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['subjectId'] = doc.id;
      return data;
    }).toList();
  }

  Future<bool> addSubject(Map<String, dynamic> subjectData) async {
    try {
      // Use the id you generated in ViewModel / screen
      await _collection.doc(subjectData['subjectId']).set(subjectData);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateSubject(Map<String, dynamic> subjectData) async {
    try {
      final id = subjectData['subjectId'] as String?;
      if (id == null || id.isEmpty) return false;

      await _collection.doc(id).set(subjectData); // or .update() if you prefer
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteSubject(String subjectId) async {
    try {
      await _collection.doc(subjectId).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}*/
//By Claude
import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for Subjects - shared between Admin and Teacher panels.
///
/// KEY CHANGE for attendance compatibility:
/// Subjects now store 'classId', 'className', AND 'classSection' instead of
/// just 'assignClass' (className string). This lets attendance filter subjects
/// by classId (exact match) rather than a loose className string that would
/// match both ICS-A and ICS-B.
///
/// Firestore document structure (subjects_database):
/// {
///   subjectId        : String  (doc ID, also stored as field)
///   subjectName      : String  e.g. "Mathematics"
///   subjectCode      : String  e.g. "MATH101"
///   classId          : String  e.g. "1718000000000"  ← NEW: FK to classes doc
///   className        : String  e.g. "ICS"            ← NEW: denormalised for display
///   classSection     : String  e.g. "A"              ← NEW: denormalised for display
///   assignClass      : String  e.g. "ICS – A"        ← display label (kept for UI)
///   assignedTeacherId   : String
///   assignedTeacherName : String
///   createdAt        : Timestamp
/// }

class SubjectRepository {
  final FirebaseFirestore _firestore;

  SubjectRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection => _firestore.collection('subjects_database');

  // ── Subjects stream ───────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> watchSubjectsStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['subjectId'] = doc.id;
        return data;
      }).toList();
    });
  }

  // ── Teachers stream ───────────────────────────────────────────────────────

  Stream<List<Map<String, dynamic>>> watchTeachersStream() {
    return _firestore
        .collection('users_database')
        .where('role', isEqualTo: 'Teacher')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return data;
      }).toList();
    });
  }

  // ── Classes stream ────────────────────────────────────────────────────────
  // Returns full class documents so the subject form can store
  // classId + className + classSection together.

  Stream<List<Map<String, dynamic>>> watchClassesStream() {
    return _firestore
        .collection('classes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['classId'] = doc.id; // guarantee classId is always present
        return data;
      }).toList();
    });
  }

  // ── One-time fetch ────────────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> fetchSubjects() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['subjectId'] = doc.id;
      return data;
    }).toList();
  }

  // ── CRUD ──────────────────────────────────────────────────────────────────

  Future<bool> addSubject(Map<String, dynamic> subjectData) async {
    try {
      await _collection.doc(subjectData['subjectId']).set(subjectData);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateSubject(Map<String, dynamic> subjectData) async {
    try {
      final id = subjectData['subjectId'] as String?;
      if (id == null || id.isEmpty) return false;
      await _collection.doc(id).set(subjectData);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteSubject(String subjectId) async {
    try {
      await _collection.doc(subjectId).delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}