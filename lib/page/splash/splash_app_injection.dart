import 'package:core/core.dart';
import 'package:onesthrm/page/splash/view/splash.dart';

class SplashInjection {
  Future<void> initInjection() async {
    instance.registerSingleton<SplashScreenFactory>(() => const SplashScreen());
  }
}
