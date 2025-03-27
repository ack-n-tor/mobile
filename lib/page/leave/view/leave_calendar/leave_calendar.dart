import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onesthrm/page/home/bloc/bloc.dart';
import 'package:onesthrm/page/leave/bloc/leave_bloc/leave_bloc.dart';
import 'package:onesthrm/page/leave/view/create_leave_request/create_leave_request.dart';
import 'package:onesthrm/res/nav_utail.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class LeaveCalendar extends StatelessWidget {
  final int? leaveRequestTypeId;

  const LeaveCalendar({super.key, this.leaveRequestTypeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaveBloc, LeaveState>(
      builder: (context, state) {
        final List<String> dates = [];
        final homeState = context.watch<HomeBloc>().state;

        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(DeviceUtil.isTablet ? 80 : 50),
            child: AppBar(
              iconTheme: IconThemeData(size: DeviceUtil.isTablet ? 40 : 30, color: Colors.white),
              title: Text(
                tr("request_leave"),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: DeviceUtil.isTablet ? 300.h : 300,
                child: SfDateRangePicker(
                  view: DateRangePickerView.month,
                  selectionColor: Colors.green,
                  showNavigationArrow: true,
                  toggleDaySelection: false,
                  enablePastDates: false,
                  selectionMode: homeState.settings?.data?.individualDayWiseLeave == true
                      ? DateRangePickerSelectionMode.multiple
                      : DateRangePickerSelectionMode.range,
                  onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
                    final formater = DateFormat('yyyy-MM-dd', 'en');
                    if (homeState.settings?.data?.individualDayWiseLeave == true) {
                      for (final argDate in args.value) {
                        String? date = formater.format(argDate).toString();
                        dates.add(date);
                      }
                    } else {
                      String? startDate = formater.format(args.value.startDate).toString();
                      String? endDate = formater.format(args.value.endDate ?? args.value.startDate).toString();
                      context.read<LeaveBloc>().add(SelectedCalendar(startDate, endDate, []));
                    }
                  },
                ),
              ),
              CustomHButton(
                  title: "next".tr(),
                  padding: 16,
                  clickButton: () {
                    if (homeState.settings?.data?.individualDayWiseLeave == true) {
                      context.read<LeaveBloc>().add(SelectedCalendar(null, null, dates));
                      NavUtil.replaceScreen(
                          context,
                          BlocProvider.value(
                              value: context.read<LeaveBloc>(),
                              child: CreateLeaveRequest(
                                leaveTypeId: leaveRequestTypeId,
                                starDate: state.startDate,
                                endDate: state.endDate,
                              )));
                    } else {
                      if (state.startDate == null) {
                        Fluttertoast.showToast(msg: "Please select Date");
                      } else {
                        NavUtil.replaceScreen(
                            context,
                            BlocProvider.value(
                                value: context.read<LeaveBloc>(),
                                child: CreateLeaveRequest(
                                  leaveTypeId: leaveRequestTypeId,
                                  starDate: state.startDate,
                                  endDate: state.endDate,
                                )));
                      }
                    }
                  })
            ],
          ),
        );
      },
    );
  }
}
