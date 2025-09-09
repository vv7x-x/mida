import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String type;
  final String? attachment;
  final String? imageUrl;
  final String? locationLink;
  final bool isActive;
  final String? targetAudience; // 'all', 'specific_center', 'specific_stage'
  final List<String>? targetValues; // center names or stages
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
    this.attachment,
    this.imageUrl,
    this.locationLink,
    this.isActive = true,
    this.targetAudience,
    this.targetValues,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': Timestamp.fromDate(timestamp),
      'type': type,
      'attachment': attachment,
      'imageUrl': imageUrl,
      'locationLink': locationLink,
      'isActive': isActive,
      'targetAudience': targetAudience,
      'targetValues': targetValues,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory Announcement.fromMap(Map<String, dynamic> map) {
    return Announcement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      timestamp: map['timestamp'] != null 
          ? (map['timestamp'] as Timestamp).toDate() 
          : DateTime.now(),
      type: map['type'] ?? 'general',
      attachment: map['attachment'],
      imageUrl: map['imageUrl'],
      locationLink: map['locationLink'],
      isActive: map['isActive'] ?? true,
      targetAudience: map['targetAudience'],
      targetValues: map['targetValues'] != null 
          ? List<String>.from(map['targetValues']) 
          : null,
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] as Timestamp).toDate() 
          : null,
      updatedAt: map['updatedAt'] != null 
          ? (map['updatedAt'] as Timestamp).toDate() 
          : null,
    );
  }

  factory Announcement.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Announcement.fromMap({...data, 'id': doc.id});
  }

  Announcement copyWith({
    String? id,
    String? title,
    String? body,
    DateTime? timestamp,
    String? type,
    String? attachment,
    String? imageUrl,
    String? locationLink,
    bool? isActive,
    String? targetAudience,
    List<String>? targetValues,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Announcement(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      attachment: attachment ?? this.attachment,
      imageUrl: imageUrl ?? this.imageUrl,
      locationLink: locationLink ?? this.locationLink,
      isActive: isActive ?? this.isActive,
      targetAudience: targetAudience ?? this.targetAudience,
      targetValues: targetValues ?? this.targetValues,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedDate {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  String get formattedDateTime {
    return '$formattedDate - $formattedTime';
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  bool get hasAttachment => attachment != null && attachment!.isNotEmpty;
  bool get hasLocation => locationLink != null && locationLink!.isNotEmpty;

  bool get isGeneral => type == 'general';
  bool get isUrgent => type == 'urgent';
  bool get isScheduleChange => type == 'schedule_change';
  bool get isAccountStatus => type == 'account_status';
}