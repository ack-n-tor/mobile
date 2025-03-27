import 'package:core/core.dart';
import 'package:onesthrm/page/bottom_navigation/view/bottom_navigation_page.dart';

class BottomNavInjection {
  Future<void> initInjection() async {
    instance.registerSingleton<BottomNavigationFactory>(() => BottomNavigationPage(homeBlocFactor: instance()));
  }
}
