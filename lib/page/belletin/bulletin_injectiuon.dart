import 'package:core/core.dart';

import 'bloc/bulletin_bloc.dart';

class BulletinInjection {
  Future<void> initInjection() async {
    instance.registerSingleton<BulletinBlocFactory>(() => BulletinBloc());
  }
}
