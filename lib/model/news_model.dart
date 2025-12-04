/// News model for college announcements and notices
/// Structured for easy Firebase integration
class NewsModel {
  final String id; // For Firebase document ID
  final String title;
  final String description;
  final DateTime? date; // Publication date
  final String? category; // e.g., 'Announcement', 'Event', 'Notice'
  final String? author; // Admin/author name
  final bool? isImportant; // For highlighting important news

  NewsModel({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.category,
    this.author,
    this.isImportant,
  });

  /// Factory constructor for creating NewsModel from Firebase document
  /// This will be used when integrating Firebase
  factory NewsModel.fromFirestore(Map<String, dynamic> data, String id) {
    return NewsModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      // date: data['date'] != null ? (data['date'] as Timestamp).toDate() : null,
      date: null, // Will be implemented when Firebase is integrated
      category: data['category'],
      author: data['author'],
      isImportant: data['isImportant'] ?? false,
    );
  }

  /// Convert to Map for Firebase (when adding/updating documents)
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (author != null) 'author': author,
      if (isImportant != null) 'isImportant': isImportant,
    };
  }

  /// Factory constructor for API data (current implementation)
  /// Handles the current API structure with 'strong' and 'div' fields
  factory NewsModel.fromApiJson(Map<String, dynamic> json, String id) {
    return NewsModel(
      id: id,
      title: json['strong'] ?? json['title'] ?? 'No Title',
      description: json['div'] ?? json['description'] ?? '',
      date: DateTime.now(), // API doesn't provide date, use current
      category: json['category'],
      author: json['author'],
      isImportant: json['isImportant'] ?? false,
    );
  }

  /// Factory constructor for JSON (general)
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'],
      category: json['category'],
      author: json['author'],
      isImportant: json['isImportant'] ?? false,
    );
  }
}
