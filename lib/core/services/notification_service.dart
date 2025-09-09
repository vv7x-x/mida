import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    // Request permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Handle notification tap when app is terminated
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    print('Received foreground message: ${message.notification?.title}');
    
    // Show in-app notification or handle accordingly
    if (message.notification != null) {
      _showInAppNotification(message);
    }
  }

  static void _handleNotificationTap(RemoteMessage message) {
    print('Notification tapped: ${message.data}');
    
    // Navigate based on notification type
    String? type = message.data['type'];
    switch (type) {
      case 'announcement':
        // Navigate to announcements page
        break;
      case 'schedule_change':
        // Navigate to schedule page
        break;
      case 'account_status':
        // Navigate to profile or dashboard
        break;
      default:
        // Navigate to dashboard
        break;
    }
  }

  static void _showInAppNotification(RemoteMessage message) {
    // This would typically show a snackbar or dialog
    // Implementation depends on your navigation context
  }

  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  static Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }

  // Subscribe to student-specific topics
  static Future<void> subscribeToStudentTopics(String studentId) async {
    await subscribeToTopic('student_$studentId');
    await subscribeToTopic('all_students');
  }

  static Future<void> unsubscribeFromStudentTopics(String studentId) async {
    await unsubscribeFromTopic('student_$studentId');
    await unsubscribeFromTopic('all_students');
  }
}
