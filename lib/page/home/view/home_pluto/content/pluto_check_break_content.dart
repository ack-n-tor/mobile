import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/home/view/home_pluto/content/pluto_break_card.dart';
import 'package:onesthrm/page/home/view/home_pluto/content/pluto_checkin_out_card.dart';
import 'package:user_repository/user_repository.dart';

class PlutoCheckBreakContent extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const PlutoCheckBreakContent({super.key, required this.user, required this.dashboardModel, required this.settings});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 8.0,
        ),
        ///check-in-out card
        Expanded(child: PlutoCheckInOutCard(settings: settings, user: user, dashboardModel: dashboardModel)),
        ///breakTime
        Expanded(child: PlutoBreakCard(settings: settings, user: user, dashboardModel: dashboardModel)),
        const SizedBox(
          width: 8.0,
        ),
      ],
    );
  }
}
