import 'package:boiler/models/sotr_items.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

import '../../../global.dart';

class SortButton extends StatefulWidget {
  final Function callBack;
  final AppLocalizations local;

  SortButton({this.callBack, this.local});

  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  List<SortItems> sortItems = List<SortItems>();

  @override
  void initState() {
    super.initState();
    sortItems = SortItems.getSortItems(widget.local);
  }

  @override
  Widget build(BuildContext context) {
    int selected = config.sortTypeId == null ? 0 : config.sortTypeId;
    ValueNotifier<SortItems> _selectedItem =
        new ValueNotifier<SortItems>(sortItems[selected]);
    return PopupMenuButton<SortItems>(
        icon: Icon(Icons.sort),
        onSelected: (selectedItem) {},
        itemBuilder: (BuildContext context) {
          return List<PopupMenuEntry<SortItems>>.generate(sortItems.length,
              (int index) {
            return PopupMenuItem(
              value: sortItems[selected],
              child: AnimatedBuilder(
                  animation: _selectedItem,
                  builder: (context, child) {
                    return Row(
                      children: <Widget>[
                        Expanded(child: Text(sortItems[index].title)),
                        Radio(
                            activeColor: Colors.blue,
                            value: sortItems[index],
                            groupValue: _selectedItem.value,
                            onChanged: (item) {
                              _selectedItem.value = sortItems[index];
                              config.sortTypeId = index;
                              setState(() {
                                widget.callBack(sortType: index);
                              });
                            }),
                      ],
                    );
                  }),
            );
          });
        });
  }
}
