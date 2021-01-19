import 'dart:io';

import 'package:boiler/models/config.dart';
import 'package:flutter/material.dart';

Config config = Config();

final TextStyle standardTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);
final TextStyle titleLabelStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);
final TextStyle h1Style = TextStyle(
  fontSize: 32.0,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  decoration: TextDecoration.none,
  letterSpacing: 2.0,
);

String dateFormat({@required String date}) {
  String ymd = date.substring(0, 10);
  String dmy =
      ymd.substring(8) + '-' + ymd.substring(5, 7) + '-' + ymd.substring(0, 4);
  return dmy;
}

bool isAndroid = Platform.isAndroid;
bool hasPhonePermission;
String userUid;
