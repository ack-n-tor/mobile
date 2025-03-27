import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/home/content/pluto_event_card.dart';
import 'package:onesthrm/page/home/router/home__menu_router.dart';
import 'package:onesthrm/page/menu/content/menu_profile.dart';
import 'package:user_repository/user_repository.dart';
import 'package:core/core.dart';

class PlutoHomeHeader extends StatelessWidget {
  final Settings? settings;
  final LoginData? user;
  final DashboardModel? dashboardModel;

  const PlutoHomeHeader({super.key, required this.settings, required this.user, required this.dashboardModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ColoredBox(
                  color: Branding.colors.primaryLight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        SizedBox(width: 8.0.w),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: MenuProfile(),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                    settings?.data?.timeWish?.wish ?? dashboardModel?.data?.config?.timeWish?.wish ?? '',
                                    style: TextStyle(fontSize: 14.r, color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  '${user?.user?.name}',
                                  style: TextStyle(
                                      fontSize: 14.r, fontWeight: FontWeight.bold, height: 1.5, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Image.asset('assets/images/notification.png', scale: 3),
                        SizedBox(width: 16.0.w),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16.0.h,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 8.0.h,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'today_summary'.tr(),
            style: TextStyle(fontSize: 16.r, fontWeight: FontWeight.bold, height: 1.5, letterSpacing: 0.5),
          ),
        ),
        SizedBox(
          height: 8.0.h,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(children: List.generate(
            dashboardModel?.data?.today?.length ?? 0,
            (index) => PlutoEventCard(
              data: dashboardModel?.data?.today![index],
              onPressed: () => routeSlug(dashboardModel?.data?.today![index].slug, context),
            ),
          )),
        ),
      ],
    );
  }
}
