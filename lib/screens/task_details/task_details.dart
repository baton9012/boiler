import 'package:boiler/models/firebase_model.dart';
import 'package:boiler/models/task.dart';
import 'package:boiler/models/task_title.dart';
import 'package:boiler/screens/task_details/widgets/progress_bar.dart';
import 'package:boiler/screens/task_details/widgets/text_detail.dart';
import 'package:boiler/services/db_firebase.dart';
import 'package:boiler/services/db_sqlite.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

import '../../global.dart';

class TaskDetail extends StatefulWidget {
  final TaskTitleModel taskTitle;

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
  TextEditingController _descriptionMasterTextController =
      TextEditingController();
  TaskModel task;
  bool isChangeStatus = false;
  FirebaseModel fireBaseModel;
  String statusLabel;
  AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    print(appLocalizations.locale);
    statusLabel = statusToString(widget.taskTitle.status);
    createAppBar(context);
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: FutureBuilder<TaskModel>(
              future: SQLiteDBProvider.db.getTaskDetail(widget.taskTitle.id),
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
                      task.id = widget.taskTitle.id;
                      _descriptionMasterTextController.text =
                          task.descriptionMaster;
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
                                  title:
                                      '${appLocalizations.translate('work_type')}: ',
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
                            title:
                                '${appLocalizations.translate('customer')}: ',
                            data: widget.taskTitle.nlp,
                          ),
                          TextDetail(
                            title:
                                '${appLocalizations.translate('customer_address')}: ',
                            data: task.city,
                          ),
                          TextDetail(
                            title: '',
                            data: task.address,
                          ),
                          TextDetail(
                            title: '${appLocalizations.translate('note')}: ',
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
                                title:
                                    '${appLocalizations.translate('status')}: ',
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
                            children: fillProgressBar(widget.taskTitle.status),
                          ),
                          SizedBox(height: 8.0),
                          TextDetail(
                            title:
                                '${appLocalizations.translate('boiler_type')}: ',
                            data: task.boilerType,
                          ),
                          TextField(
                            controller: _descriptionMasterTextController,
                            textInputAction: TextInputAction.send,
                            decoration: InputDecoration(
                              labelText: appLocalizations
                                  .translate('description_job_done'),
                              labelStyle: standardTextStyle,
                            ),
                            onEditingComplete: () {
                              updateMasterDescription();
                            },
                          ),
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
    await SQLiteDBProvider.db.updateStatus(
      status: widget.taskTitle.status,
      date: DateTime.now(),
      id: widget.taskTitle.id,
    );
    print('updateStatusDB ${widget.taskTitle.id}');
    FirebaseDBProvider.firebaseDB.updateFirebaseRecord(
      taskModel: task,
      taskTitleModel: widget.taskTitle,
      isUpdateStatus: true,
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
      title: Text(appLocalizations.translate('task_detail')),
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
        return appLocalizations.translate('attached') + ' ';
      case 1:
        statusIconColor = Colors.yellow.shade800;
        buttonColor = Colors.green;
        statusIcon = Icons.work;
        buttonTitle = Icons.done_all;
        return appLocalizations.translate('in_work') + ' ';
      case 2:
        setState(() {
          statusIconColor = Colors.green;
          statusIcon = Icons.done_all;
          isNeedStatusButton = false;
        });
        return appLocalizations.translate('done') + ' ';
    }
    return '';
  }

  void updateMasterDescription() {
    setState(() {
      SQLiteDBProvider.db.updateMasterDescription(
        id: widget.taskTitle.id,
        description: _descriptionMasterTextController.text,
      );
    });
    FirebaseDBProvider.firebaseDB.updateFirebaseRecord(
      taskModel: task,
      taskTitleModel: widget.taskTitle,
    );
  }
}
