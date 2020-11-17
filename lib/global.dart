import 'package:boiler/models/config.dart';
import 'package:flutter/material.dart';

Config config = Config();

final TextStyle standardTextStyle = TextStyle(
  fontSize: 17.0,
  color: Colors.black,
);
final TextStyle titleLabelStyle = TextStyle(
  fontSize: 17.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

String dateFormat({@required String date}) {
  String ymd = date.substring(0, 10);
  String dmy =
      ymd.substring(8) + '-' + ymd.substring(5, 7) + '-' + ymd.substring(0, 4);
  return dmy;
}
