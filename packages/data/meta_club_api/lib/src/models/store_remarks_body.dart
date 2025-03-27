import 'package:core/core.dart';

class StoreRemarksBody {
  RemarkType type;
  String? remark;
  int? id;

  StoreRemarksBody({this.type = RemarkType.attendance, this.id, this.remark});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['type'] = type.type;
    map['id'] = id;
    map['remark'] = remark;
    return map;
  }
}
