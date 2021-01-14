import 'package:boiler/services/db.dart';
import 'package:flutter/material.dart';

class DeleteDialog extends StatefulWidget {
  final int type;
  final int id;

  const DeleteDialog({
    this.type,
    this.id,
  });

  @override
  _DeleteDialogState createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
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
          child: Text('Отмена'),
        ),
      ],
    );
  }

  String setTitle() {
    if (widget.type == 0) {
      return 'Удалить';
    } else if (widget.type == 1) {
      return 'Архивировать';
    } else {
      return 'Разархивировать';
    }
  }

  String setContent() {
    if (widget.type == 0) {
      return 'Вы уверены что хоте удалить задачу №${widget.id}';
    } else if (widget.type == 1) {
      return 'Вы уверены что хоте архивировать задачу №${widget.id}';
    } else {
      return 'Вы уверены что хоте разархивировать задачу №${widget.id}';
    }
  }

  void onPress() {
    if (widget.type == 0) {
      DBProvider.db.deleteTask(widget.id);
    } else if (widget.type == 1) {
      DBProvider.db.archiveTask(widget.id);
    } else {
      DBProvider.db.unarchive(widget.id);
    }
  }
}
