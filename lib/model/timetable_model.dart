/// Timetable model for academic schedule
/// Structured for easy Firebase integration
class TimetableModel {
  final String id; // For Firebase document ID
  final String? imageUrl; // Firebase Storage URL (when admin uploads)
  final String? localAssetPath; // Local asset path (fallback)
  final String? title; // e.g., "Academic Time Table 2080"
  final String? academicYear; // e.g., "2080"
  final DateTime? lastUpdated; // When admin last updated
  final String? uploadedBy; // Admin user ID

  TimetableModel({
    required this.id,
    this.imageUrl,
    this.localAssetPath,
    this.title,
    this.academicYear,
    this.lastUpdated,
    this.uploadedBy,
  });

  /// Factory constructor for creating TimetableModel from Firebase document
  /// This will be used when integrating Firebase
  factory TimetableModel.fromFirestore(Map<String, dynamic> data, String id) {
    return TimetableModel(
      id: id,
      imageUrl: data['imageUrl'],
      title: data['title'],
      academicYear: data['academicYear'],
      // lastUpdated: data['lastUpdated'] != null ? (data['lastUpdated'] as Timestamp).toDate() : null,
      lastUpdated: null, // Will be implemented when Firebase is integrated
      uploadedBy: data['uploadedBy'],
      localAssetPath: data['localAssetPath'], // Fallback path
    );
  }

  /// Convert to Map for Firebase (when adding/updating documents)
  Map<String, dynamic> toFirestore() {
    return {
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (title != null) 'title': title,
      if (academicYear != null) 'academicYear': academicYear,
      if (lastUpdated != null) 'lastUpdated': lastUpdated,
      if (uploadedBy != null) 'uploadedBy': uploadedBy,
      if (localAssetPath != null) 'localAssetPath': localAssetPath,
    };
  }

  /// Factory constructor for mock data (current implementation)
  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
      id: json['id'] ?? '',
      imageUrl: json['imageUrl'],
      localAssetPath: json['localAssetPath'],
      title: json['title'],
      academicYear: json['academicYear'],
      lastUpdated: json['lastUpdated'],
      uploadedBy: json['uploadedBy'],
    );
  }

  /// Get the image source (Firebase URL or local asset)
  String? get imageSource => imageUrl ?? localAssetPath;
}
