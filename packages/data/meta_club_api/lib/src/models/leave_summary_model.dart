import 'package:equatable/equatable.dart';

class LeaveSummaryModel extends Equatable {
  final bool? result;
  final String? message;
  final LeaveSummaryData? leaveSummaryData;

  const LeaveSummaryModel({
    this.result,
    this.message,
    this.leaveSummaryData,
  });

  factory LeaveSummaryModel.fromJson(Map<String, dynamic> json) =>
      LeaveSummaryModel(
        result: json["result"],
        message: json["message"],
        leaveSummaryData: json["data"] == null
            ? null
            : LeaveSummaryData.fromJson(json["data"]),
      );

  @override
  List<Object?> get props => [result, message, leaveSummaryData];
}

class LeaveSummaryData extends Equatable {
  final int? totalLeave;
  final int? totalUsed;
  final int? leaveBalance;
  final List<AvailableLeave>? availableLeave;

  const LeaveSummaryData({
    this.totalLeave,
    this.totalUsed,
    this.leaveBalance,
    this.availableLeave,
  });

  factory LeaveSummaryData.fromJson(Map<String, dynamic> json) =>
      LeaveSummaryData(
          totalLeave: json["total_leave"],
          totalUsed: json["total_used"],
          leaveBalance: json["leave_balance"],
          availableLeave: json["available_leave"] == null
              ? []
              : (json["available_leave"] as List)
                  .map((e) => AvailableLeave.fromJson(e))
                  .toList());

  @override
  List<Object?> get props =>
      [totalLeave, totalUsed, leaveBalance, availableLeave];
}

class AvailableLeave extends Equatable {
  final int? id;
  final String? type;
  final int? totalLeave;
  final int? leftDays;

  const AvailableLeave({
    this.id,
    this.type,
    this.totalLeave,
    this.leftDays,
  });

  factory AvailableLeave.fromJson(Map<String, dynamic> json) => AvailableLeave(
        id: json["id"],
        type: json["type"],
        totalLeave: json["total_leave"],
        leftDays: json["left_days"],
      );

  @override
  List<Object?> get props => [id, type, totalLeave, leftDays];
}
