import 'package:boiler/screens/tast_list/task_list.dart';
import 'package:flutter/material.dart';

import 'db/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBProvider.db.initDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SafeArea(child: TaskList()),
    );
  }
}
