import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

class SelectLanguageDialog extends StatefulWidget {
  @override
  _SelectLanguageDialogState createState() => _SelectLanguageDialogState();
}

class _SelectLanguageDialogState extends State<SelectLanguageDialog> {
  int selectedLanguage = 0;
  AppLocalizations appLocalizations;
  static List<String> _supportedLocale = ['ru', 'uk', 'en'];

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(appLocalizations.translate('select_language')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlatButton(
            minWidth: double.infinity,
            color: selectedLanguage == 0
                ? Colors.blue.withOpacity(0.5)
                : Colors.white,
            onPressed: () {
              setState(() {
                selectedLanguage = 0;
              });
            },
            child: Text('Русский'),
          ),
          FlatButton(
            minWidth: double.infinity,
            color: selectedLanguage == 1
                ? Colors.blue.withOpacity(0.5)
                : Colors.white,
            onPressed: () {
              setState(() {
                selectedLanguage = 1;
              });
            },
            child: Text('Українська'),
          ),
          FlatButton(
            minWidth: double.infinity,
            color: selectedLanguage == 2
                ? Colors.blue.withOpacity(0.5)
                : Colors.white,
            onPressed: () {
              setState(() {
                selectedLanguage = 2;
              });
            },
            child: Text('English'),
          ),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(selectedLanguage);
          },
          child: Text(appLocalizations.translate('save')),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(
                _supportedLocale.indexOf(appLocalizations.locale.languageCode));
          },
          child: Text(appLocalizations.translate('cancel')),
        ),
      ],
    );
  }
}
