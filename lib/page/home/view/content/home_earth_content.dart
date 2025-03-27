import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/home/content/home_bottom.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import '../../../authentication/bloc/authentication_bloc.dart';
import '../../bloc/home_bloc.dart';
import '../../content/break_card.dart';
import '../../content/checkin_out_card.dart';
import '../../content/home_header.dart';

class HomeEarthContent extends StatelessWidget {
  const HomeEarthContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        final user = context.read<AuthenticationBloc>().state.data;

        if (user?.user != null) {
          context.read<HomeBloc>().add(OnLocationEnabled(user: user!.user!, locationProvider: instance()));
        }

        return BlocBuilder<LanguageBloc, LanguageState>(
          builder: (context, state) {
            return ListView(
              children: [
                ///top-header
                HomeHeader(settings: homeState.settings, user: user, dashboardModel: homeState.dashboardModel),

                ///check-in-out card
                CheckInOutCard(settings: homeState.settings, user: user, dashboardModel: homeState.dashboardModel),

                ///breakTime
                BreakCard(settings: homeState.settings, user: user, dashboardModel: homeState.dashboardModel),

                ///bottom-header
                HomeBottom(settings: homeState.settings, user: user, dashboardModel: homeState.dashboardModel),
              ],
            );
          },
        );
      },
    );
  }
}
