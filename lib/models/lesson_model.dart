import 'package:cloud_firestore/cloud_firestore.dart';

class Lesson {
  final String id;
  final String subject;
  final DateTime date;
  final String time;
  final String center;
  final String? description;
  final String? teacherName;
  final int? duration; // in minutes
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Lesson({
    required this.id,
    required this.subject,
    required this.date,
    required this.time,
    required this.center,
    this.description,
    this.teacherName,
    this.duration,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subject': subject,
      'date': Timestamp.fromDate(date),
      'time': time,
      'center': center,
      'description': description,
      'teacherName': teacherName,
      'duration': duration,
      'isActive': isActive,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] ?? '',
      subject: map['subject'] ?? '',
      date: map['date'] != null 
          ? (map['date'] as Timestamp).toDate() 
          : DateTime.now(),
      time: map['time'] ?? '',
      center: map['center'] ?? '',
      description: map['description'],
      teacherName: map['teacherName'],
      duration: map['duration'],
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  factory Lesson.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Lesson.fromMap({...data, 'id': doc.id});
  }

  Lesson copyWith({
    String? id,
    String? subject,
    DateTime? date,
    String? time,
    String? center,
    String? description,
    String? teacherName,
    int? duration,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lesson(
      id: id ?? this.id,
      subject: subject ?? this.subject,
      date: date ?? this.date,
      time: time ?? this.time,
      center: center ?? this.center,
      description: description ?? this.description,
      teacherName: teacherName ?? this.teacherName,
      duration: duration ?? this.duration,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  String get formattedDateTime {
    return '$formattedDate - $time';
  }

  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  bool get isPast {
    return date.isBefore(DateTime.now());
  }

  bool get isFuture {
    return date.isAfter(DateTime.now());
  }
}