import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:alagy/core/routes/routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static String? fcmToken;

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize() async {
    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 1. Request permission first
    await _requestPermission();

    // 2. For iOS, ensure APNS token is available before getting FCM token
    if (Platform.isIOS) {
      await _ensureApnsToken();
    }

    // 3. Now safely get FCM token
    try {
      fcmToken = await _messaging.getToken();
      if (fcmToken != null) {
        log('✅ FCM Token retrieved: $fcmToken');
      } else {
        log('⚠️ FCM Token is null, will retry on token refresh');
      }
    } catch (e) {
      log('❌ Error getting FCM token: $e');
    }

    // 4. Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      fcmToken = newToken;
      log('🔄 FCM Token refreshed: $newToken');
    });

    // 5. Setup foreground/background handlers
    await _setupMessageHandlers();
  }

  /// Ensures APNS token is available on iOS before requesting FCM token
  Future<void> _ensureApnsToken() async {
    String? apnsToken = await _messaging.getAPNSToken();

    if (apnsToken != null) {
      log('✅ APNS Token available: ${apnsToken.substring(0, 20)}...');
      return;
    }

    log('⏳ APNS Token not available yet, waiting...');

    // Wait for APNS token with timeout
    final completer = Completer<void>();
    late StreamSubscription<String> subscription;

    subscription = _messaging.onTokenRefresh.listen((token) {
      if (!completer.isCompleted) {
        log('✅ APNS Token received via refresh');
        completer.complete();
        subscription.cancel();
      }
    });

    // Wait up to 5 seconds for APNS token
    try {
      await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          log('⚠️ APNS Token timeout - proceeding anyway');
          subscription.cancel();
        },
      );
    } catch (e) {
      log('⚠️ Error waiting for APNS token: $e');
      subscription.cancel();
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      log('🚫 Notification permission denied');
    }
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    // Android setup
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for important notifications',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // iOS setup
    const initializationSettingsDarwin = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log('🧭 Notification clicked: ${details.payload}');
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> _setupMessageHandlers() async {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // Background tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);

    // App opened from terminated
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  void _handleMessage(RemoteMessage message) {
    final type = message.data['type'];
    log('📩 Notification data: ${message.data}');
    if (type == 'chat') {
      // Navigate to chat screen if needed
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await setupFlutterNotifications();

    await _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: jsonEncode(message.data),
    );
  }

  // --- ADMIN API ---
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": dotenv.get("FIREBASE_TYPE", fallback: ""),
      "project_id": dotenv.get("FIREBASE_PROJECT_ID", fallback: ""),
      "private_key_id": dotenv.get("FIREBASE_PRIVATE_KEY_ID", fallback: ""),
      "private_key": dotenv
          .get("FIREBASE_PRIVATE_KEY", fallback: "")
          .replaceAll(r'\n', '\n'),
      "client_email": dotenv.get("FIREBASE_CLIENT_EMAIL", fallback: ""),
      "client_id": dotenv.get("FIREBASE_CLIENT_ID", fallback: ""),
      "token_uri": dotenv.get("FIREBASE_TOKEN_URI",
          fallback: "https://oauth2.googleapis.com/token"),
    };

    final client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      ["https://www.googleapis.com/auth/firebase.messaging"],
    );

    final credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        ["https://www.googleapis.com/auth/firebase.messaging"],
        client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> sendNotification(
      String deviceToken, String title, String body) async {
    final String accessToken = await getAccessToken();
    const String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/alagy-92af4/messages:send';

    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        "data": {"route": RouteNames.notifications}
      }
    };

    final response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(message),
    );
    print(response.statusCode == 200
        ? 'Notification sent'
        : 'Failed to send: ${response.body}');
  }
}
