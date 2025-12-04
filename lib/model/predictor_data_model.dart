import 'package:flutter/material.dart';

/// Predictor data model for student performance metrics
/// Structured for Firebase integration
class PredictorDataModel {
  final String id; // For Firebase document ID
  final double assignmentScore;
  final double assessmentScore;
  final double attendanceScore;
  final DateTime? lastUpdated; // When data was last updated
  final String? userId; // Student user ID

  PredictorDataModel({
    required this.id,
    required this.assignmentScore,
    required this.assessmentScore,
    required this.attendanceScore,
    this.lastUpdated,
    this.userId,
  });

  /// Factory constructor for creating PredictorDataModel from Firebase document
  factory PredictorDataModel.fromFirestore(
    Map<String, dynamic> data,
    String id,
  ) {
    return PredictorDataModel(
      id: id,
      assignmentScore: (data['assignment_score'] ?? 0.0).toDouble(),
      assessmentScore: (data['assessment_score'] ?? 0.0).toDouble(),
      attendanceScore: (data['attendance_score'] ?? 0.0).toDouble(),
      // lastUpdated: data['lastUpdated'] != null ? (data['lastUpdated'] as Timestamp).toDate() : null,
      lastUpdated: null, // Will be implemented when Firebase is integrated
      userId: data['userId'],
    );
  }

  /// Convert to Map for Firebase (when adding/updating documents)
  Map<String, dynamic> toFirestore() {
    return {
      'assignment_score': assignmentScore,
      'assessment_score': assessmentScore,
      'attendance_score': attendanceScore,
      if (lastUpdated != null) 'lastUpdated': lastUpdated,
      if (userId != null) 'userId': userId,
    };
  }

  /// Factory constructor from Map (for current implementation compatibility)
  factory PredictorDataModel.fromMap(Map<String, dynamic> data, String id) {
    return PredictorDataModel(
      id: id,
      assignmentScore: (data['assignment_score'] ?? 0.0).toDouble(),
      assessmentScore: (data['assessment_score'] ?? 0.0).toDouble(),
      attendanceScore: (data['attendance_score'] ?? 0.0).toDouble(),
      userId: data['userId'],
    );
  }

  /// Calculate average score
  double get averageScore {
    return (assignmentScore + assessmentScore + attendanceScore) / 3;
  }

  /// Get overall performance grade
  String get performanceGrade {
    final avg = averageScore;
    if (avg >= 90) return 'Excellent';
    if (avg >= 80) return 'Very Good';
    if (avg >= 70) return 'Good';
    if (avg >= 60) return 'Average';
    return 'Needs Improvement';
  }

  /// Get color based on average score
  Color get performanceColor {
    final avg = averageScore;
    if (avg >= 90) return const Color(0xFF10B981); // Green
    if (avg >= 80) return const Color(0xFF3B82F6); // Blue
    if (avg >= 70) return const Color(0xFFF59E0B); // Amber
    if (avg >= 60) return const Color(0xFFEF4444); // Red
    return const Color(0xFFDC2626); // Dark Red
  }
}
