class StudentModel {
  final String id;
  final String name;
  final String rollNo;
  final String classId;
  String attendanceStatus;

  StudentModel({
    required this.id,
    required this.name,
    required this.rollNo,
    required this.classId,
    this.attendanceStatus = 'Present',
  });

  factory StudentModel.fromJson(Map<String, dynamic> json, String docId) {
    return StudentModel(
      id: docId,
      name: json['name'] ?? '',
      rollNo: json['rollNo'] ?? '',
      classId: json['classId'] ?? '',
      attendanceStatus: json['attendanceStatus'] ?? 'Present',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'studentId': id,
      'name': name,
      'rollNo': rollNo,
      'status': attendanceStatus,
    };
  }
}
