import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/home/view/home_pluto/content/pluto_current_month_summery.dart';
import 'package:onesthrm/page/home/view/home_pluto/content/upcoming_event_pluto.dart';
import 'package:user_repository/user_repository.dart';

class HomeBottom extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const HomeBottom(
      {super.key,
      required this.settings,
      required this.user,
      required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PlutoUpcomingEvent(),
        SizedBox(
          height: 8.0.h,
        ),
        if(dashboardModel?.data?.currentMonth?.isNotEmpty == true)...[
          PlutoCurrentMonthSummeryContent(monthsData: dashboardModel!.data!.currentMonth!),
          SizedBox(height: 12.0.h)
        ]
      ],
    );
  }
}
