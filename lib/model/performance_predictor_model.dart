class PerformancePredictorModel {
  final String subject;
  final String predictedGrade;
  final int confidence;

  PerformancePredictorModel({
    required this.subject,
    required this.predictedGrade,
    required this.confidence,
  });
}
