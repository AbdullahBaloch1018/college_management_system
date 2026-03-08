class SubjectByAdminModel {
  final String id;
  final String name;
  final String code;
  // final String creditHours;
  final String? assignClass;
  final String? assignedTeacherName;
  final String? assignedTeacherId;

  SubjectByAdminModel({
    required this.id,
    required this.name,
    required this.code,
    // required this.creditHours,
    required this.assignClass,
    required this.assignedTeacherName,
    this.assignedTeacherId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'assignClass': assignClass,
      'assignedTeacherName': assignedTeacherName,
      'assignedTeacherId': assignedTeacherId,
    };
  }

  factory SubjectByAdminModel.fromMap(Map<String, dynamic> map) {
    return SubjectByAdminModel(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      assignClass: map['assignClass'],
      assignedTeacherName: map['assignedTeacherName'],
      assignedTeacherId: map['assignedTeacherId'],
    );
  }
}