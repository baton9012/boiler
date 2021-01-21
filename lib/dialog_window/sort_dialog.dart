import 'package:boiler/models/sotr_items.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class SortDialog extends StatefulWidget {
  final AppLocalizations local;

  SortDialog({this.local});

  @override
  _SortDialogState createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  List<SortItems> sortItems = List<SortItems>();
  int sortType = config.sortTypeId;

  @override
  void initState() {
    super.initState();
    sortItems = SortItems.getSortItems(widget.local);
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(appLocalizations.translate('select_default_sort')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlatButton(
              color:
                  sortType == 0 ? Colors.blue.withOpacity(0.5) : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Text(sortItems[0].title),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  sortType = 0;
                  config.sortTypeId = 0;
                });
              }),
          FlatButton(
              color:
                  sortType == 1 ? Colors.blue.withOpacity(0.5) : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Text(sortItems[1].title),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  sortType = 1;
                  config.sortTypeId = 1;
                });
              }),
          FlatButton(
              color:
                  sortType == 2 ? Colors.blue.withOpacity(0.5) : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Text(sortItems[2].title),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  sortType = 2;
                  config.sortTypeId = 2;
                });
              }),
          FlatButton(
              color:
                  sortType == 3 ? Colors.blue.withOpacity(0.5) : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Text(sortItems[3].title),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  sortType = 3;
                  config.sortTypeId = 3;
                });
              }),
          FlatButton(
              color:
                  sortType == 4 ? Colors.blue.withOpacity(0.5) : Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Text(sortItems[4].title),
                  ),
                ],
              ),
              onPressed: () {
                setState(() {
                  sortType = 4;
                  config.sortTypeId = 4;
                });
              }),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(appLocalizations.translate('save')),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(appLocalizations.translate('cancel')),
        ),
      ],
    );
  }
}
