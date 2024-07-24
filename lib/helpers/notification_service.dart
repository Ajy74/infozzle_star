import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService = NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('onboarding_logo'); // Use your icon here

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    init();
  }

  void init() async {
    final InitializationSettings initializationSettings = InitializationSettings(
      android: _androidInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void createNotification(int id, int progress, int maxProgress, int currentFile, totalFiles, String filename) {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'progress channel',
      'progress channel',
      channelDescription: 'progress channel description',
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress,
      icon: 'onboarding_logo',
    );
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    _flutterLocalNotificationsPlugin.show(
      id,
      filename,
      'Download in progress ($currentFile/$totalFiles), $progress%',
      platformChannelSpecifics,
    );
  }

  void cancelNotification(int id) {
    _flutterLocalNotificationsPlugin.cancel(id);
  }
}
