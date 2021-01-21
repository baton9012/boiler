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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      locale: fromStringtoLocale(),
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
        return fromStringtoLocale(choice: config.localeTitle);
      },
      home: Auth().handleAuth(),
    );
  }

  Locale fromStringtoLocale({String choice}) {
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
}
