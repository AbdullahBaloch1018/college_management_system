import 'dart:async';
import 'package:flutter/material.dart';
import '../../../Services/admin_panel_Services/admin_system_settings_repository.dart';
import '../../../model/admin_panel_model/system_setting_model_by_admin.dart';

class AdminSystemSettingViewModel extends ChangeNotifier {
  final AdminSystemSettingsRepository _repository;

  AdminSystemSettingViewModel({AdminSystemSettingsRepository? repository}) : _repository = repository ?? AdminSystemSettingsRepository();
  SystemSettingModelByAdmin _settings = SystemSettingModelByAdmin.empty();
  SystemSettingModelByAdmin get settings => _settings;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  StreamSubscription? _subscription;
  /// 🔥 Start Listening Real-Time
  void listenToSettings() {
    _isLoading = true;
    notifyListeners();
    _subscription = _repository.getSettingsStream().listen((data) {
      _settings = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> updateSettings(SystemSettingModelByAdmin newSettings) async {
    _isLoading = true;
    notifyListeners();

    final success = await _repository.updateSettings(newSettings);

    _isLoading = false;
    notifyListeners();

    return success;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}