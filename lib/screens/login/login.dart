import 'dart:async';

import 'package:boiler/global.dart';
import 'package:boiler/models/firebase_model.dart';
import 'package:boiler/screens/tast_list/task_list.dart';
import 'package:boiler/services/auth.dart';
import 'package:boiler/services/db_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:sms_autofill/sms_autofill.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with CodeAutoFill {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _phoneNumberController = TextEditingController(
    text: '+380',
  );
  String _phoneNumber = '';
  String _password = '';
  bool _isObscureText = true;
  String _verificationId;
  RegExp _phoneNumberRegExp = RegExp('^(?:[+0]9)?[0-9]{10}\$');
  Icon _passwordSuffixIcon = Icon(Icons.remove_red_eye_rounded);
  String appSignature = "LhCVFTY9uq2";
  String supText = '';

  @override
  void initState() {
    super.initState();
    listenForCode();
    if (isAndroid) {
      getPermission();
    }
    SmsAutoFill().getAppSignature.then((signature) {
      if (mounted) {
        setState(() {
          appSignature = signature;
        });
      }
    });
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 13,
                    keyboardType: TextInputType.phone,
                    validator: (phoneNumber) {
                      if (phoneNumber.length < 13) {
                        return 'Мало символов';
                      } else if (_phoneNumberRegExp.hasMatch(phoneNumber)) {
                        return 'Это не номер телефона';
                      }
                      return null;
                    },
                    onTap: () {
                      getPhoneNumber();
                    },
                    onChanged: (phoneNumber) {
                      if (phoneNumber.length == 13) {
                        _phoneNumber = _phoneNumberController.text;
                        isInBase();
                        timerForAutoInputPass();
                      }
                    },
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      labelText: 'Тел. номер',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFieldPinAutoFill(
                    currentCode: _password,
                    obscureText: _isObscureText,
                    codeLength: 6,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: _passwordSuffixIcon,
                        onPressed: () {
                          setState(() {
                            _isObscureText = !_isObscureText;
                            _passwordSuffixIcon = _isObscureText
                                ? Icon(Icons.remove_red_eye_rounded)
                                : Icon(Icons.remove_red_eye_outlined);
                          });
                        },
                      ),
                      prefixIcon: Icon(Icons.vpn_key),
                      labelText: 'Пароль',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Text(supText),
                  SizedBox(height: 16.0),
                  RaisedButton(
                    shape: OutlineInputBorder(
                      borderSide: BorderSide(
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      isInBase();
                      login();
                    },
                    child: Row(
                      children: [
                        Spacer(),
                        Text(
                          'Войти',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }

  void getPermission() async {
    if (!await MobileNumber.hasPhonePermission) {
      await MobileNumber.requestPhonePermission;
      hasPhonePermission = await MobileNumber.hasPhonePermission;
    }
  }

  void getPhoneNumber() async {
    if (hasPhonePermission == null) {
      hasPhonePermission = await MobileNumber.hasPhonePermission;
    }
    if (hasPhonePermission) {
      List<SimCard> simCards = await MobileNumber.getSimCards;
      print(simCards);
      if (simCards.isNotEmpty) {
        showDialog(
          barrierDismissible: false,
          context: context,
          child: FutureBuilder(
            future: MobileNumber.getSimCards,
            builder: (context, snapshot) => snapshot.hasData
                ? AlertDialog(
                    title: Text(
                      'Выберите рабочий номер телефона из списка',
                      style: titleLabelStyle,
                    ),
                    content: ListView.builder(
                        itemBuilder: (context, index) => ListTile(
                              title: Text(
                                '${simCards[index].number}',
                                style: titleLabelStyle,
                              ),
                              subtitle: Text(
                                '${simCards[index].slotIndex}',
                                style: standardTextStyle,
                              ),
                              onTap: () {
                                _phoneNumberController.text =
                                    simCards[index].number;
                                Navigator.of(context).pop();
                              },
                            )),
                  )
                : CircularProgressIndicator(),
          ),
        );
      } else {
        print("number ${await MobileNumber.getSimCards}");
      }
    }
  }

  void login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FutureBuilder(
              future: writeToSQLite(),
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
              }),
        ),
      );
    }
  }

  void timerForAutoInputPass() {
    Timer(Duration(seconds: 80), () {
      setState(() {
        supText = 'Введите пароль из смс';
      });
    });
  }

  Future<bool> writeToSQLite() async {
    List<FirebaseModel> firebaseModels =
        await FirebaseDBProvider.firebaseDB.getAllOrder();
    for (int i = 0; i < firebaseModels.length; i++) {
      if (firebaseModels[i].userId != userUid) {
        firebaseModels.removeAt(i);
        i--;
      }
    }
    return FirebaseModel().recordToSQLite(firebaseModels: firebaseModels);
  }

  Future<void> isInBase() async {
    final PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential authCredential) {
      if (_password.length == 6) {
        Auth().signIn(authCredential);
      }
    };

    final PhoneVerificationFailed phoneVerificationFailed =
        (FirebaseAuthException firebaseAuthException) {
      print('${firebaseAuthException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this._verificationId = verId;
      print(_verificationId);
    };

    final PhoneCodeAutoRetrievalTimeout phoneCodeAutoRetrievalTimeout =
        (String verId) {
      this._verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: Duration(seconds: 60),
      phoneNumber: _phoneNumber,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: phoneCodeAutoRetrievalTimeout,
    );
  }

  @override
  void codeUpdated() {
    setState(() {
      _password = code;
    });
  }
}
