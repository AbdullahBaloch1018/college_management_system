import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;                    // Firestore document ID (usually user's auth UID)
  final String name;
  final String email;
  final String rollNumber;
  final String faculty;
  final String phoneNumber;
  final String? imageUrl;              // Made nullable because user may not have profile pic

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.rollNumber,
    required this.faculty,
    required this.phoneNumber,
    this.imageUrl,
  });

  // Convert Firestore DocumentSnapshot directly into UserModel
  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      rollNumber: data['rollNumber'] ?? '',
      faculty: data['faculty'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      imageUrl: data['imageUrl'] as String?,
    );
  }

  // Convert a Map (from Firestore) into UserModel
  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      uid: documentId,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      rollNumber: map['rollNumber'] as String? ?? '',
      faculty: map['faculty'] as String? ?? '',
      phoneNumber: map['phoneNumber'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
    );
  }

  // Convert UserModel instance into Map (to upload/update in Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'rollNumber': rollNumber,
      'faculty': faculty,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,              // Will be null if no image
    };
  }

  // Useful for updating only specific fields (e.g., profile update screen)
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? rollNumber,
    String? faculty,
    String? phoneNumber,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      rollNumber: rollNumber ?? this.rollNumber,
      faculty: faculty ?? this.faculty,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // Optional: for debugging and logging
  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, rollNumber: $rollNumber, faculty: $faculty, phoneNumber: $phoneNumber, imageUrl: $imageUrl)';
  }

  // Optional: for comparing two UserModel instances
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.rollNumber == rollNumber &&
        other.faculty == faculty &&
        other.phoneNumber == phoneNumber &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return Object.hash(uid, name, email, rollNumber, faculty, phoneNumber, imageUrl);
  }
}