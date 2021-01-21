import 'package:boiler/services/db_sqlite.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatefulWidget {
  final int type;
  final String id;

  const DeleteDialog({
    this.type,
    this.id,
  });

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(setTitle()),
      content: Text(setContent()),
      actions: [
        FlatButton(
          onPressed: () {
            onPress();
            Navigator.of(context).pop(true);
          },
          child: Text(setTitle()),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(appLocalizations.translate('cancel')),
        ),
      ],
    );
  }

  String setTitle() {
    if (widget.type == 0) {
      return appLocalizations.translate('delete');
    } else if (widget.type == 1) {
      return appLocalizations.translate('archive_task');
    } else {
      return appLocalizations.translate('unarchive_task');
    }
  }

  String setContent() {
    if (widget.type == 0) {
      return '${appLocalizations.translate('ask_delete_task')} ${widget.id}';
    } else if (widget.type == 1) {
      return '${appLocalizations.translate('ask_archive_task')} ${widget.id}';
    } else {
      return '${appLocalizations.translate('ask_unarchive_task')} ${widget.id}';
    }
  }

  void onPress() {
    if (widget.type == 0) {
      SQLiteDBProvider.db.deleteTask(widget.id);
    } else if (widget.type == 1) {
      SQLiteDBProvider.db.archiveTask(widget.id);
    } else {
      SQLiteDBProvider.db.unarchive(widget.id);
    }
  }
}
