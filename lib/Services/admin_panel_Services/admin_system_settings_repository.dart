import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rise_college/model/admin_panel_model/system_setting_model_by_admin.dart';

class AdminSystemSettingsRepository {
  final FirebaseFirestore _firestore;

  AdminSystemSettingsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection('system_settings').doc('default');

  /// 🔥 REAL-TIME LISTENER
  Stream<SystemSettingModelByAdmin> getSettingsStream() {
    return _doc.snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return SystemSettingModelByAdmin.empty();
      }
      return SystemSettingModelByAdmin.fromJson(snapshot.data()!);
    });
  }

  Future<bool> updateSettings(SystemSettingModelByAdmin settings) async {
    try {
      await _doc.set(settings.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }
}