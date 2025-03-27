import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/all_natification/bloc/notification_bloc.dart';
import 'package:onesthrm/page/all_natification/content/notification_cart_content.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NotificationBloc(metaClubApiClient: MetaClubApiClient(httpService: instance()))
          ..add(LoadNotificationData()),
        child: BlocBuilder<NotificationBloc, NotificationState>(builder: (context, state) {
          if (state.status == NetworkStatus.loading) {
            return Scaffold(
              body: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (content, index) {
                    return TileShimmer(titleHeight: 55.0,);
                  },
                  itemCount: 10),
            );
          }

          return Scaffold(
              appBar: AppBar(
                title: Text(
                  tr("notifications"),
                  style: TextStyle(fontSize: 16.r),
                ),
                actions: [
                  Visibility(
                    visible: state.notificationResponse?.data?.notifications?.isNotEmpty ?? false,
                    // visible: true,
                    child: InkWell(
                      onTap: () {
                        context.read<NotificationBloc>().add(ClearNoticeButton());
                        context.read<NotificationBloc>().add(LoadNotificationData());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              tr("clear_all"),
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10.r),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  state.notificationResponse?.data?.notifications?.isNotEmpty == true
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: state.notificationResponse?.data?.notifications?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              final data = state.notificationResponse?.data?.notifications?[index];

                              return InkWell(
                                onTap: () {
                                  context.read<NotificationBloc>().add(RouteSlug(
                                      context: context,
                                      slugName: state.notificationResponse?.data?.notifications?[index].slag,
                                      data: state.notificationResponse));
                                },
                                child: NotificationCartContent(data: data),
                              );
                            },
                          ),
                        )
                      : const Expanded(child: NoDataFoundWidget())
                  // : const SizedBox(),
                ],
              ));
        }));
  }
}
