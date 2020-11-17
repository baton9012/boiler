import 'package:boiler/models/sotr_items.dart';
import 'package:flutter/material.dart';

import '../../../global.dart';

class SortButton extends StatefulWidget {
  var parent;

  SortButton({this.parent});

  @override
  _SortButtonState createState() => _SortButtonState();
}

class _SortButtonState extends State<SortButton> {
  List<SortItems> sortItems = List<SortItems>();
  SortItems sortItem = SortItems();

  @override
  void initState() {
    super.initState();
    sortItems = sortItem.getSortItems();
  }

  @override
  Widget build(BuildContext context) {
    int selected = config.sort_type_id == null ? 0 : config.sort_type_id;
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
                              setState(() {
                                _selectedItem.value = sortItems[index];
                                config.sort_type_id = index;
                                widget.parent.s22ort(sort_type: index);
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
