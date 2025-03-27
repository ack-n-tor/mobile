import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:onesthrm/page/select_employee/content/employee_list_shimmer.dart';
import 'package:onesthrm/page/phonebook/phonebook.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class EmployeeList extends StatelessWidget {
  const EmployeeList({super.key});

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController = RefreshController(initialRefresh: false);

    return BlocListener<PhoneBookBloc, PhoneBookState>(
      listenWhen: (oldState, newState) => oldState != newState,
      listener: (context, state) {
        if (state.refreshStatus == PullStatus.loaded) {
          refreshController.refreshCompleted();
        }
      },
      child: BlocBuilder<PhoneBookBloc, PhoneBookState>(
          buildWhen: (oldState, newState) => oldState != newState,
          builder: (context, state) {
            if (state.status == NetworkStatus.success) {
              return state.phoneBookUsers?.length == null
                  ? Center(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/images/no_data_found.json', repeat: false, height: 200),
                        const Text(
                          'No Results',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ))
                  : SmartRefresher(
                      enablePullDown: false,
                      enablePullUp: true,
                      header: const WaterDropHeader(),
                      footer: CustomFooter(builder: (context, mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = const Text("pull up load");
                        } else if (mode == LoadStatus.loading) {
                          body = const CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = const Text("Load Failed!Click retry!");
                        } else if (mode == LoadStatus.canLoading) {
                          body = const Text("release to load more");
                        } else {
                          body = const Text("No more Data");
                        }
                        return SizedBox(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      }),
                      controller: refreshController,
                      onLoading: () {
                        context.read<PhoneBookBloc>().add(PhoneBookLoadMore());
                        refreshController.loadComplete();
                      },
                      onRefresh: () {
                        context.read<PhoneBookBloc>().add(PhoneBookLoadRefresh());
                      },
                      child: state.phoneBookUsers?.isNotEmpty == true
                          ? ListView.builder(
                              itemCount: state.phoneBookUsers?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () async {
                                    var allUserData = state.phoneBookUsers?[index];
                                    Navigator.pop(context, allUserData);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        state.phoneBookUsers?[index].name ?? "",
                                        style: TextStyle(fontSize: 14.r),
                                      ),
                                      subtitle: Text(
                                        state.phoneBookUsers?[index].designation ?? "",
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                      leading: ClipOval(
                                        child: CachedNetworkImage(
                                          height: DeviceUtil.isTablet ? 70 : 40,
                                          width: DeviceUtil.isTablet ? 70 : 40,
                                          fit: BoxFit.cover,
                                          imageUrl: "${state.phoneBookUsers?[index].avatar}",
                                          placeholder: (context, url) => Center(
                                            child: Image.asset("assets/images/placeholder_image.png"),
                                          ),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : RectangularCardShimmer(height: 184.h, width: 184.w));
            }
            if (state.status == NetworkStatus.failure) {
              return const Center(child: Text('Failed to load Appointment list'));
            }
            return const EmployeeListShimmer();
          }),
    );
  }
}
