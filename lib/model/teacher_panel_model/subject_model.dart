
/// Matches subjects_database collection (after Admin update):
/// { subjectId, subjectName, subjectCode, classId, className, classSection,
///   assignClass, assignedTeacherId, assignedTeacherName, createdAt }
class SubjectModel {
  final String subjectId;
  final String subjectName;
  final String subjectCode;
  final String classId;      // FK → classes.classId (exact, section-aware)
  final String className;
  final String classSection;

  SubjectModel({
    required this.subjectId,
    required this.subjectName,
    required this.subjectCode,
    required this.classId,
    required this.className,
    required this.classSection,
  });

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      subjectId: map['subjectId']?.toString() ?? '',
      subjectName: map['subjectName']?.toString() ?? '',
      subjectCode: map['subjectCode']?.toString() ?? '',
      classId: map['classId']?.toString() ?? '',
      className: map['className']?.toString() ?? '',
      classSection: map['classSection']?.toString() ?? '',
    );
  }
}