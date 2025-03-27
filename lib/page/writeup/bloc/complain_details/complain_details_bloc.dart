import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/writeup/bloc/complain_details/complain_details_state.dart';

typedef ComplainDetailsBlocFactory = ComplainDetailsBloc Function();

class ComplainDetailsBloc extends Cubit<ComplainDetailsState> {
  final LoadComplainRepliesUseCase loadComplainRepliesUseCase;
  final SubmitComplainReplyUseCase submitComplainReplyUseCase;

  final explanationController = TextEditingController();

  ComplainDetailsBloc({required this.loadComplainRepliesUseCase, required this.submitComplainReplyUseCase})
      : super(ComplainDetailsState());

  void loadComplainReplies({required int complainId, NetworkStatus submitComplain = NetworkStatus.loading}) async {
    emit(state.copyWith(submitComplain: submitComplain));
    final data = await loadComplainRepliesUseCase(complainId: complainId);
    data.fold((l) {
      emit(state.copyWith(submitComplain: NetworkStatus.failure));
    }, (r) {
      emit(state.copyWith(complainReplies: r, submitComplain: NetworkStatus.success));
    });
  }

  void submitComplainReply({required int complainId}) async {
    emit(state.copyWith(submitComplain: NetworkStatus.loading));
    ComplainReplyBody complainReplyBody = ComplainReplyBody(
        isReply: state.complainReplies.isNotEmpty ? 1 : 0,
        explanation: (state.writeExplanation == true || state.isAgree == false || state.directTalkHR == false)
            ? explanationController.text.isNotEmpty
                ? explanationController.text
                : 'Agreed'
            : 'Direct talk with HR',
        isAppeal: (state.complainReplies.isEmpty || state.isAppeal == true) ? 1 : 0);

    final data = await submitComplainReplyUseCase(body: complainReplyBody, complainId: complainId);
    data.fold((l) {
      emit(state.copyWith(submitComplain: NetworkStatus.failure));
    }, (r) {
      loadComplainReplies(complainId: complainId, submitComplain: NetworkStatus.success);
      explanationController.clear();
    });
  }

  void onExplanation({required bool isExplain}) {
    emit(state.copyWith(writeExplanation: isExplain));
  }

  void onAppeal({bool isAppeal = true}) {
    emit(state.copyWith(isAppeal: isAppeal, isAgree: !isAppeal));
  }

  void onDirectHR({required bool directHR}) {
    emit(state.copyWith(directTalkHR: directHR));
  }
}
