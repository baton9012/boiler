import 'package:boiler/global.dart';
import 'package:boiler/models/firebase_model.dart';
import 'package:boiler/screens/tast_list/task_list.dart';
import 'package:boiler/services/db_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrepareDbWidget extends StatelessWidget {
  final User data;

  PrepareDbWidget({this.data});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserId(data),
        builder: (context, snapshotData) {
          if (snapshotData.hasData) {
            return TaskList();
          } else {
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircularProgressIndicator(),
                  Text(
                    'Подготовка',
                    style: h1Style,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        });
  }

  Future<bool> getUserId(var data) async {
    if (data != null) {
      userUid = data.uid;
    }
    List<FirebaseModel> firebaseModels =
        await FirebaseDBProvider.firebaseDB.getAllOrder();
    for (int i = 0; i < firebaseModels.length; i++) {
      if (firebaseModels[i].userId != userUid) {
        firebaseModels.removeAt(i);
      }
    }
    return FirebaseModel().recordToSQLite(firebaseModels: firebaseModels);
  }
}
