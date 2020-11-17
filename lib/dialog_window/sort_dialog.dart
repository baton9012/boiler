import 'package:boiler/models/sotr_items.dart';
import 'package:flutter/material.dart';

import '../global.dart';

class SortDialog extends StatefulWidget {
  @override
  _SortDialogState createState() => _SortDialogState();
}

class _SortDialogState extends State<SortDialog> {
  List<SortItems> sortItems = List<SortItems>();
  SortItems sortItem = SortItems();
  int sortType = config.sort_type_id;

  @override
  void initState() {
    super.initState();
    sortItems = sortItem.getSortItems();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Выберите сортировку по умочанию'),
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
                  config.sort_type_id = 0;
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
                  config.sort_type_id = 1;
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
                  config.sort_type_id = 2;
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
                  config.sort_type_id = 3;
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
                  config.sort_type_id = 4;
                });
              }),
        ],
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Сохранить'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Отмена'),
        ),
      ],
    );
  }
}
