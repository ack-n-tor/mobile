import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


DateTime getDateTimeFromTimestamp(int timestamp) {
  return DateTime.fromMillisecondsSinceEpoch(timestamp);
}

Future<Duration?> getSyncDuration() async {
  final second =  await SharedUtil.getValue(breakTime);
  final duration = second != null ? getDuration(int.parse(second)) : null;
  return duration;
}

///return duration from current date time(by difference)
///we get how many days hours minutes seconds spanned from now
Duration getDuration(int timestamp) {
  var now = DateTime.now();
  var date = getDateTimeFromTimestamp(timestamp);
  return now.difference(date);
}
String get24HTime({String format = 'HH:mm', required String? timeOfDay}) {
  if (timeOfDay == null) return '';

  try {
    final DateTime parsedTime = DateFormat('HH:mm A').parse(timeOfDay);
    return DateFormat(format).format(parsedTime);
  } catch (e) {
    try{
      final DateTime parsedTime = DateFormat('hh:mm a').parse(timeOfDay);
      return DateFormat(format).format(parsedTime);
    }catch(_){
      return '';
    }
  }
}

bool isStartTimeBeforeEndTime(TimeOfDay startTime, TimeOfDay endTime) {
  final int startMinutes = startTime.hour * 60 + startTime.minute;
  final int endMinutes = endTime.hour * 60 + endTime.minute;
  return startMinutes < endMinutes;
}