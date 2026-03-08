// By Cursor
/*
// viewModels/timetable_viewmodel.dart
import 'package:flutter/cupertino.dart';
import 'package:rise_college/Services/admin_panel_Services/timetable_repository.dart';

import '../../../model/admin_panel_model/time_table_by_admin_model.dart';

class AdminTimetableViewModel extends ChangeNotifier {
  final TimetableRepository _repository;

  AdminTimetableViewModel({TimetableRepository? repository}) : _repository = repository ?? TimetableRepository();

  List<TimetableByAdminModel> _timetable = [];
  bool _isLoading = false;

  List<TimetableByAdminModel> get timetable => _timetable;
  bool get isLoading => _isLoading;

  Future<void> loadTimetable() async {
    _isLoading = true;
    notifyListeners();

    try {
      _timetable = await _repository.fetchTimetable();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTimetableEntry(TimetableByAdminModel entry) async {
    final success = await _repository.addEntry(entry);
    if (success) {
      _timetable.add(entry);
      notifyListeners();
    }
    return success;
  }

  Future<bool> deleteTimetableEntry(String entryId) async {
    final success = await _repository.deleteEntry(entryId);
    if (success) {
      _timetable.removeWhere((t) => t.id == entryId);
      notifyListeners();
    }
    return success;
  }
}

*/
import 'package:flutter/foundation.dart';
import '../../../Services/admin_panel_Services/timetable_repository.dart';
import '../../../model/admin_panel_model/time_table_by_admin_model.dart';

class AdminTimetableViewModel extends ChangeNotifier {
  final TimetableRepository _repository;

  AdminTimetableViewModel({TimetableRepository? repository}) : _repository = repository ?? TimetableRepository();

  List<TimetableByAdminModel> _timetable = [];
  bool _isLoading = false;

  List<TimetableByAdminModel> get timetable => _timetable;
  bool get isLoading => _isLoading;

  Future<void> loadTimetable() async {
    _isLoading = true;
    notifyListeners();

    try {
      _timetable = await _repository.fetchTimetable();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTimetableEntry(TimetableByAdminModel entry) async {
    final success = await _repository.addEntry(entry);
    if (success) {
      _timetable.add(entry);
      notifyListeners();
    }
    return success;
  }

  // 🔴 NEW: UPDATE TIMETABLE ENTRY
  Future<bool> updateTimetableEntry(TimetableByAdminModel entry) async {
    final success = await _repository.addEntry(entry);
    // 👆 same method because Firestore `set()` updates if ID exists

    if (success) {
      final index = _timetable.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _timetable[index] = entry;
        notifyListeners();
      }
    }
    return success;
  }

  Future<bool> deleteTimetableEntry(String entryId) async {
    final success = await _repository.deleteEntry(entryId);
    if (success) {
      _timetable.removeWhere((t) => t.id == entryId);
      notifyListeners();
    }
    return success;
  }
}

