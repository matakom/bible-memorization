import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    await _notificationsPlugin.initialize(settings: initSettings);
  }

  static Future<AppLocalizations> _getL10n() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString('language_code');

    Locale locale;
    if (savedCode != null) {
      locale = Locale(savedCode);
    } else {
      locale = WidgetsBinding.instance.platformDispatcher.locale;
    }

    return await AppLocalizations.delegate.load(locale);
  }

  /// Schedules a recurring daily review reminder for 7 PM local time.
  static Future<void> scheduleDailyReminder(bool hasPracticedToday) async {
    await _notificationsPlugin.cancelAll();
    final l10n = await _getL10n();

    final now = DateTime.now();
    DateTime scheduleDate = DateTime(now.year, now.month, now.day, 19, 0);

    if (hasPracticedToday || now.isAfter(scheduleDate)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    final tz.TZDateTime scheduledTZDate = tz.TZDateTime.from(
      scheduleDate,
      tz.local,
    );

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      title: l10n.notification_title,
      body: l10n.notification_body,
      scheduledDate: scheduledTZDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminders',
          channelDescription: 'Reminds you to practice your verses daily',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    await androidImplementation?.requestNotificationsPermission();
  }

  static Future<void> scheduleTestNotification() async {
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 5));
    final l10n = await _getL10n();

    await _notificationsPlugin.zonedSchedule(
      id: 999,
      title: l10n.notification_title,
      body: l10n.notification_body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          channelDescription: 'Used for testing alarm accuracy',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
