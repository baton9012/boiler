import 'package:boiler/dialog_window/select_language_dialog.dart';
import 'package:boiler/dialog_window/sort_dialog.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

import '../../global.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(appLocalizations.translate('settings')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.sort,
                color: Colors.black87,
                size: 32.0,
              ),
              title: Text(appLocalizations.translate('sort_by_default')),
              subtitle: Text(sortTitle()),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: SortDialog(),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.language,
                color: Colors.black87,
                size: 32.0,
              ),
              title: Text('Язык'),
              subtitle: Text(languageTitle()),
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  child: SelectLanguageDialog(),
                ).then((value) => updateLanguage(value));
              },
            ),
          ],
        ),
      ),
    );
  }

  String sortTitle() {
    switch (config.sortTypeId) {
      case 0:
        return 'Дата добавления';
      case 1:
        return 'Тип работы';
      case 2:
        return 'Имя заказчика';
      case 3:
        return 'Статус';
      case 4:
        return 'Населенный пункт';
      default:
        return '';
    }
  }

  String languageTitle() {
    switch (config.localeTitle) {
      case 'ru':
        return "Русский";
      case 'uk':
        return "Українська";
      default:
        return "English";
    }
  }

  void updateLanguage(value) {
    setState(() {
      switch (value) {
        case 0:
          config.localeTitle = "ru";
          break;
        case 1:
          config.localeTitle = "uk";
          break;
        default:
          config.localeTitle = "en";
      }
    });
  }
}
