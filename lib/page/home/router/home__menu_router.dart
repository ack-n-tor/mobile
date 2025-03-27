import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:notification/notification.dart';
import 'package:onesthrm/page/all_natification/view/notification_screen.dart';
import 'package:onesthrm/page/all_natification/view/pluto_notification_screen.dart';
import 'package:onesthrm/page/appointment/appoinment_list/view/appointment_screen.dart';
import 'package:onesthrm/page/attendance_report/view/pluto_attendance_report_page.dart';
import 'package:onesthrm/page/daily_leave/view/daily_leave_page.dart';
import 'package:onesthrm/page/daily_leave/view/pluto_daily_leave_page.dart';
import 'package:onesthrm/page/home/view/content/home_content_shimmer.dart';
import 'package:onesthrm/page/home/view/content/home_earth_content.dart';
import 'package:onesthrm/page/home/view/home_mars/content_mars/home_mars_content.dart';
import 'package:onesthrm/page/home/view/home_naptune/content_neptune/home_neptune_content.dart';
import 'package:onesthrm/page/home/view/home_pluto/content/home_pluto_content.dart';
import 'package:onesthrm/page/leave/view/leave_page.dart';
import 'package:onesthrm/page/meeting/view/meeting_page.dart';
import 'package:onesthrm/page/menu/view/menu_screen.dart';
import 'package:onesthrm/page/menu/view/pluto_menu_screen.dart';
import 'package:onesthrm/page/select_employee/content/employee_list_shimmer.dart';
import 'package:onesthrm/page/support/view/support_page.dart';
import 'package:onesthrm/page/visit/view/visit_page.dart';
import 'package:onesthrm/res/nav_utail.dart';


Widget chooseTheme() {
  final name = globalState.get(dashboardStyleId);
  switch (name) {
    case 'earth':
      return const HomeEarthContent();
    case 'neptune':
      return const HomeNeptuneContent();
    case 'mars':
      return const HomeMarsContent();
    case 'pluto':
      return const HomePlutoContent();
    default:
      return const HomeContentShimmer();
  }
}

Widget chooseMenu() {
  final name = globalState.get(dashboardStyleId);
  switch (name) {
    case 'pluto':
      return const PlutoMenuScreen();
    default:
      return const MenuScreen();
  }
}

Widget chooseNotification() {
  final name = globalState.get(dashboardStyleId);
  final notificationScreen = instance<NotificationsScreenFactory>();
  switch (name) {
    case 'pluto':
      return const PlutoNotificationScreen();
    case 'earth':
    case 'neptune':
    case 'mars':
      return notificationScreen();
    default:
      return const NotificationScreen();
  }
}

Widget chooseDailyLeave() {
  final name = globalState.get(dashboardStyleId);
  switch (name) {
    case 'pluto':
      return const PlutoDailyLeavePage();
    case 'earth':
    case 'neptune':
    case 'mars':
      return const DailyLeavePage();
    default:
      return const EmployeeListShimmer();
  }
}

void routeSlug(slugName, context) {
  switch (slugName) {
    case 'support':
      NavUtil.navigateScreen(context, const SupportPage());
    case 'support_ticket':
      NavUtil.navigateScreen(context, const SupportPage());
    case 'visit':
      NavUtil.navigateScreen(context, const VisitPage());
    case 'appointment':
      NavUtil.navigateScreen(context, const AppointmentScreen());
    case 'meeting':
      NavUtil.navigateScreen(context, const MeetingPage());
    default:
      if (kDebugMode) {
        print(slugName);
      }
      return debugPrint('default');
  }
}



void currentMonthRouteSlug(slugName, context,  settings, ) {


  switch (slugName) {
    case 'late_in':
      NavUtil.navigateScreen(context, PlutoAttendanceReportPage(settings: settings!));
    case 'absent':
      NavUtil.navigateScreen(context, PlutoAttendanceReportPage(settings: settings!));
    case 'leave':
      NavUtil.navigateScreen(context, const LeavePage());

    case 'visits':
      NavUtil.navigateScreen(context, const VisitPage());
    default:
      if (kDebugMode) {
        print(slugName);
      }
      return debugPrint('default');
  }
}

