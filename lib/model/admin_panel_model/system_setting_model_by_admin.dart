class SystemSettingModelByAdmin {
  final String institutionName;
  final String email;
  final String phone;
  final String address;
  final String sessionStart;
  final String sessionEnd;
  final int attendanceThreshold;
  final int passingMarks;

  SystemSettingModelByAdmin({
    required this.institutionName,
    required this.email,
    required this.phone,
    required this.address,
    required this.sessionStart,
    required this.sessionEnd,
    required this.attendanceThreshold,
    required this.passingMarks,
  });

  /// 🔹 Convert Model → Firestore Map
  Map<String, dynamic> toJson() {
    return {
      'institutionName': institutionName,
      'email': email,
      'phone': phone,
      'address': address,
      'sessionStart': sessionStart,
      'sessionEnd': sessionEnd,
      'attendanceThreshold': attendanceThreshold,
      'passingMarks': passingMarks,
    };
  }

  /// 🔹 Convert Firestore Map → Model
  factory SystemSettingModelByAdmin.fromJson(Map<String, dynamic> json) {
    return SystemSettingModelByAdmin(
      institutionName: json['institutionName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      sessionStart: json['sessionStart'] ?? '',
      sessionEnd: json['sessionEnd'] ?? '',
      attendanceThreshold: json['attendanceThreshold'] ?? 0,
      passingMarks: json['passingMarks'] ?? 0,
    );
  }

  /// 🔹 Empty default
  factory SystemSettingModelByAdmin.empty() {
    return SystemSettingModelByAdmin(
      institutionName: '',
      email: '',
      phone: '',
      address: '',
      sessionStart: '',
      sessionEnd: '',
      attendanceThreshold: 0,
      passingMarks: 0,
    );
  }
}