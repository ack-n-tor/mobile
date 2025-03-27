import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/break/break_route.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class PlutoBreakCard extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const PlutoBreakCard({super.key, required this.settings, required this.user, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Branding.colors.primaryLight,
      margin: EdgeInsets.symmetric(vertical: 8.0.h, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
          onTap: () {
            BreakRoute.breakOrQrCompanyRoute(context: context, inBreak: globalState.get(isBreak) == true);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                const SizedBox(
                  width: 16.0,
                ),
                Image.asset('assets/images/break.png', scale: 2, color: Colors.white),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          globalState.get(isBreak) == true ? "you're_in_break".tr()
                              : "take_coffee".tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.white, fontSize: 14.r)),
                      // SizedBox(height: 10.h),
                      Text(
                        globalState.get(isBreak) == true ? dashboardModel?.data?.config?.breakStatus?.breakTime ?? ''
                            : 'break'.tr(),
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
  }
}
