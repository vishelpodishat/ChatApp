import 'package:chat_app/core/di/di.dart';
import 'package:chat_app/core/notification/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase/firebase_options.dart';

class Initializer {
  Initializer._();
  static Future<void> initializeTools() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await setupDependencies();
    try {
      await getIt<NotificationService>().initialize();
    } catch (e) {
      print('ERRROR::::${e.toString()}');
    }
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
