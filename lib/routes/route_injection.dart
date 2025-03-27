import 'package:core/core.dart';
import 'package:onesthrm/routes/src/generate_routes.dart';

class RouteInjection {
  Future<void> initInjection() async {
    instance.registerSingleton<OnGeneratedRoutesFactory>(
        () => OnGeneratedRoutes(bottomNavigationFactory: instance(), splashScreenFactory: instance()));
  }
}
