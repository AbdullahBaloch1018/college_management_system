class TimetableByAdminModel {
  final String id;
  final String classId;
  final String subjectId;
  final String teacherId;
  final String day;
  final String timeSlot;
  final String room;

  TimetableByAdminModel({
    required this.id,
    required this.classId,
    required this.subjectId,
    required this.teacherId,
    required this.day,
    required this.timeSlot,
    required this.room,
  });

  factory TimetableByAdminModel.fromJson(Map<String, dynamic> json) {
    return TimetableByAdminModel(
      id: json['id'],
      classId: json['classId'],
      subjectId: json['subjectId'],
      teacherId: json['teacherId'],
      day: json['day'],
      timeSlot: json['timeSlot'],
      room: json['room'],
    );
  }
}