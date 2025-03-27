import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/belletin/bloc/bulletin_state.dart';

typedef BulletinBlocFactory = BulletinBloc Function();

class BulletinBloc extends Cubit<BulletinState> {

  BulletinBloc() : super(BulletinState()) {
    ///Initial load of headline
    loadHeadline();
    ///Periodically load of headline
    Timer.periodic(Duration(minutes: 10), (_) {
      loadHeadline();
    });
  }

  void loadHeadline() async {
    emit(state.copyWith(status: NetworkStatus.loading));
    await Future.delayed(Duration(seconds: 1));
    SharedUtil.getValue(bulletinKey).then((data) {
      emit(state.copyWith(status: NetworkStatus.success, headline: data));
    });
  }
}
