import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  NotificationService(this._firebaseMessaging);

  Future<void> initialize() async {
    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _localNotifications.initialize(initSettings);

    // Only initialize FCM on Android or iOS with proper setup
    if (!_shouldSkipFCM()) {
      try {
        await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

        // Listen to foreground messages
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          _showLocalNotification(message);
        });

        _isInitialized = true;
      } catch (e) {
        print('FCM initialization error: $e');
      }
    } else {
      print('Skipping FCM initialization - running on iOS without APNS');
      _isInitialized = true; // Mark as initialized even without FCM
    }
  }

  bool _shouldSkipFCM() {
    // Skip FCM on iOS in debug mode
    return Platform.isIOS && kDebugMode;
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'chat_channel',
      'Chat Notifications',
      channelDescription: 'Notifications for new messages',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Message',
      message.notification?.body ?? 'You have a new message',
      details,
      payload: message.data.toString(),
    );
  }

  Future<String?> getToken() async {
    if (_shouldSkipFCM()) {
      return null;
    }

    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  bool get isNotificationAvailable => !_shouldSkipFCM() && _isInitialized;
}
