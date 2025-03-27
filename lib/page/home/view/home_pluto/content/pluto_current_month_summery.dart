import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';
import 'package:onesthrm/page/home/router/home__menu_router.dart';
import 'package:onesthrm/page/home/view/home_pluto/content/pluto_monthly_summery_card.dart';

class PlutoCurrentMonthSummeryContent extends StatelessWidget {
  final List<CurrentMonthData> monthsData;

  const PlutoCurrentMonthSummeryContent({super.key, required this.monthsData});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<HomeBloc>().state.settings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'current_month_summary'.tr(),
            style: TextStyle(
                fontSize: 16.r, fontWeight: FontWeight.bold, height: 1.5, color: Colors.black, letterSpacing: 0.5),
          ),
        ),
        SizedBox(
          height: 8.0.h,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
              children: List.generate(
            monthsData.length,
            (index) => PlutoMonthlyEventCard(
              data: monthsData[index],
              onPressed: () => currentMonthRouteSlug(monthsData[index].slug, context, settings ),
            ),
          )),
        ),
      ],
    );
  }
}
