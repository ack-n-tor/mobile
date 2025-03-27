import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_state.dart';
import 'package:onesthrm/page/attendance_method/view/attendane_method_screen.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/home/bloc/bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class PlutoCheckInOutCard extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const PlutoCheckInOutCard({super.key, required this.settings, required this.user, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflineCubit, OfflineAttendanceState>(builder: (context, offlineState) {
      return Card(
        elevation: 2,
        color: Branding.colors.primaryLight,
        margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: InkWell(
            onTap: () {
              context.read<HomeBloc>().add(OnLocationRefresh(
                  user: context.read<AuthenticationBloc>().state.data?.user, locationProvider: instance()));

              Navigator.push(context, AttendanceMethodScreen.route(homeBloc: context.read<HomeBloc>()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16.0,
                  ),
                  Image.asset('assets/images/check-in.png', scale: 2, color: Colors.white),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(offlineState.isCheckedIn == false ? "start_time".tr() : "done_for_today".tr(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 14.r,
                              color: Colors.white,
                            )),
                        Text(
                          offlineState.isCheckedIn == false ? "check_in".tr() : "check_out".tr(),
                          style: TextStyle(color: Colors.white, fontSize: 14.r, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
            )),
      );
    });
  }
}
