/// Activity model for seminars and college activities
/// This model is structured to easily integrate with Firebase Firestore
class ActivityModel {
  final String id; // For Firebase document ID
  final String title;
  final String description;
  final String time;
  final String? category; // e.g., 'Seminar', 'Workshop', 'Event', 'Lecture'
  final DateTime? date; // For future Firebase date filtering
  final String? location; // Optional location field

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.category,
    this.date,
    this.location,
  });

  /// Factory constructor for creating ActivityModel from Firebase document
  /// This will be used when integrating Firebase
  /// Note: When integrating Firebase, uncomment and use:
  /// date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
  factory ActivityModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ActivityModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      time: data['time'] ?? '',
      category: data['category'],
      // date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
      date: null, // Will be implemented when Firebase is integrated
      location: data['location'],
    );
  }

  /// Convert to Map for Firebase (when adding/updating documents)
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'time': time,
      if (category != null) 'category': category,
      if (date != null) 'date': date,
      if (location != null) 'location': location,
    };
  }

  /// Factory constructor for mock data (current implementation)
  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      time: json['time'] ?? '',
      category: json['category'],
      date: json['date'],
      location: json['location'],
    );
  }
}
