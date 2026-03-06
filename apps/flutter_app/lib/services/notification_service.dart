import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Handles local notification scheduling, permission requests, and timezone initialization.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
    );
  }

  /// Schedules a recurring daily review reminder for 7 PM local time.
  static Future<void> scheduleDailyReminder(bool hasPracticedToday) async {
    await _notificationsPlugin.cancelAll();

    final now = DateTime.now();
    DateTime scheduleDate = DateTime(now.year, now.month, now.day, 19, 0);

    if (hasPracticedToday || now.isAfter(scheduleDate)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduleDate, tz.local);

    await _notificationsPlugin.zonedSchedule(
      id: 0, 
      title: 'Time to practice!', 
      body: 'Keep your streak alive! Review your Bible verses for today.', 
      scheduledDate: scheduledTZDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Reminds you to practice your verses daily',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> scheduleTestNotification() async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

    await _notificationsPlugin.zonedSchedule(
      id: 999,
      title: 'Test Notification',
      body: 'This notification was scheduled 10 seconds ago!',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Used for testing alarm accuracy',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}