import 'dart:async';

import 'package:boiler/global.dart';
import 'package:boiler/services/auth.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:boiler/widgets/prepare_db.dart';
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
  AppLocalizations appLocalizations;
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
  String hintForPassword = '';
  String hintForPhoneNum = '';

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
    appLocalizations = AppLocalizations.of(context);
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
                        return appLocalizations.translate('few_characters');
                      } else if (_phoneNumberRegExp.hasMatch(phoneNumber)) {
                        return appLocalizations
                            .translate('this_is_not_a_phone_number');
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
                      labelText: appLocalizations.translate('phone_number'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        hintForPhoneNum,
                        style: hintTextStyle,
                        textAlign: TextAlign.start,
                      ),
                    ],
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
                      labelText: appLocalizations.translate('password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(hintForPassword, style: hintTextStyle),
                    ],
                  ),
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
                          appLocalizations.translate('enter'),
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
                      appLocalizations
                          .translate('select_phone_number_from_list'),
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
        setState(() {
          hintForPhoneNum = appLocalizations.translate('enter_phone_number');
        });
      }
    } else {
      setState(() {
        hintForPhoneNum = appLocalizations.translate('enter_phone_number');
      });
    }
  }

  void login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PrepareDbWidget(),
        ),
      );
    }
  }

  void timerForAutoInputPass() {
    if (mounted) {
      Timer(Duration(seconds: 80), () {
        setState(() {
          hintForPassword = appLocalizations.translate('enter_password_from_sms');
        });
      });
    }
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
