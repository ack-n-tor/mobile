import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/login/login.dart';
import 'package:onesthrm/page/onboarding/bloc/onboarding_bloc.dart';
import 'package:onesthrm/page/splash/bloc/splash_state.dart';
import '../../../res/nav_utail.dart';
import 'package:user_repository/src/models/user.dart';

import '../../bottom_navigation/view/bottom_navigation_page.dart';
import '../../onboarding/view/onboarding_page.dart';

class SplashBloc extends Cubit<SplashState> {
  SplashBloc({required BuildContext context, LoginData? data}) : super(SplashState(context: context)) {
    initSplash(context, data);
  }

  void initSplash(BuildContext context, LoginData? data) {
    final company = context.read<OnboardingBloc>().state.selectedCompany;
    Future.delayed(const Duration(seconds: 2), () async {
      if (data?.user != null) {
        final navigator = instance<GlobalKey<NavigatorState>>().currentState!;
        navigator.pushAndRemoveUntil(BottomNavigationPage.route(), (route) => false);
      } else {
        if (company == null) {
          NavUtil.replaceScreen(context, const OnboardingPage());
        } else {
          NavUtil.replaceScreen(context, const LoginPage());
        }
      }
    });
  }
}
