import 'package:boiler/models/task_title.dart';
import 'package:flutter/material.dart';

import '../../../global.dart';

class ListItem extends StatelessWidget {
  final TaskTitle taskTitle;
  final Function navigateToDetail;

  const ListItem({this.taskTitle, this.navigateToDetail});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        navigateToDetail(taskTitle);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(taskTitle.nlp),
                ),
                Text(taskTitle.type),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(taskTitle.city),
              Spacer(),
              statusToString(taskTitle.status),
              SizedBox(width: 64),
              Text(
                dateFormat(
                  date: taskTitle.date_create,
                ),
              ),
            ],
          ),
          Container(
            width: double.infinity,
            height: 2.0,
            color: Colors.black54,
            margin: EdgeInsets.only(top: 5.0),
          ),
        ],
      ),
    );
  }

  Icon statusToString(int statusCode) {
    switch (statusCode) {
      case 0:
        return Icon(
          Icons.assignment_ind,
          color: Colors.red,
        );
      case 1:
        return Icon(
          Icons.work,
          color: Colors.yellow.shade800,
        );
      case 2:
        return Icon(
          Icons.done_all,
          color: Colors.green,
        );
      default:
        return Icon(
          Icons.done_all,
          color: Colors.green,
        );
    }
  }
}
