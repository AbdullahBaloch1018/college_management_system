class TeacherModel {
  final String id;
  final String name;
  final String email;
  final String department;
  final List<String> subjects;
  final List<String> classes;

  TeacherModel({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.subjects,
    required this.classes,
  });

  factory TeacherModel.fromJson(Map<String, dynamic> json) {
    return TeacherModel(
      id: json['uid'],
      name: json['displayName'],
      email: json['email'],
      department: json['department'],
      subjects: List<String>.from(json['subjects']),
      classes: List<String>.from(json['classes']),
    );
  }
}
