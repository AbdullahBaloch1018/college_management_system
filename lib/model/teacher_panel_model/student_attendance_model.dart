
/// Matches users_database student documents:
/// { uid, displayName, rollNo, faculty, role, ... }
class StudentAttendanceModel {
  final String uid;
  final String name;
  final String rollNo;
  final String faculty;     // stores className e.g. "ICS"
  String attendanceStatus;  // 'Present' | 'Absent'

  StudentAttendanceModel({
    required this.uid,
    required this.name,
    required this.rollNo,
    required this.faculty,
    this.attendanceStatus = 'Absent',
  });

  factory StudentAttendanceModel.fromMap(Map<String, dynamic> map) {
    return StudentAttendanceModel(
      uid: map['uid']?.toString() ?? '',
      name: map['displayName']?.toString() ?? '',
      rollNo: map['rollNo']?.toString() ?? '',
      faculty: map['faculty']?.toString() ?? '',
    );
  }
}