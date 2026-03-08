class ClassModelByAdmin {
  final String id;
  final String name;
  final String section;
  final int? totalStudents;
  final String? assignedTeacher;

  ClassModelByAdmin({
    required this.id,
    required this.name,
    required this.section,
    this.totalStudents = 0,
    this.assignedTeacher,
  });

  /// This is REQUIRED to send data to Firebase
  Map<String, dynamic> toMap() {
    return {
      'id': id, // storing id inside document for easy access
      'name': name,
      'section': section,
      'totalStudents': totalStudents,
      'assignedTeacher': assignedTeacher,
    };
  }

  /// 🔹 UPDATED: safer fromJson (null-safe)
  factory ClassModelByAdmin.fromMap(Map<String, dynamic> json, String docId) {
    return ClassModelByAdmin(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      section: json['section'] ?? '',
      totalStudents: json['totalStudents'] ?? 0,
      assignedTeacher: json['assignedTeacher'],
    );
  }
}
