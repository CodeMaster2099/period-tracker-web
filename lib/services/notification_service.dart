import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: android);
    await _plugin.initialize(initSettings);
  }

  Future<void> scheduleReminder(DateTime when, {String title = 'Cycle reminder', String body = 'Upcoming cycle event'}) async {
    final details = const NotificationDetails(
      android: AndroidNotificationDetails('cycle_channel', 'Cycle reminders', importance: Importance.high, priority: Priority.high),
    );
    await _plugin.zonedSchedule(
      when.millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      tz.TZDateTime.from(when, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
