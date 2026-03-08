import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for Classes - used by both Admin and Teacher panels.
/// Real-time sync: Admin adds class → Firestore updates → snapshots() emits → Teacher sees changes.
class ClassRepository {
  final FirebaseFirestore _firestore;
  static const String _collection = 'classes';

  ClassRepository({FirebaseFirestore? firestore}) : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _classRef => _firestore.collection(_collection);

  /// CREATE CLASS (Admin adds → Firestore → snapshots() notifies Teacher)
  /*Future<void> createClass({required String className,required String classSection, String? totalStudents,String? assignedTeacher,}) async {
    final doc = _classRef.doc();
    await doc.set({
      'classId': doc.id,
      'className': className,
      'classSection': classSection,
      'totalStudents': totalStudents ?? '10',
      'assignedTeacher': assignedTeacher ?? '10',
      'createdAt': FieldValue.serverTimestamp(),

    });
  }*/
  Future<void> createClass(Map<String, dynamic> classData) async {
    try {
      await _classRef.doc(classData['classId']).set(classData);
    } catch (e) {
      rethrow;
    }
  }

  /// READ ALL CLASSES
  /// Stream of all classes - emits whenever Admin adds/updates/deletes a class.

  Stream<QuerySnapshot> watchClassesStream() {
    return _classRef.orderBy('createdAt', descending: true).snapshots(); // Real-time listener
  }

  /// UPDATE CLASS
  /*Future<void> updateClass({
    required String classId,
    required String classSection,
    String? assignedTeacher,
    String? totalStudents,

  }) async {
    await _classRef.doc(classId).update({
      'classSection': classSection,
      'assignedTeacher': assignedTeacher ?? "10", //statics values
      'totalStudents': totalStudents ?? "10",
      'updatedAt': FieldValue.serverTimestamp(),

    });
  }*/

  Future<void> updateClass(Map<String, dynamic> classData) async {
    final classId = classData['classId'];
    await _classRef.doc(classId).update(classData);
  }

  /// DELETE CLASS
  Future<void> deleteClass(String docId) async {
    await _classRef.doc(docId).delete();
  }

  Stream<List<Map<String, dynamic>>> watchTeachersStream() {
    return _firestore.collection('users_database')
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
}
