// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NotificationService {
//   NotificationService._();
//   static final NotificationService instance = NotificationService._();

//   final FlutterLocalNotificationsPlugin _plugin =
//       FlutterLocalNotificationsPlugin();

//   bool _initialized = false;

//   // Constants for notification channel
//   static const String _defaultChannelId = 'default_channel';
//   static const String _defaultChannelName = 'General Notifications';
//   static const String _defaultChannelDescription =
//       'General alerts, reminders, and updates.';
//   static const Importance _defaultImportance = Importance.high;
//   static const Priority _defaultPriority = Priority.high;

//   /// -------------------------------------------
//   /// INITIALIZATION
//   /// -------------------------------------------
//   Future<void> init() async {
//     if (_initialized) return;

//     try {
//       // Android initialization
//       const AndroidInitializationSettings androidSettings =
//           AndroidInitializationSettings('@mipmap/ic_launcher');

//       // Combine both Android and iOS initialization
//       const InitializationSettings settings = InitializationSettings(
//         android: androidSettings,
//       );

//       // Handle taps on notification
//       await _plugin.initialize(
//         settings,
//         onDidReceiveNotificationResponse: _onNotificationTapped,
//       );

//       // Android 13+ runtime permission
//       await _handlePermissions();

//       // Create default notification channel
//       await _createDefaultChannel();

//       _initialized = true;
//     } catch (e) {
//       print('❌ Notification init error: $e');
//     }
//   }

//   Future<void> _handlePermissions() async {
//     final status = await Permission.notification.status;

//     if (status.isDenied) {
//       // Request permissions if not granted
//       await Permission.notification.request();
//     } else if (status.isPermanentlyDenied) {
//       // Suggest opening app settings if permission is permanently denied
//       _openAppSettings();
//     }
//   }

//   Future<void> _openAppSettings() async {
//     final opened = await openAppSettings();
//     if (opened) {
//       print('Opened app settings to allow notification permission.');
//     } else {
//       print('Could not open app settings.');
//     }
//   }

//   /// -------------------------------------------
//   /// DEFAULT CHANNEL (Android)
//   /// -------------------------------------------
//   Future<void> _createDefaultChannel() async {
//     const AndroidNotificationChannel defaultChannel =
//         AndroidNotificationChannel(
//       _defaultChannelId,
//       _defaultChannelName,
//       description: _defaultChannelDescription,
//       importance: _defaultImportance,
//       playSound: true,
//     );

//     await _plugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(defaultChannel);
//   }

//   /// -------------------------------------------
//   /// SHOW NOTIFICATION
//   /// -------------------------------------------
//   Future<void> show({
//     required String title,
//     required String body,
//     String? payload,
//     String channelId = _defaultChannelId,
//   }) async {
//     await init();

//     const AndroidNotificationDetails androidDetails =
//         AndroidNotificationDetails(
//       _defaultChannelId,
//       _defaultChannelName,
//       importance: _defaultImportance,
//       priority: _defaultPriority,
//       playSound: true,
//     );

//     const NotificationDetails details = NotificationDetails(
//       android: androidDetails,
//     );

//     await _plugin.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       details,
//       payload: payload,
//     );
//   }

//   /// -------------------------------------------
//   /// NOTIFICATION TAP HANDLER
//   /// -------------------------------------------
//   void _onNotificationTapped(NotificationResponse details) {
//     // This function gets called when the user taps a notification
//     print("Notification tapped: ${details.payload}");

//     // Handle tap navigation or custom logic
//     if (details.payload != null) {
//       // Perform some action based on the payload
//       // For example, navigate to a specific screen
//     }
//   }
// }
