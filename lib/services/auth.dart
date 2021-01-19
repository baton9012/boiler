import 'package:boiler/global.dart';
import 'package:boiler/models/firebase_model.dart';
import 'package:boiler/screens/login/login.dart';
import 'package:boiler/screens/tast_list/task_list.dart';
import 'package:boiler/services/db_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;

  handleAuth() {
    return StreamBuilder(
      stream: _firebaseAuthInstance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
              future: getUserId(snapshot.data),
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
                          'Подготовка \nбазы данных',
                          style: h1Style,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
              });
        } else {
          return LoginScreen();
        }
      },
    );
  }

  Future<bool> getUserId(var data) async {
    userUid = data.uid;
    List<FirebaseModel> firebaseModels =
        await FirebaseDBProvider.firebaseDB.getAllOrder();
    for (int i = 0; i < firebaseModels.length; i++) {
      if (firebaseModels[i].userId != userUid) {
        firebaseModels.removeAt(i);
      }
    }
    return FirebaseModel().recordToSQLite(firebaseModels: firebaseModels);
  }

  signOut() {
    _firebaseAuthInstance.signOut();
  }

  signIn(AuthCredential authCredential) async {
    UserCredential userCredential =
        await _firebaseAuthInstance.signInWithCredential(authCredential);
    userUid = userCredential.user.uid;
  }
}
