import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location_track/location_track.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/attendance.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ShowCurrentLocation extends StatelessWidget {
  final DashboardModel homeData;

  const ShowCurrentLocation({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: const Color(0xffB7E3E8),
          child: Padding(
            padding: EdgeInsets.all(8.0.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset('assets/images/map_marker_icon.json', height: 30.h, width: 30.w),
                Expanded(
                  child: Text(
                    context.read<AttendanceBloc>().state.location ?? instance<LocationServiceProvider>().place,
                    style:
                        GoogleFonts.lato(fontWeight: FontWeight.bold, fontSize: 12.r, color: const Color(0xFF404A58)),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 5.w,
                ),
                InkWell(
                  onTap: () async {
                    if (context.read<AttendanceBloc>().state.locationLoaded) {
                      context.read<AttendanceBloc>().add(OnLocationRefreshEvent());
                    }
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 10.r,
                        backgroundColor: colorPrimary,
                        child: Center(
                          child: context.read<AttendanceBloc>().state.locationLoaded
                              ? Lottie.asset(
                                  'assets/images/Refresh.json',
                                  height: 24.h,
                                  width: 24.w,
                                )
                              : const CircularProgressIndicator(),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        'refresh'.tr(),
                        style: TextStyle(fontSize: 12.r, color: colorPrimary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 16.h,
        ),
        Text("choose_your_remote_mode".tr(),
            style: GoogleFonts.nunitoSans(fontSize: 13.r, color: Colors.black87, fontWeight: FontWeight.bold)),
        SizedBox(
          height: 8.h,
        ),
        FutureBuilder<int?>(
          future: SharedUtil.getRemoteModeType(),
          builder: (context, snapshot) {
            return SizedBox(
              height: 40.0.h,
              child: ToggleSwitch(
                minWidth: 110.0.w,
                borderColor: const [
                  colorPrimary,
                ],
                borderWidth: 3,
                cornerRadius: 30.0,
                activeBgColors: const [
                  [Colors.white],
                  [Colors.white]
                ],
                activeFgColor: colorPrimary,
                inactiveBgColor: colorPrimary,
                inactiveFgColor: Colors.white,
                initialLabelIndex: snapshot.data,
                icons: const [FontAwesomeIcons.house, FontAwesomeIcons.building],
                totalSwitches: 2,
                fontSize: 14.r,
                iconSize: 17.r,
                labels: ['home'.tr(), 'office'.tr()],
                radiusStyle: true,
                onToggle: (index) {
                  /// RemoteModeType
                  /// 0 ==> Home
                  /// 1 ==> office
                  context.read<AttendanceBloc>().add(OnRemoteModeChanged(mode: index ?? 0));
                },
              ),
            );
          },
        )
      ],
    );
  }
}
