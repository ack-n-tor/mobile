import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:meta_club_api/meta_club_api.dart';

class ComplainDetailsState extends Equatable {
  final NetworkStatus status;
  final NetworkStatus submitComplain;
  final List<ComplainReply> complainReplies;
  final bool writeExplanation;
  final bool? isAgree;
  final bool directTalkHR;
  final bool? isAppeal;

  const ComplainDetailsState(
      {this.status = NetworkStatus.initial,
      this.submitComplain = NetworkStatus.initial,
      this.writeExplanation = true,
      this.isAgree,
      this.directTalkHR = false,
      this.isAppeal = true,
      this.complainReplies = const []});

  ComplainDetailsState copyWith({
    NetworkStatus? status,
    NetworkStatus? submitComplain,
    bool? writeExplanation,
    bool? isAgree,
    bool? isAppeal,
    bool? directTalkHR,
    List<ComplainReply>? complainReplies,
  }) {
    return ComplainDetailsState(
      status: status ?? this.status,
      submitComplain: submitComplain ?? this.submitComplain,
      writeExplanation: writeExplanation ?? this.writeExplanation,
      complainReplies: complainReplies ?? this.complainReplies,
      isAgree: isAgree ?? this.isAgree,
      isAppeal: isAppeal ?? this.isAppeal,
      directTalkHR: directTalkHR ?? this.directTalkHR,
    );
  }

  @override
  List<Object?> get props => [
        status,
        submitComplain,
        complainReplies,
        writeExplanation,
        isAgree,
        isAppeal,
        directTalkHR,
      ];
}
