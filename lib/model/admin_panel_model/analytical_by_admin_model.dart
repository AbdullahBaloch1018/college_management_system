class AnalyticsModel {
  final int totalStudents;
  final int totalTeachers;
  final int totalClasses;
  final int totalSubjects;
  final double averageAttendance;
  final double averageGrade;
  final int activeUsers;
  final int pendingApprovals;

  AnalyticsModel({
    required this.totalStudents,
    required this.totalTeachers,
    required this.totalClasses,
    required this.totalSubjects,
    required this.averageAttendance,
    required this.averageGrade,
    required this.activeUsers,
    required this.pendingApprovals,
  });
}