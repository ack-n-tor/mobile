import 'package:flutter/foundation.dart';
import 'package:notification/notification.dart';

class AddNotificationUseCase {
  final NotificationManager notificationManager;

  AddNotificationUseCase({required this.notificationManager});

  void call(
      {required int id,
      required String title,
      required String description,
      String? date,
      bool isRead = false,
      required String payload}) {
    return notificationManager.createNotification(
        title: title, description: description, payload: payload, seen: isRead, date: date, id: id);
  }
}
