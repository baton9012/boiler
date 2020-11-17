import 'package:boiler/dialog_window/select_language_dialog.dart';
import 'package:boiler/dialog_window/sort_dialog.dart';
import 'package:flutter/material.dart';

import '../../global.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text('Настройки'),
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
                title: Text('Сортировка по умолчанию'),
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
                subtitle: Text('Русский'),
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    child: SelectLanguageDialog(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String sortTitle() {
    switch (config.sort_type_id) {
      case 0:
        return 'Дота добавления';
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
}
