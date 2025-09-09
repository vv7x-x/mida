import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String nationalId;
  final String studentPhone;
  final String parentPhone;
  final String stage;
  final int age;
  final String center;
  final String status;
  final String? fcmToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Student({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.nationalId,
    required this.studentPhone,
    required this.parentPhone,
    required this.stage,
    required this.age,
    required this.center,
    required this.status,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'nationalId': nationalId,
      'studentPhone': studentPhone,
      'parentPhone': parentPhone,
      'stage': stage,
      'age': age,
      'center': center,
      'status': status,
      'fcmToken': fcmToken,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] ?? '',
      fullName: map['fullName'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      nationalId: map['nationalId'] ?? '',
      studentPhone: map['studentPhone'] ?? '',
      parentPhone: map['parentPhone'] ?? '',
      stage: map['stage'] ?? '',
      age: map['age'] ?? 0,
      center: map['center'] ?? '',
      status: map['status'] ?? 'pending',
      fcmToken: map['fcmToken'],
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  factory Student.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Student.fromMap({...data, 'id': doc.id});
  }

  Student copyWith({
    String? id,
    String? fullName,
    String? username,
    String? email,
    String? nationalId,
    String? studentPhone,
    String? parentPhone,
    String? stage,
    int? age,
    String? center,
    String? status,
    String? fcmToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      email: email ?? this.email,
      nationalId: nationalId ?? this.nationalId,
      studentPhone: studentPhone ?? this.studentPhone,
      parentPhone: parentPhone ?? this.parentPhone,
      stage: stage ?? this.stage,
      age: age ?? this.age,
      center: center ?? this.center,
      status: status ?? this.status,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
}