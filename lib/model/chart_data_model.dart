/// Chart data model for semester marks visualization
/// Structured for easy Firebase integration
class ChartDataModel {
  final String id; // For Firebase document ID
  final String semester;
  final double marks;
  final DateTime? date; // Optional date for Firebase filtering

  ChartDataModel({
    required this.id,
    required this.semester,
    required this.marks,
    this.date,
  });

  /// Factory constructor for creating ChartDataModel from Firebase document
  /// This will be used when integrating Firebase
  factory ChartDataModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ChartDataModel(
      id: id,
      semester: data['semester'] ?? '',
      marks: (data['marks'] ?? 0).toDouble(),
      // date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
      date: null, // Will be implemented when Firebase is integrated
    );
  }

  /// Convert to Map for Firebase (when adding/updating documents)
  Map<String, dynamic> toFirestore() {
    return {
      'semester': semester,
      'marks': marks,
      if (date != null) 'date': date,
    };
  }

  /// Factory constructor for mock data (current implementation)
  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      id: json['id'] ?? '',
      semester: json['semester'] ?? '',
      marks: (json['marks'] ?? 0).toDouble(),
      date: json['date'],
    );
  }
}
