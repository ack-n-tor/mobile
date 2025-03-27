import 'package:core/core.dart';
import 'package:onesthrm/page/writeup/bloc/complain/complain_bloc.dart';
import 'package:onesthrm/page/writeup/bloc/complain_details/complain_details_bloc.dart';
import 'bloc/verbal_wraning/verbal_warning_bloc.dart';

class WriteupAppInjection {
  Future<void> initInjection() async {
    instance.registerFactory<ComplainBlocFactory>(
        () => () => ComplainBloc(loadComplainUseCase: instance(), submitComplainUseCase: instance()));

    instance.registerFactory<ComplainDetailsBlocFactory>(
      () => () => ComplainDetailsBloc(loadComplainRepliesUseCase: instance(), submitComplainReplyUseCase: instance()),
    );

    instance.registerFactory<VerbalWarningBlocFactory>(
        () => () => VerbalWarningBloc(loadComplainUseCase: instance(), submitComplainUseCase: instance()));
  }
}
