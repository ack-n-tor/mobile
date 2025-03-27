part of 'daily_report_bloc.dart';

class DailyReportState extends Equatable {
  final NetworkStatus? status;
  final DailyReportListModel? dailyReportListModel;
  final String? reportDate;
  final String? startTime;
  final String? startTime24;
  final String? endTime;
  final String? endTime24;
  final int? rating;
  final int? fileId;
  final String? startMessage;
  final String? endMessage;
  final String? errorMsg;
  final String? pendingLeadsValue;
  final String? workedRecoveryValue;

  const DailyReportState(
      {this.status,
      this.dailyReportListModel,
      this.reportDate,
      this.startTime,
      this.startTime24,
      this.endTime,
      this.endTime24,
      this.errorMsg,
      this.rating,
      this.startMessage,
      this.endMessage,
      this.workedRecoveryValue,
      this.pendingLeadsValue,
      this.fileId});

  DailyReportState copyWith(
      {NetworkStatus? status,
      DailyReportListModel? dailyReportListModel,
      String? reportDate,
      String? endTime,
      String? endTime24,
      int? rating,
      int? fileId,
      String? errorMsg,
      String? startMessage,
      String? endMessage,
      String? pendingLeadsValue,
      String? workedRecoveryValue,
      String? startTime,String? startTime24}) {
    return DailyReportState(
        status: status ?? this.status,
        dailyReportListModel: dailyReportListModel ?? this.dailyReportListModel,
        reportDate: reportDate ?? this.reportDate,
        endTime: endTime ?? this.endTime,
        rating: rating ?? this.rating,
        endTime24: endTime24 ?? this.endTime24,
        startTime24: startTime24 ?? this.startTime24,
        errorMsg: errorMsg ?? this.errorMsg,
        startMessage: startMessage ?? this.startMessage,
        workedRecoveryValue: workedRecoveryValue ?? this.workedRecoveryValue,
        pendingLeadsValue: pendingLeadsValue ?? this.pendingLeadsValue,
        startTime: startTime ?? this.startTime,
        endMessage: endMessage ?? this.endMessage,
        fileId: fileId ?? this.fileId);
  }

  DailyReportState reset() => const DailyReportState();

  @override
  List<Object?> get props => [
        status,
        dailyReportListModel,
        reportDate,
        startTime,
        endTime,
        pendingLeadsValue,
        workedRecoveryValue,
        rating,
        startMessage,
        endTime,
        errorMsg,
        fileId
      ];
}
