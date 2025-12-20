import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@injectable
class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showDownloadNotification(
    double progress,
    String fileName,
  ) async {
    final int progressValue = (progress * 100).toInt();
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'download_channel',
      'Downloads',
      channelDescription: 'Channel for file download notifications',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      progress: progressValue,
      onlyAlertOnce: true,
      icon: '@mipmap/ic_launcher',
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    if (progress < 1.0) {
      await _flutterLocalNotificationsPlugin.show(
        0,
        'Downloading: $fileName',
        '$progressValue%',
        platformChannelSpecifics,
        payload: 'item x',
      );
    } else {
      // When download is complete, show a different notification
      await _flutterLocalNotificationsPlugin.show(
        0,
        'Download Complete',
        fileName,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'download_channel',
            'Downloads',
            channelDescription: 'Channel for file download notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }
}
