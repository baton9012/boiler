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
  @override
  Widget build(BuildContext context) {
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
              'ФИО',
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
              'Город',
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
