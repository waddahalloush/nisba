/// Mozafar CODE
/// *****************************************************
///  version: 1
/// *****************************************************
library;

import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../firebase_options.dart';
import '../../../logger.dart';

class FcmHelper {
  FcmHelper._();

  static final FcmHelper instance = FcmHelper._();
  static late FirebaseMessaging messaging;
  static String? firebaseToken;
  static String? apnsToken;

  static Future<void> initFcm() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      log('>>>>> initialize FCM and Firebase <<<<');
      

      messaging = FirebaseMessaging.instance;
      await generateFcmToken();
      
      await setupFcmNotificationSettings();
    } catch (error) {
      log('Error initializing FCM: $error');
    }
  }

  static Future<String?> checkPlatform() async {
    String? fcm;
    if (Platform.isIOS) {
      apnsToken = await messaging.getToken();
      fcm = apnsToken;
    } else if (Platform.isAndroid) {
      firebaseToken = await messaging.getToken();
      fcm = firebaseToken;
    }
    return fcm;
  }

  static Future<void> generateFcmToken() async {
    try {
      firebaseToken = await messaging.getToken();

      if (firebaseToken == null) {
        const maxRetries = 2;
        var retries = 0;
        while (firebaseToken == null && retries < maxRetries) {
          await Future<void>.delayed(const Duration(seconds: 3));
          firebaseToken = await messaging.getToken();
          retries++;
        }
      }

      if (firebaseToken != null) {
        log('FCM Token: $firebaseToken');
      }
    } catch (error) {
      log('Error generating FCM token: $error');
    }
  }

  static Future subscribe(String topic) async {
    await messaging.subscribeToTopic(topic).then((value) {
      AppLogger.logPink('Subscribe OK');
    });
  }

  static Future unSubscribe(String topic) async {
    await messaging.unsubscribeFromTopic(topic);
    AppLogger.logPink('UNSubscribe');
  }

  static Future<void> setupFcmNotificationSettings() async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      sound: true,
      badge: true,
    );
    await messaging.requestPermission(provisional: true);
  }
}
