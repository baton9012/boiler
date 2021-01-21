import 'package:boiler/dialog_window/delete_dialog.dart';
import 'package:boiler/models/task_title.dart';
import 'package:boiler/screens/login/login.dart';
import 'package:boiler/screens/task_details/task_details.dart';
import 'package:boiler/screens/tast_list/widgets/inherited_task_list.dart';
import 'package:boiler/screens/tast_list/widgets/list_item.dart';
import 'package:boiler/screens/tast_list/widgets/search_button.dart';
import 'package:boiler/screens/tast_list/widgets/search_settings.dart';
import 'package:boiler/screens/tast_list/widgets/settings_button.dart';
import 'package:boiler/screens/tast_list/widgets/sort_button.dart';
import 'package:boiler/services/auth.dart';
import 'package:boiler/services/db_sqlite.dart';
import 'package:boiler/widgets/app_localization.dart';
import 'package:flutter/material.dart';

import '../../global.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Widget appBarTitle;
  TextEditingController textEditingController = TextEditingController();
  bool isSearch = false;
  IconData statusIcon;
  Color statusIconColor;
  bool isSearchByNLP = true;
  Future<List<TaskTitleModel>> fTaskTitle;
  bool isNeedUpdate = false;
  AppLocalizations appLocalizations;

  @override
  void initState() {
    super.initState();
    fTaskTitle = SQLiteDBProvider.db.getAllTaskTitle(searchText: '');
    getConfig();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
    return InheritedTaskList(
      updateTaskList: updateTaskList,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: isSearch ? 100.0 : 60.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: appBarTitle == null
                ? GestureDetector(
                    child: Text(appLocalizations.translate('task_list')),
                    onLongPress: () {
                      Auth().signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                  )
                : appBarTitle,
          ),
          bottom: isSearch
              ? PreferredSize(
                  preferredSize: Size.fromHeight(0.0),
                  child: SearchSetting(parentWidget: this),
                )
              : null,
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SearchButton(
                isSearch: isSearch,
                onTab: setSearch,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SortButton(
                callBack: sort,
                local: appLocalizations,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SettingsButton(),
            ),
          ],
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
                    child: Text('task title ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      TaskTitleModel item = snapshot.data[index];
                      print('status ${item.status}');
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
                                      type: 1,
                                      id: snapshot.data[index].id,
                                    ),
                                  );
                                }
                              },
                              onDismissed: (direction) {
                                setState(() {
                                  snapshot.data.remove(item);
                                });
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
                                color: Colors.orange,
                                child: Icon(
                                  Icons.archive,
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
            return Container(
              height: 0,
              width: 0,
            );
          },
        ),
      ),
    );
  }

  void navigateToDetail(TaskTitleModel taskTitle) async {
    var res = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetail(
          taskTitle: taskTitle,
        ),
      ),
    );
    if (res) {
      updateTaskList();
    }
  }

  void updateTaskList() {
    setState(() {
      fTaskTitle = SQLiteDBProvider.db.getAllTaskTitle(searchText: '');
    });
  }

  void sort({int sortType}) {
    config.sortTypeId = sortType;
    fTaskTitle = SQLiteDBProvider.db.getAllTaskTitle(searchText: '');
    setState(() {});
  }

  Future<void> getConfig() async {
    await SQLiteDBProvider.db.getConfig();
  }

  void setSearch() {
    if (isSearch) {
      setState(() {
        isSearch = false;
        textEditingController.text = '';
        fTaskTitle = SQLiteDBProvider.db.getAllTaskTitle(searchText: '');
        appBarTitle = GestureDetector(
          child: Text(appLocalizations.translate('task_list')),
          onLongPress: () {
            Auth().signOut();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        );
      });
    } else {
      setState(() {
        isSearch = true;
        appBarTitle = TextField(
          cursorColor: Colors.black87,
          cursorWidth: 2.0,
          controller: textEditingController,
          textInputAction: TextInputAction.search,
          autofocus: true,
          style: TextStyle(color: Colors.white, fontSize: 20.0),
          decoration: InputDecoration(
            hintText: 'Поиск',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          ),
          onChanged: (value) {
            fTaskTitle = SQLiteDBProvider.db.getAllTaskTitle(
                searchText: value.toUpperCase(),
                serchType: isSearchByNLP
                    ? SearchSetting.SearchBYNLP
                    : SearchSetting.SearchBYCity);
            setState(() {});
          },
        );
      });
    }
  }
}
