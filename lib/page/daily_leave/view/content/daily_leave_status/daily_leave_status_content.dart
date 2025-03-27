import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_bloc.dart';
import 'package:onesthrm/page/daily_leave/bloc/daily_leave_state.dart';
import 'package:onesthrm/page/daily_leave/view/content/daily_leave_status/daily_leave_approved.dart';
import 'package:onesthrm/page/daily_leave/view/content/daily_leave_status/daily_leave_pending.dart';
import 'package:onesthrm/page/daily_leave/view/content/daily_leave_status/daily_leave_reject.dart';
import 'package:onesthrm/page/daily_leave/view/content/daily_leave_status/daily_leave_select_employee.dart';
import 'package:onesthrm/page/leave/view/content/general_list_shimmer.dart';

class DailyLeaveStatusContent extends StatelessWidget {
  const DailyLeaveStatusContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    return BlocBuilder<DailyLeaveBloc, DailyLeaveState>(
        builder: (context, state) {
      if (state.status == NetworkStatus.loading) {
        return const GeneralListShimmer();
      } else if (state.status == NetworkStatus.success) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Select Employee =============
              Visibility(
                  visible: user?.user?.isHr == true,
                  child: const ApplyDailySelectEmployee()),

              /// Approved Leave ===============
              const DailyLeaveApproved(),

              /// pending Leave ===============
              const DailyLeavePending(),

              /// Rejected Leave ===============
              const DailyLeaveReject(),

              SizedBox(height: 20.h)
            ],
          ),
        );
      } else if (state.status == NetworkStatus.failure) {
        return Center(
          child: Text(
            "failed_to_load_leave_list".tr(),
            style: TextStyle(
                color: colorPrimary.withOpacity(0.4),
                fontSize: 18.sp,
                fontWeight: FontWeight.w500),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
