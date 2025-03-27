import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location_track/location_track.dart';
import 'package:lottie/lottie.dart';
import 'package:onesthrm/page/attendance/attendance.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/attendance/content/show_current_location.dart';
import 'package:onesthrm/page/attendance/content/show_current_time.dart';
import 'package:onesthrm/page/attendance_report/view/attendance_report_page.dart';
import 'package:onesthrm/res/dialogs/custom_dialogs.dart';
import 'package:onesthrm/res/nav_utail.dart';
import '../../attendance_report/view/content/attendance_daily_offline_report_content.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../../home/bloc/home_bloc.dart';
import 'animated_circular_button.dart';
import 'attendance_remarks_content.dart';
import 'check_in_check_out_time.dart';

class AttendanceView extends StatefulWidget {
  final AttendanceType attendanceType;

  const AttendanceView({super.key, required this.attendanceType});

  @override
  State<AttendanceView> createState() => _AttendanceState();
}

class _AttendanceState extends State<AttendanceView> with TickerProviderStateMixin {
  late AnimationController controller;
  late HomeBlocFactory homeBloc;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 3), animationBehavior: AnimationBehavior.preserve);
    homeBloc = instance<HomeBlocFactory>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    final homeData = homeBloc().state.dashboardModel;
    final settings = homeBloc().state.settings;
    final offlineAttendanceBloc = context.watch<OfflineCubit>();
    final offlineState = offlineAttendanceBloc.state;

    if (user?.user != null) {
      homeBloc().add(
          OnLocationRefresh(user: context.read<AuthenticationBloc>().state.data?.user, locationProvider: instance()));
    }

    return BlocListener<AttendanceBloc, AttendanceState>(
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state.checkData?.message != null &&
            state.actionStatus == ActionStatus.checkInOut &&
            state.status != NetworkStatus.loading) {
          showLoginDialog(
              context: context,
              message: '${user?.user?.name}',
              body: '${state.checkData?.message}',
              isSuccess: state.checkData?.checkInOut != null ? true : false);
        }
        if (state.actionStatus == ActionStatus.checkInOut && state.status == NetworkStatus.success) {
          NavUtil.navigateScreen(
              context,
              BlocProvider.value(
                value: context.read<AttendanceBloc>(),
                child: AttendanceRemarksContent(
                  attendanceId: state.checkData?.checkInOut?.id ?? 0,
                ),
              ));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'attendance'.tr(),
            style: TextStyle(fontSize: 18.r),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, AttendanceReportPage.route(settings: settings!));
                },
                child: Lottie.asset(
                  'assets/images/ic_report_lottie.json',
                  height: 40.h,
                  width: 40.w,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// Show Current Location and Remote mode ......
              if (homeData != null)
                ShowCurrentLocation(
                  homeData: homeData,
                ),

              /// Show Current time .......
              if (homeData != null) ShowCurrentTime(homeData: homeData),

              if (homeData != null)
                BlocBuilder<AttendanceBloc, AttendanceState>(builder: (context, state) {
                  return state.status == NetworkStatus.loading
                      ? RectangularCardShimmer(height: 184.h, width: 184.w)
                      : AnimatedCircularButton(
                          onComplete: () {
                            context.read<AttendanceBloc>().add(OnAttendance());
                          },
                          isCheckedIn: offlineState.isCheckedIn,
                          title: offlineState.isCheckedIn == false ? "check_in".tr() : "check_out".tr(),
                          color: offlineState.isCheckedIn == false ? Branding.colors.primaryLight : colorDeepRed,
                        );
                }),
              SizedBox(
                height: 15.h,
              ),

              /// Show Check In Check Out time
              const CheckInCheckOutTime(),
              SizedBox(height: 35.0.h),
              const AttendanceDailyOfflineReportContent(),
              SizedBox(height: 35.0.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    instance<LocationServiceProvider>().disposePlaceController();
    super.dispose();
  }
}
