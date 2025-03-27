class ComplainBody {
  final String? title;
  final String? date;
  final List<String>? complainTo;
  final int? employeeId;
  final String? description;
  final String? attachment;

  ComplainBody({this.title, this.date, this.complainTo, this.employeeId, this.description, this.attachment});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['date'] = date;
    map['complain_to'] = complainTo;
    map['user_id'] = employeeId;
    map["description"] = description;
    map["attachment"] = attachment;
    return map;
  }
}
