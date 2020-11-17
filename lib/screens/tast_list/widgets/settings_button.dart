import 'package:boiler/screens/archive/archive_list.dart';
import 'package:boiler/screens/setteings/settings.dart';
import 'package:boiler/screens/tast_list/widgets/inherited_task_list.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  List<String> choices = ['Архив', 'Настройки'];
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      elevation: 3.0,
      initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        return choices
            .map(
              (buttonTitle) => PopupMenuItem(
                child: FlatButton(
                  onPressed: () {
                    navigate(context, buttonTitle);
                  },
                  child: Text(buttonTitle),
                ),
              ),
            )
            .toList();
      },
    );
  }

  void navigate(BuildContext context, String buttonTitle) {
    if (buttonTitle == choices[1]) {
      Navigator.of(context)
          .push(
            MaterialPageRoute(
              builder: (context) => Settings(),
            ),
          )
          .then((value) => Navigator.of(context).pop());
    } else {
      Navigator.of(context)
          .push(
        MaterialPageRoute(
          builder: (context) => ArchiveList(),
        ),
      )
          .then((value) {
        if (value) {
          InheritedTaskList.of(context).updateTaskList();
        }
        Navigator.of(context).pop();
      });
    }
  }
}
