import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/writeup/bloc/complain/complain_state.dart';

typedef ComplainBlocFactory = ComplainBloc Function();

class ComplainBloc extends Cubit<ComplainState> {
  final LoadComplainUseCase loadComplainUseCase;
  final SubmitComplainUseCase submitComplainUseCase;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final explanationController = TextEditingController();

  ComplainBloc(
      {required this.loadComplainUseCase,
      required this.submitComplainUseCase})
      : super(const ComplainState()) {
    _loadComplainData();
  }

  void _loadComplainData() async {
    emit(state.copyWith(status: NetworkStatus.loading));
    final data = await loadComplainUseCase();
    data.fold((l) {
      emit(state.copyWith(status: NetworkStatus.failure, failure: l));
    }, (r) {
      emit(state.copyWith(status: NetworkStatus.success, complainData: r));
    });
  }

  Future<bool> submitComplain({required BuildContext context}) async {
    emit(state.copyWith(status: NetworkStatus.loading));
    ComplainBody body = ComplainBody(
        title: titleController.text,
        description: descriptionController.text,
        employeeId: state.employee?.id,
        date: state.date,
        complainTo: [state.selectedIds.toList().join(',')],
        attachment: state.document);
    final data = await submitComplainUseCase(body: body);
    data.fold((l) {
      emit(state.copyWith(status: NetworkStatus.failure, failure: l));
    }, (r) {
      emit(ComplainState(status: NetworkStatus.success, complainData: state.complainData));
      titleController.clear();
      descriptionController.clear();
      _loadComplainData();
      Navigator.pop(context);
    });
    return true;
  }

  Future<bool> submitVerbalWarning({required BuildContext context}) async {
    emit(state.copyWith(status: NetworkStatus.loading));
    ComplainBody body = ComplainBody(
        title: titleController.text,
        description: descriptionController.text,
        employeeId: state.employee?.id,
        date: state.date,
        attachment: state.document);
    final data = await submitComplainUseCase(body: body, complain: false);
    data.fold((l) {
      emit(state.copyWith(status: NetworkStatus.failure, failure: l));
    }, (r) {
      emit(state.copyWith(status: NetworkStatus.success));
      Navigator.pop(context);
    });
    return true;
  }

  void onMemberIdSelected({required List<int> memberIds, required List<String> memberNames}) {
    emit(state.copyWith(selectedIds: memberIds, selectedNames: memberNames));
  }

  void onMemberRemoved({required List<String> names}) {
    emit(state.copyWith(selectedNames: names));
  }

  void onDateUpdated({required String date}) {
    emit(state.copyWith(date: date));
  }

  void onEmployeeSelected({required PhoneBookUser employee}) {
    emit(state.copyWith(employee: employee));
  }

  void onDocumentUpdated({String? document}) {
    emit(state.copyWith(document: document));
  }



}
