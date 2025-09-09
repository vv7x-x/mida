import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import '../../models/lesson_model.dart';
import '../../models/announcement_model.dart';

// Lessons provider
final lessonsProvider = StreamProvider<List<Lesson>>((ref) {
  return FirebaseService.lessonsCollection
      .where('isActive', isEqualTo: true)
      .orderBy('date')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Lesson.fromFirestore(doc))
          .toList());
});

// Student-specific lessons provider
final studentLessonsProvider = StreamProvider.family<List<Lesson>, String>((ref, studentId) {
  return FirebaseService.lessonsCollection
      .where('isActive', isEqualTo: true)
      .orderBy('date')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Lesson.fromFirestore(doc))
          .toList());
});

// Announcements provider
final announcementsProvider = StreamProvider<List<Announcement>>((ref) {
  return FirebaseService.announcementsCollection
      .where('isActive', isEqualTo: true)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList());
});

// Student-specific announcements provider
final studentAnnouncementsProvider = StreamProvider.family<List<Announcement>, String>((ref, center) {
  return FirebaseService.announcementsCollection
      .where('isActive', isEqualTo: true)
      .where('targetAudience', whereIn: ['all', 'specific_center'])
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .where((announcement) => 
              announcement.targetAudience == 'all' ||
              (announcement.targetAudience == 'specific_center' && 
               announcement.targetValues?.contains(center) == true))
          .toList());
});

// Today's lessons provider
final todayLessonsProvider = StreamProvider<List<Lesson>>((ref) {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
  
  return FirebaseService.lessonsCollection
      .where('isActive', isEqualTo: true)
      .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
      .orderBy('date')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Lesson.fromFirestore(doc))
          .toList());
});

// Upcoming lessons provider
final upcomingLessonsProvider = StreamProvider<List<Lesson>>((ref) {
  final now = DateTime.now();
  
  return FirebaseService.lessonsCollection
      .where('isActive', isEqualTo: true)
      .where('date', isGreaterThan: Timestamp.fromDate(now))
      .orderBy('date')
      .limit(10)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Lesson.fromFirestore(doc))
          .toList());
});

// Recent announcements provider
final recentAnnouncementsProvider = StreamProvider<List<Announcement>>((ref) {
  return FirebaseService.announcementsCollection
      .where('isActive', isEqualTo: true)
      .orderBy('timestamp', descending: true)
      .limit(5)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Announcement.fromFirestore(doc))
          .toList());
});
