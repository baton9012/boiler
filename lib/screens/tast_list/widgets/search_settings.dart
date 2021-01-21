import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

class SearchSetting extends StatefulWidget {
  var parentWidget;

  static const int SearchBYNLP = 0;
  static const int SearchBYCity = 1;

  SearchSetting({this.parentWidget});
  @override
  _SearchSettingState createState() => _SearchSettingState();
}

class _SearchSettingState extends State<SearchSetting> {
  AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FlatButton(
            onPressed: () {
              setState(() {
                widget.parentWidget.isSearchByNLP = true;
              });
            },
            color: widget.parentWidget.isSearchByNLP
                ? Colors.blue.shade900.withOpacity(0.5)
                : Colors.blue,
            child: Text(
              appLocalizations.translate('lnp'),
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ),
          FlatButton(
            color: widget.parentWidget.isSearchByNLP
                ? Colors.blue
                : Colors.blue.shade900.withOpacity(0.5),
            onPressed: () {
              setState(() {
                widget.parentWidget.isSearchByNLP = false;
              });
            },
            child: Text(
              appLocalizations.translate('city'),
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
