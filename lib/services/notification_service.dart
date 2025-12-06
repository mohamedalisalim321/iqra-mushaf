import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// -------------------------------------------
  /// INITIALIZATION
  /// -------------------------------------------
  Future<void> init() async {
    if (_initialized) return;

    try {
      // Android initialization
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Combine both
      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
      );

      // Handle taps on notification
      await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (details) {
          print("Notification tapped: ${details.payload}");
        },
      );

      // Android 13+ runtime permission
      await _handlePermissions();

      // Create default notification channel
      await _createDefaultChannel();

      _initialized = true;
    } catch (e) {
      print('❌ Notification init error: $e');
    }
  }

  Future<void> _handlePermissions() async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  /// -------------------------------------------
  /// DEFAULT CHANNEL (Android)
  /// -------------------------------------------
  Future<void> _createDefaultChannel() async {
    const AndroidNotificationChannel defaultChannel =
        AndroidNotificationChannel(
      'default_channel',
      'General Notifications',
      description: 'General alerts, reminders, and updates.',
      importance: Importance.high,
      playSound: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(defaultChannel);
  }

  /// -------------------------------------------
  /// SHOW NOTIFICATION
  /// -------------------------------------------
  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    await init();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Future<void> schedule({
  //   required String title,
  //   required String body,
  //   required DateTime dateTime,
  //   String? payload,
  // }) async {
  //   await init();

  //   final androidDetails = AndroidNotificationDetails(
  //     'scheduled_channel',
  //     'Scheduled Notifications',
  //     importance: Importance.high,
  //     priority: Priority.high,
  //   );

  //   final details = NotificationDetails(
  //     android: androidDetails,
  //     iOS: const DarwinNotificationDetails(),
  //   );

  //   await _plugin.zonedSchedule(
  //     dateTime.millisecondsSinceEpoch ~/ 1000,
  //     title,
  //     body,
  //     // Convert to local timezone-safe format
  //     tz.TZDateTime.from(dateTime, tz.local),
  //     details,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     payload: payload,
  //   );
  // }
}
