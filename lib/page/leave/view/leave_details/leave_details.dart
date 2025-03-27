import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/leave/bloc/leave_bloc/leave_bloc.dart';
import 'package:onesthrm/page/leave/bloc/leave_details_bloc/leave_details_cubit.dart';
import 'package:onesthrm/page/leave/bloc/leave_details_bloc/leave_details_state.dart';
import 'package:onesthrm/page/leave/view/content/build_container.dart';
import 'package:onesthrm/page/leave/view/content/general_list_shimmer.dart';
import 'package:core/core.dart';
import 'package:onesthrm/page/leave/view/content/leave_status.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';

class LeaveDetails extends StatelessWidget {
  final int requestId;
  final int userId;

  const LeaveDetails({super.key, required this.requestId, required this.userId});

  @override
  @override
  Widget build(BuildContext context) {
    final leaveDetailsCubit = instance.get<LeaveDetailsCubitFactory>();
    return BlocProvider(
      create: (context) => leaveDetailsCubit(userId: userId, requestId: requestId),
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(DeviceUtil.isTablet ? 80 : 55),
            child: AppBar(
                iconTheme: IconThemeData(size: DeviceUtil.isTablet ? 40 : 30, color: Colors.white),
                title: Text(
                  "leave_details".tr(),
                  style: TextStyle(fontSize: DeviceUtil.isTablet ? 16.r : 14),
                ))),
        body: Builder(
          builder: (context) {
            return BlocBuilder<LeaveDetailsCubit, LeaveDetailsState>(
              builder: (context, state) {
                LeaveDetailsData? leaveDetailsData = state.leaveDetailsModel?.leaveDetailsData;
                if (state.status == NetworkStatus.loading && state.isCancelled == false) {
                  return const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: GeneralListShimmer());
                } else if (state.status == NetworkStatus.success || state.isCancelled == true) {
                  return Column(
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 26,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(width: 0.5, color: Colors.grey),
                                ),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: DeviceUtil.isTablet ? 130.w : 130,
                                      child: Text(
                                        tr("status"),
                                        style: TextStyle(fontSize: 14.r),
                                      )),
                                  LeaveStatus(
                                    leaveDetailsData: leaveDetailsData,
                                    isCancelled: state.isCancelled,
                                  )
                                ],
                              ),
                            ),
                            BuildContainer(title: tr("requested_on"), titleValue: leaveDetailsData?.requestedOn ?? ""),
                            BuildContainer(title: tr("type"), titleValue: leaveDetailsData?.type ?? ""),
                            BuildContainer(title: tr("period"), titleValue: leaveDetailsData?.period ?? ""),
                            BuildContainer(
                                title: tr("total_days"),
                                titleValue: '${leaveDetailsData?.totalDays ?? ""} ${tr("days")}'),
                            BuildContainer(
                              title: tr("note"),
                              titleValue: leaveDetailsData?.note ?? "",
                            ),
                            BuildContainer(
                              title: tr("substitute"),
                              titleValue: leaveDetailsData?.name ?? tr("add_substitute"),
                            ),
                            BuildContainer(
                              title: tr("approves"),
                              titleValue: leaveDetailsData?.apporover,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: DeviceUtil.isTablet ? 130.w : 130,
                                      child: Text(
                                        tr("attachment"),
                                        style: TextStyle(fontSize: 14.r),
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: CachedNetworkImage(
                                height: DeviceUtil.isTablet ? 200.w : 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: "${leaveDetailsData?.imageUrl}",
                                placeholder: (context, url) => Center(
                                  child: Image.asset("assets/images/placeholder_image.png"),
                                ),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                            const SizedBox(
                              height: 40.0,
                            ),
                          ],
                        ),
                      )),
                      if (state.isCancelled || leaveDetailsData?.status == LeaveStatusEnum.canceled)
                        Container(
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomHButton(
                              title: "leave_request_cancelled".tr(),
                              backgroundColor: Colors.red,
                              padding: 16,
                            ),
                          ),
                        ),
                      if (leaveDetailsData?.status == LeaveStatusEnum.pending && !state.isCancelled)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(0)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomHButton(
                              title: leaveDetailsData?.status?.status == "Cancel"
                                  ? "leave_request_cancelled".tr()
                                  : "cancel_leave_request".tr(),
                              backgroundColor: leaveDetailsData?.status?.status == "Cancel"
                                  ? Colors.red
                                  : Branding.colors.primaryDark,
                              padding: 16,
                              clickButton: () async {
                                await showDialog<void>(
                                    context: context,
                                    builder: (_) {
                                      return AlertDialog(
                                        backgroundColor: Colors.red,
                                        title: Text('Do you want to cancel leave request?'.tr(),
                                            style: TextStyle(
                                                fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.bold)),
                                        actions: [
                                          TextButton(
                                            child:
                                                Text('yes'.tr(), style: TextStyle(fontSize: 13.0, color: Colors.white)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              context.read<LeaveDetailsCubit>().cancelLeave(onCancelled: () {
                                                context.read<LeaveBloc>().add(LeaveRequest(userId));
                                              });
                                            },
                                          ),
                                          TextButton(
                                            child:
                                                Text('no'.tr(), style: TextStyle(fontSize: 13.0, color: Colors.white)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
