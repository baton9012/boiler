import 'package:boiler/global.dart';
import 'package:boiler/services/auth.dart';
import 'package:boiler/services/db_sqlite.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SQLiteDBProvider.db.initDB();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MainControl(
      updateLocal: updateLocal,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
          Locale('uk', 'UA')
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        locale: fromStringToLocale(),
        localeResolutionCallback: (locale, supportedLocales) {
          if (config.localeTitle == null) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                config.localeTitle = supportedLocale.languageCode;
                return supportedLocale;
              }
            }
            config.localeTitle = supportedLocales.first.languageCode;
            return supportedLocales.first;
          }
          return fromStringToLocale(choice: config.localeTitle);
        },
        home: Auth().handleAuth(),
      ),
    );
  }

  Locale fromStringToLocale({String choice}) {
    if (choice == null) {
      choice = config.localeTitle;
    }
    switch (choice) {
      case 'en':
        return Locale('en', 'US');
      case 'ru':
        return Locale('ru', 'RU');
      case 'uk':
        return Locale('uk', 'UA');
    }
  }

  void updateLocal() {
    setState(() {
      fromStringToLocale();
    });
  }
}

class MainControl extends InheritedWidget {
  final Function updateLocal;
  final Widget child;

  MainControl({this.updateLocal, this.child});

  static MainControl of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(MainControl);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
