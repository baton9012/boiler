import 'package:boiler/screens/tast_list/task_list.dart';
import 'package:boiler/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _phoneNumber = '';
  bool _isObscureText = true;
  String _verificationId;
  RegExp _phoneNumberRegExp = RegExp('^(?:[+0]9)?[0-9]{10}\$');
  Icon _passwordSuffixIcon = Icon(Icons.remove_red_eye_rounded);

  @override
  void initState() {
    super.initState();
    _phoneNumberController.text = '+380';
    _phoneNumber = '';
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
                    onChanged: (phoneNumber) {
                      if (phoneNumber.length == 13) {
                        _phoneNumber = _phoneNumberController.text;
                        isInBase();
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
                  TextFormField(
                    keyboardType: TextInputType.number,
                    obscureText: _isObscureText,
                    controller: _passwordController,
                    validator: (password) {
                      if (password.length < 6) {
                        return 'Введите пароль из смс';
                      }
                      return null;
                    },
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

  void login() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            print('navigate');
            return TaskList();
          },
        ),
      );
    }
  }

  Future<void> isInBase() async {
    final PhoneVerificationCompleted phoneVerificationCompleted =
        (AuthCredential authCredential) {
      if (_passwordController.text.length == 6) {
        print('signin');
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
}
