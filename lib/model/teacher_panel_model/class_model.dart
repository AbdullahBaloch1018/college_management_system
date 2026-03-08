
/// Matches classes collection:
/// { classId, className, classSection, assignedTeacherId, assignedTeacherName, createdAt }
class ClassModel {
  final String classId;
  final String className;    // e.g. "ICS"
  final String classSection; // e.g. "A"

  ClassModel({
    required this.classId,
    required this.className,
    required this.classSection,
  });

  /// Dropdown label e.g. "ICS  A  "
  String get displayName => '$className - $classSection';
  // String get displayName => '$className – $classSection';

  factory ClassModel.fromMap(Map<String, dynamic> map) {
    return ClassModel(
      classId: map['classId']?.toString() ?? '',
      className: map['className']?.toString() ?? '',
      classSection: map['classSection']?.toString() ?? '',
    );
  }
}
