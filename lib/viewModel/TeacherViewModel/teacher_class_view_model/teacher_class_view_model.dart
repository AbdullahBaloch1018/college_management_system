// lib/viewModel/TeacherViewModel/teacher_class_view_model.dart
/// Claude
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../Services/admin_panel_Services/class_repository.dart';

/// Fetches classes in real-time for Teacher panel.
/// Admin adds/updates/deletes a class → Firestore → snapshot emits → Teacher sees it instantly.
class TeacherClassViewModel extends ChangeNotifier {
  final ClassRepository _repository = ClassRepository();

  bool _isLoading = true;
  List<Map<String, dynamic>> _classes = [];
  StreamSubscription<QuerySnapshot>? _sub; // real-time subscription

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get classes => _classes;

  TeacherClassViewModel() {
    _listenToClasses(); // Start listening as soon as ViewModel is created
  }

  /// Listen to classes collection — emits whenever Admin changes anything
  void _listenToClasses() {
    _sub?.cancel();
    _sub = _repository.watchClassesStream().listen((snapshot) {
      // Map each Firestore doc to a simple map
      _classes = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': data['className'] ?? '',
          'section': data['section'] ?? '',
          // studentUids array from Firebase structure
          'studentUids': List<String>.from(data['studentUids'] ?? []),
        };
      }).toList();

      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      debugPrint("TeacherClassViewModel error: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel(); // Always cancel stream to avoid memory leaks
    super.dispose();
  }
}