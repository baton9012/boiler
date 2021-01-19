import 'package:boiler/global.dart';
import 'package:boiler/screens/login/login.dart';
import 'package:boiler/screens/tast_list/task_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;

  handleAuth() {
    print('${_firebaseAuthInstance.authStateChanges()}');
    return StreamBuilder(
      stream: _firebaseAuthInstance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          getUserId(snapshot.data);
          return TaskList();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  void getUserId(var data) async {
    userUid = data.uid;
  }

  signOut() {
    _firebaseAuthInstance.signOut();
  }

  signIn(AuthCredential authCredential) async {
    print('signin ${authCredential.toString()}');
    UserCredential userCredential =
        await _firebaseAuthInstance.signInWithCredential(authCredential);
    userUid = userCredential.user.uid;
  }
}
