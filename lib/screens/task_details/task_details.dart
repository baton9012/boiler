import 'package:boiler/db/db.dart';
import 'package:boiler/models/task.dart';
import 'package:boiler/models/task_title.dart';
import 'package:boiler/screens/task_details/widgets/progress_bar.dart';
import 'package:boiler/screens/task_details/widgets/text_detail.dart';
import 'package:flutter/material.dart';

import '../../global.dart';

class TaskDetail extends StatefulWidget {
  final TaskTitle taskTitle;

  const TaskDetail({@required this.taskTitle});

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  Color buttonColor;
  IconData buttonTitle;
  Color statusIconColor;
  IconData statusIcon;
  bool isNeedStatusButton = true;
  AppBar appBar;
  TextEditingController textEditingController = TextEditingController();
  Task task;
  bool isChangeStatus = false;

  @override
  Widget build(BuildContext context) {
    String statusLabel = statusToString(widget.taskTitle.status);
    createAppBar(context);
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: SingleChildScrollView(
          child: Container(
            height: height - appBar.preferredSize.height,
            padding: const EdgeInsets.all(12.0),
            child: FutureBuilder<Task>(
                future: DBProvider.db.getTaskDetail(widget.taskTitle.id),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else if (snapshot.hasData) {
                        task = snapshot.data;
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Expanded(
                                  child: TextDetail(
                                    title: 'Тип работы: ',
                                    data: widget.taskTitle.type,
                                  ),
                                ),
                                Spacer(),
                                TextDetail(
                                  title: '',
                                  data: dateFormat(
                                    date: widget.taskTitle.dateCreate,
                                  ),
                                ),
                              ],
                            ),
                            TextDetail(
                              title: 'Заказчик: ',
                              data: widget.taskTitle.nlp,
                            ),
                            TextDetail(
                              title: 'Адрес заказчика: ',
                              data: task.city,
                            ),
                            TextDetail(
                              title: '',
                              data: task.address,
                            ),
                            TextDetail(
                              title: 'Примечание:',
                              data: '',
                            ),
                            TextDetail(
                              title: '',
                              data: task.descriptionCustomer,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextDetail(
                                  title: 'Статус: ',
                                  data: statusLabel,
                                ),
                                Icon(
                                  statusIcon,
                                  size: 20.0,
                                  color: statusIconColor,
                                ),
                              ],
                            ),
                            SizedBox(height: 8.0),
                            Row(
                              children: [
                                ProgressBar(color: Colors.red),
                                ProgressBar(
                                  color: widget.taskTitle.status >= 1
                                      ? Colors.yellow.shade800
                                      : Colors.grey,
                                ),
                                ProgressBar(
                                  color: widget.taskTitle.status >= 2
                                      ? Colors.green
                                      : Colors.grey,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  fillProgressBar(widget.taskTitle.status),
                            ),
                            SizedBox(height: 8.0),
                            TextDetail(
                              title: 'Тип бойлера: ',
                              data: task.boilerType,
                            ),
                            TextField(
                              controller: textEditingController,
                              textInputAction: TextInputAction.send,
                              decoration: InputDecoration(
                                labelText: 'Описание сделанных работ',
                                labelStyle: standardTextStyle,
                              ),
                            ),
                            Spacer(),
                          ],
                        );
                      }
                  }
                  return Container();
                }),
          ),
        ),
        floatingActionButton: isNeedStatusButton
            ? FloatingActionButton(
                child: Icon(buttonTitle),
                backgroundColor: buttonColor,
                onPressed: () {
                  widget.taskTitle.status = widget.taskTitle.status + 1;
                  updateStatusDB();
                },
              )
            : null,
      ),
    );
  }

  List<Widget> fillProgressBar(int status) {
    List<Widget> dates = List<Widget>();
    dates.add(Text(dateFormat(date: task.dateAttached)));
    if (status == 1) {
      dates.add(Text(dateFormat(date: task.dateInWork)));
    } else if (status == 2) {
      dates.add(Text(dateFormat(date: task.dateInWork)));
      dates.add(Text(dateFormat(date: task.dateDone)));
    }
    return dates;
  }

  void updateStatusDB() async {
    await DBProvider.db.updateStatus(
      status: widget.taskTitle.status,
      date: DateTime.now(),
      id: widget.taskTitle.id,
    );
    setState(() {
      isChangeStatus = true;
      statusToString(widget.taskTitle.status);
    });
  }

  AppBar createAppBar(BuildContext context) {
    appBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop(isChangeStatus);
        },
      ),
      title: Text('Детали задачи'),
    );
    return appBar;
  }

  String statusToString(int statusCode) {
    switch (statusCode) {
      case 0:
        statusIconColor = Colors.red;
        buttonColor = Colors.yellow.shade800;
        statusIcon = Icons.assignment_ind;
        buttonTitle = Icons.work;
        return 'Присвоено ';
      case 1:
        statusIconColor = Colors.yellow.shade800;
        buttonColor = Colors.green;
        statusIcon = Icons.work;
        buttonTitle = Icons.done_all;
        return 'В работе ';
      case 2:
        setState(() {
          statusIconColor = Colors.green;
          statusIcon = Icons.done_all;
          isNeedStatusButton = false;
        });
        return 'Законченно ';
    }
    return '';
  }
}
