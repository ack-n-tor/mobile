import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:meta_club_api/meta_club_api.dart';

class ComplainState extends Equatable {
  final NetworkStatus status;
  final NetworkStatus submitComplain;
  final ComplainData? complainData;
  final ComplainData? verbalWarningData;
  final List<ComplainReply> complainReplies;
  final Failure? failure;
  final String? date;
  final String? complainTo;
  final PhoneBookUser? employee;
  final String? document;
  final List<int> selectedIds;
  final List<String> selectedNames;

  const ComplainState(
      {this.status = NetworkStatus.initial,
      this.submitComplain = NetworkStatus.initial,
      this.complainData,
      this.verbalWarningData,
      this.failure,
      this.complainTo,
      this.date,
      this.employee,
      this.selectedIds = const [],
      this.selectedNames = const [],
      this.document,
      this.complainReplies = const []});

  ComplainState copyWith(
      {NetworkStatus? status,
      NetworkStatus? submitComplain,
      ComplainData? complainData,
      Failure? failure,
      String? date,
      String? complainTo,
      PhoneBookUser? employee,
      String? document,
      ComplainData? verbalWarningData,
      List<ComplainReply>? complainReplies,
      List<int>? selectedIds,
      List<String>? selectedNames}) {
    return ComplainState(
        status: status ?? this.status,
        submitComplain: submitComplain ?? this.submitComplain,
        complainData: complainData ?? this.complainData,
        failure: failure ?? this.failure,
        date: date ?? this.date,
        complainTo: complainTo ?? this.complainTo,
        employee: employee ?? this.employee,
        document: document ?? this.document,
        verbalWarningData: verbalWarningData ?? this.verbalWarningData,
        complainReplies: complainReplies ?? this.complainReplies,
        selectedNames: selectedNames ?? this.selectedNames,
        selectedIds: selectedIds ?? this.selectedIds);
  }

  @override
  List<Object?> get props => [
        status,
        submitComplain,
        date,
        complainTo,
        employee,
        document,
        verbalWarningData,
        complainReplies,
        selectedIds,
        selectedNames
      ];
}
