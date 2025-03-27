import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';
import 'package:onesthrm/page/home/router/home__menu_router.dart';
import 'package:core/core.dart';
import 'today_list_count_mars.dart';

class TodaySummaryListMars extends StatelessWidget {
  const TodaySummaryListMars({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardModel = context.read<HomeBloc>().state.dashboardModel;
    return dashboardModel?.data?.today != null
        ? Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: primaryBorderColor),
                borderRadius: BorderRadius.circular(18)),
            child: GridView.builder(
              padding: const EdgeInsets.all(12.0),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dashboardModel!.data!.today!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 4),
              ),
              itemBuilder: (_, int index) {
                final data = dashboardModel.data!.today![index];
                return TodayListCountMars(
                  onTap: () => routeSlug(data.slug, context),
                  image: "${data.image}",
                  title: "${data.title}",
                  count: "0${data.number}",
                );
              },
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: List.generate(
                  6,
                  (index) => RectangularCardShimmer(width: 160.0, height: 180.0),
                ),
              ),
            ),
          );
  }
}
