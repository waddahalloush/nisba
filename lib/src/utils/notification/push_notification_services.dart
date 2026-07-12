/// Waddah CODE (Stabilized Production Mix)
/// *****************************************************
///  version: 1.2
/// *****************************************************
library;

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:nisba_app/src/utils/notification/received_notification_model.dart';

import '../../data/local/get_storage_helper.dart';

class PushNotificationService {
  PushNotificationService._();

  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';
  static const String channelDescription =
      'This channel is used for important notifications';

  static final PushNotificationService instance = PushNotificationService._();

  static final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();
  static final StreamController<ReceivedNotification> didReceiveNotif =
      StreamController<ReceivedNotification>.broadcast();

  static Future<void> initialize() async {
    await _configureChannels();
    await _registerNotificationListeners();
    await listenFirebaseMessaging();
  }

  static Future<void> listenFirebaseMessaging() async {
    FirebaseMessaging.onMessage.listen(fcmForegroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(fcmMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  }

  static Future<void> _configureChannels() async {
    final androidPlugin = localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.createNotificationChannel(
        androidNotificationChannel(),
      );
    }
  }

  static Future<void> _registerNotificationListeners() async {
    final initializationSettings = InitializationSettings(
      android: androidIntSettings(),
    );

    await localNotifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
      onDidReceiveBackgroundNotificationResponse: _notificationTapBackground,
    );
  }

  static void _handleNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    _onTapNotification(notificationResponse.payload);
  }

  static Future<void> showLocalNotification({
    required RemoteMessage? message,
  }) async {
    if (message == null) return;

    final notification = message.notification;
    if (notification != null) {
      log('showLocalNotification executing...');

      final channel = androidNotificationChannel();

      // Check for notification image URL
      final imageUrl = message.notification?.android?.imageUrl;
      Uint8List? imageBytes;
      if (imageUrl != null && imageUrl.isNotEmpty) {
        imageBytes = await _downloadImageBytes(imageUrl);
      }

      final androidDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: channel.importance,
        priority: Priority.high,
        icon:
            message.notification?.android?.smallIcon ?? '@drawable/ic_launcher',
        ticker: 'ticker',
        styleInformation: imageBytes != null
            ? BigPictureStyleInformation(
                ByteArrayAndroidBitmap(imageBytes),
                contentTitle: notification.title,
                summaryText: notification.body,
              )
            : null,
      );

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      await localNotifications.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: notificationDetails,
        payload: jsonEncode(message.data),
      );
    }
  }

  /// Downloads image bytes from a URL for use in BigPicture notifications.
  static Future<Uint8List?> _downloadImageBytes(String imageUrl) async {
    try {
      final httpClient = HttpClient();
      final request = await httpClient.getUrl(Uri.parse(imageUrl));
      final response = await request.close();
      if (response.statusCode == 200) {
        return consolidateHttpClientResponseBytes(response);
      }
    } catch (e) {
      log('Failed to download notification image: $e');
    }
    return null;
  }

  static AndroidNotificationChannel androidNotificationChannel({
    String channelId = channelId,
    String channelName = channelName,
    String channelDescription = channelDescription,
    Importance importance = Importance.max,
  }) {
    return AndroidNotificationChannel(
      channelId,
      channelName,
      description: channelDescription,
      importance: importance,
    );
  }

  static AndroidInitializationSettings androidIntSettings({
    String launcherIcon = '@drawable/ic_launcher',
  }) {
    return AndroidInitializationSettings(launcherIcon);
  }

  static void dispose() {
    didReceiveNotif.close();
  }

  static Future<void> _onTapNotification(String? payload) async {
    log('_onTapNotification');
    log(payload ?? '');

    // // Navigate to notifications screen on tap
    // Get.toNamed(AppRoutesNames.notifications);
  }

  static Future<void> _notificationTapBackground(
    NotificationResponse notificationResponse,
  ) async {
    log('_notificationTapBackground');

    final input = notificationResponse.input;
    if (input?.isNotEmpty ?? false) {
      log(notificationResponse.input ?? '');
    }
  }

  @pragma(
    'vm:entry-point',
  ) // ✅ FIXED: Keeps VM from shaking entrypoint in runtime isolates
  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    log('fcmBackgroundHandler');

    if (message.notification != null) {
      log(
        "Handling a background message: ${message.data}==${message.notification?.title}",
      );
    }
  }

  // Handle FCM notification when app is in foreground
  static Future<void> fcmForegroundHandler(RemoteMessage message) async {
    log('fcmForegroundHandler received payload');

    // Process layout badges safely
    Get.find<GetStorageHelper>().saveNotiBadge();

    // ✅ FIXED: Shielded checking logic to present alerts globally on any active testing OS platform
    if (message.notification != null) {
      await showLocalNotification(message: message);
    }
  }

  static Future<void> fcmMessageOpenedApp(RemoteMessage message) async {
    log('fcmMessageOpenedApp');
  }
}
