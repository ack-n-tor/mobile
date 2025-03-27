import 'package:equatable/equatable.dart';

class LeaveRequestTypeModel extends Equatable {
  final bool? result;
  final String? message;
  final LeaveRequestTypeAvailableLeave? leaveRequestType;

  const LeaveRequestTypeModel({
    this.result,
    this.message,
    this.leaveRequestType,
  });

  factory LeaveRequestTypeModel.fromJson(Map<String, dynamic> json) =>
      LeaveRequestTypeModel(
        result: json["result"],
        message: json["message"],
        leaveRequestType: json["data"] == null
            ? null
            : LeaveRequestTypeAvailableLeave.fromJson(json["data"]),
      );

  @override
  List<Object?> get props => [result, message, leaveRequestType];
}

class LeaveRequestTypeAvailableLeave extends Equatable {
  final List<AvailableLeaveType>? availableLeave;

  const LeaveRequestTypeAvailableLeave({
    this.availableLeave,
  });

  factory LeaveRequestTypeAvailableLeave.fromJson(Map<String, dynamic> json) =>
      LeaveRequestTypeAvailableLeave(
        availableLeave: json["available_leave"] == null
            ? []
            : List<AvailableLeaveType>.from(json["available_leave"]!
                .map((x) => AvailableLeaveType.fromJson(x))),
      );

  @override
  List<Object?> get props => [availableLeave];
}

class AvailableLeaveType extends Equatable {
  final int? id;
  final String? type;
  final int? totalLeave;
  final int? leftDays;

  const AvailableLeaveType({
    this.id,
    this.type,
    this.totalLeave,
    this.leftDays,
  });

  factory AvailableLeaveType.fromJson(Map<String, dynamic> json) =>
      AvailableLeaveType(
        id: json["id"],
        type: json["type"],
        totalLeave: json["total_leave"],
        leftDays: json["left_days"],
      );

  @override
  List<Object?> get props => [id, type, totalLeave, leftDays];
}
