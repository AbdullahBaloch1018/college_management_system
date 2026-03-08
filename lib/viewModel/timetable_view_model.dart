import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../model/timetable_model.dart';

/// ViewModel for timetable data - fetches from Firebase so admin/teacher uploads appear for students
class TimetableViewModel extends ChangeNotifier {
  TimetableModel? _timetable;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  TimetableModel? get timetable => _timetable;
  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;

  void _initializeMockData() {
    _timetable = TimetableModel(
      id: 'fallback',
      localAssetPath: 'svgimage/academic_calendar.png',
      title: 'Academic Time Table 2080',
      academicYear: '2080',
    );
  }

  Future<void> fetchTimetable() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('timetable_images')
          .orderBy('lastUpdated', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first;
        final data = doc.data();
        final imageUrl = data['imageUrl'] as String?;
        if (imageUrl != null && imageUrl.isNotEmpty) {
          _timetable = TimetableModel(
            id: doc.id,
            imageUrl: imageUrl,
            title: data['title'] as String?,
            academicYear: data['academicYear'] as String?,
            uploadedBy: data['uploadedBy'] as String?,
          );
        } else {
          _initializeMockData();
        }
      } else {
        _initializeMockData();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching timetable: $e');
      }
      _errorMessage = 'Failed to load timetable';
      _initializeMockData();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh timetable data
  Future<void> refresh() async {
    await fetchTimetable();
  }

  Future<bool> uploadTimetable({
    required String title,
    required String academicYear,
    required File imageFile,
  }) async {
    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      final fileName = 'timetables/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split(Platform.pathSeparator).last}';
      final ref = _storage.ref(fileName);
      await ref.putFile(imageFile);
      final imageUrl = await ref.getDownloadURL();

      await _firestore.collection('timetable_images').add({
        'title': title,
        'academicYear': academicYear,
        'imageUrl': imageUrl,
        'uploadedBy': userId,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      _timetable = TimetableModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imageUrl: imageUrl,
        title: title,
        academicYear: academicYear,
        lastUpdated: DateTime.now(),
        uploadedBy: userId,
      );

      _isUploading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to upload timetable: $e';
      _isUploading = false;
      notifyListeners();
      return false;
    }
  }
}
