import 'package:core/core.dart';
import 'package:onesthrm/page/home/bloc/bloc.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';

class HomeInjection {
  Future<void> initInjection() async {
    instance.registerFactory<HomeBlocFactory>(() => () => HomeBloc(
        logoutUseCase: instance(),
        homeDatLoadUseCase: instance(),
        settingsDataLoadUseCase: instance(),
        eventBus: instance(),
        offlineAttendanceRepo: instance()));
  }
}
