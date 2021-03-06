import 'package:boiler/dialog_window/delete_dialog.dart';
import 'package:boiler/models/task_title.dart';
import 'package:boiler/screens/task_details/task_details.dart';
import 'package:boiler/screens/tast_list/widgets/list_item.dart';
import 'package:boiler/services/db_sqlite.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArchiveList extends StatefulWidget {
  @override
  _ArchiveListState createState() => _ArchiveListState();
}

class _ArchiveListState extends State<ArchiveList> {
  Future<List<TaskTitleModel>> fTaskTitle;
  bool isNeedUpdate = false;
  AppLocalizations appLocalizations;
  @override
  void initState() {
    super.initState();
    fTaskTitle = SQLiteDBProvider.db.getAllArchiveTaskTitle();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(isNeedUpdate);
            }),
        title: Text(appLocalizations.translate('archive')),
      ),
      body: FutureBuilder<List<TaskTitleModel>>(
        future: fTaskTitle,
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
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    TaskTitleModel item = snapshot.data[index];
                    return item.status == 3
                        ? Dismissible(
                            confirmDismiss: (direction) {
                              if (direction == DismissDirection.startToEnd) {
                                return showDialog(
                                  context: context,
                                  child: DeleteDialog(
                                    type: 0,
                                    id: snapshot.data[index].id,
                                  ),
                                );
                              } else {
                                return showDialog(
                                  context: context,
                                  child: DeleteDialog(
                                    type: 2,
                                    id: snapshot.data[index].id,
                                  ),
                                );
                              }
                            },
                            onDismissed: (directions) {
                              snapshot.data.removeAt(index);
                              if (directions == DismissDirection.endToStart) {
                                isNeedUpdate = true;
                              }
                            },
                            background: Container(
                              padding: EdgeInsets.only(left: 8.0),
                              alignment: Alignment.centerLeft,
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            secondaryBackground: Container(
                              padding: EdgeInsets.only(right: 8.0),
                              alignment: Alignment.centerRight,
                              color: Colors.green,
                              child: Icon(
                                Icons.unarchive,
                                color: Colors.white,
                              ),
                            ),
                            key: Key(item.id.toString()),
                            child: ListItem(
                              taskTitle: item,
                              navigateToDetail: navigateToDetail,
                            ),
                          )
                        : ListItem(
                            taskTitle: item,
                            navigateToDetail: navigateToDetail,
                          );
                  },
                );
              }
          }
          return Container();
        },
      ),
    );
  }

  navigateToDetail(TaskTitleModel taskTitle) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetail(
          taskTitle: taskTitle,
        ),
      ),
    );
  }
}
