import 'package:flutter/material.dart';

String _addZero(int dateTimeValue) {
  if (dateTimeValue < 10) {
    return '0$dateTimeValue';
  }
  return dateTimeValue.toString();
}

String formattedDate(DateTime? dateTime) {
  if (dateTime == null) return '';
  final day = _addZero(dateTime.day);
  final month = _addZero(dateTime.month);
  final year = dateTime.year;
  return '$day.$month.$year';
}

String formattedTime(TimeOfDay? time) {
  if (time == null) return '';
  final hour = _addZero(time.hour);
  final minutes = _addZero(time.minute);
  return '$hour:$minutes';
}

String formattedDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  final date = formattedDate(dateTime);
  final time = formattedTime(TimeOfDay.fromDateTime(dateTime));
  return '$date $time';
}
