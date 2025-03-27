import 'package:flutter/material.dart';
import 'package:onesthrm/page/bottom_navigation/view/bottom_navigation_page.dart';
import 'package:onesthrm/page/splash/view/not_found_screen.dart';
import 'package:onesthrm/page/splash/view/splash.dart';
import 'package:onesthrm/routes/src/route.dart';

typedef OnGeneratedRoutesFactory = OnGeneratedRoutes Function();

class OnGeneratedRoutes {
  final BottomNavigationFactory bottomNavigationFactory;
  final SplashScreenFactory splashScreenFactory;

  OnGeneratedRoutes({required this.bottomNavigationFactory, required this.splashScreenFactory});

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.initial:
        return MaterialPageRoute(builder: (context) => splashScreenFactory());
      case Routes.bottomNavigation:
        return MaterialPageRoute(builder: (context) => bottomNavigationFactory());
      default:
        return MaterialPageRoute(builder: (context) => const NotFoundScreen());
    }
  }
}
