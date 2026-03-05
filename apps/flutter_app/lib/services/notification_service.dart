import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. Initialize timezones (Crucial for 7 PM local time)
    tz.initializeTimeZones();

    // 2. Setup native settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    // FIX 1: 'initialize' now requires a named parameter. 
    // Depending on your exact minor version of the package, it might ask for `settings:` instead of `initializationSettings:`. 
    // If you get an error here, simply change `initializationSettings:` to `settings:`
    await _notificationsPlugin.initialize(
      settings: initSettings,
    );
  }

  /// Calculates the next 7 PM and schedules the reminder
  static Future<void> scheduleDailyReminder(bool hasPracticedToday) async {
    // Cancel any existing reminders so we don't spam the user
    await _notificationsPlugin.cancelAll();

    final now = DateTime.now();
    
    // Create a target time of 7:00 PM (19:00) today
    DateTime scheduleDate = DateTime(now.year, now.month, now.day, 19, 0);

    // If they already practiced today, OR if it's currently past 7 PM, 
    // push the notification to 7:00 PM tomorrow.
    if (hasPracticedToday || now.isAfter(scheduleDate)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(scheduleDate, tz.local);

    // FIX 2: zonedSchedule now requires ALL arguments to be named.
    // FIX 3: uiLocalNotificationDateInterpretation was safely removed.
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
    // Request permission for Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidImplementation?.requestNotificationsPermission();
    
    // iOS permissions are usually requested automatically by the 
    // DarwinInitializationSettings we set up earlier, but you can explicitly call it here if needed.
  }

  static Future<void> scheduleTestNotification() async {
  final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));

  await _notificationsPlugin.zonedSchedule(
    id: 999, // Unique ID for test
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
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // Uses your Exact Alarm permission
  );
}

}