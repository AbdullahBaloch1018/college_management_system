class ResultModel {
  final String studentId;
  final String studentName;
  final String rollNo;
  double marks;
  String grade;

  ResultModel({
    required this.studentId,
    required this.studentName,
    required this.rollNo,
    this.marks = 0,
    this.grade = '',
  });

  void calculateGrade() {
    if (marks >= 85) {
      grade = 'A';
    } else if (marks >= 70) {
      grade = 'B';
    } else if (marks >= 60) {
      grade = 'C';
    } else if (marks >= 50) {
      grade = 'D';
    } else {
      grade = 'F';
    }
  }
}