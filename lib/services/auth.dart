import 'package:boiler/global.dart';
import 'package:boiler/screens/login/login.dart';
import 'package:boiler/widgets/prepare_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final FirebaseAuth _firebaseAuthInstance = FirebaseAuth.instance;

  handleAuth() {
    return StreamBuilder(
      stream: _firebaseAuthInstance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return PrepareDbWidget(data: snapshot.data);
        } else {
          return LoginScreen();
        }
      },
    );
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
