import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:notification/src/data/database_entities/notification_db_entity.dart';

class NotificationItem extends StatelessWidget {
  final NotificationDbEntity notification;
  final VoidCallback onTap;

  const NotificationItem({super.key, required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      tileColor: notification.seen ? null : Branding.colors.primaryLight.withOpacity(0.1),
      leading: notification.seen
          ? null
          : CircleAvatar(
              radius: 4.0,
              backgroundColor: Branding.colors.iconAccent,
            ),
      horizontalTitleGap: 0.0,
      title: HtmlWidget(
        notification.title,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlWidget(notification.description),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "${isoTimeAgoCustom(notification.date)} ",
            style: TextStyle(color: Colors.black54, fontSize: 11.r),
          )
        ],
      ),
    );
  }
}
