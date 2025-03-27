import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance_report/bloc/bloc.dart';
import 'package:onesthrm/page/attendance_report/view/content/content.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';

class AttendanceReportPage extends StatelessWidget {

  final Settings settings;

  const AttendanceReportPage({super.key, required this.settings});

  static Route route({required Settings settings}) {
    return MaterialPageRoute(
        builder: (_) => AttendanceReportPage(settings: settings));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    // final baseUrl = globalState.get(companyUrl);
    return user != null ? BlocProvider(
            create: (context) => AttendanceReportBloc(
                user: user, metaClubApiClient: MetaClubApiClient(httpService: instance()))
              ..add(GetAttendanceReportData()),
            child: BlocBuilder<AttendanceReportBloc, AttendanceReportState>(
              builder: (context, state) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('attendance_report'.tr()),
                    actions: [
                      IconButton(
                          onPressed: () {
                            context.read<AttendanceReportBloc>().add(SelectDatePicker(context));
                          },
                          icon:  Icon(Icons.calendar_month, size: 22.r,))
                    ],
                  ),
                  body: ListView(
                    children: [
                      AttendanceReportContent(
                        bloc: context.watch<AttendanceReportBloc>(),
                      ),
                      AttendanceDailyReportContent(
                        bloc: context.watch<AttendanceReportBloc>(),
                        user: user,
                        settings: settings,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        : const SizedBox.shrink();
  }
}
