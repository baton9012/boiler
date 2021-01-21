import 'package:boiler/screens/archive/archive_list.dart';
import 'package:boiler/screens/setteings/settings.dart';
import 'package:boiler/screens/tast_list/widgets/inherited_task_list.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

class SettingsButton extends StatelessWidget {
  List<String> choices;
  @override
  Widget build(BuildContext context) {
    choices = [
      AppLocalizations.of(context).translate('archive'),
      AppLocalizations.of(context).translate('settings')
    ];

    Map<String, IconData> iconData = {
      choices[0]: Icons.archive,
      choices[1]: Icons.settings
    };
    return PopupMenuButton(
      padding: EdgeInsets.all(8),
      initialValue: choices[1],
      itemBuilder: (BuildContext context) {
        return choices
            .map(
              (buttonTitle) => PopupMenuItem(
                child: FlatButton(
                  onPressed: () {
                    navigate(context, buttonTitle);
                  },
                  child: Row(
                    children: [
                      Icon(
                        iconData[buttonTitle],
                        color: Colors.black.withOpacity(0.7),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Text(buttonTitle),
                    ],
                  ),
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
