class BodyCreateLeaveModel {
  int? userId;
  int? substituteId;
  int? assignLeaveId;
  String? applyDate;
  String? leaveFrom;
  String? leaveTo;
  String? reason;
  String? imageUrl;
  List<String> dates;

  BodyCreateLeaveModel(
      {this.userId,
      this.substituteId,
      this.assignLeaveId,
      this.applyDate,
      this.leaveFrom,
      this.leaveTo,
      this.reason,
      this.imageUrl,
      this.dates = const []});

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "substitute_id": substituteId,
        "assign_leave_id": assignLeaveId,
        "apply_date": applyDate,
        "leave_from": leaveFrom,
        "leave_to": leaveTo,
        "reason": reason,
        "dates": dates,
        "image_url": imageUrl
      };
}
