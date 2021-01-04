import 'package:boiler/db/db.dart';
import 'package:boiler/dialog_window/delete_dialog.dart';
import 'package:boiler/models/task_title.dart';
import 'package:boiler/screens/task_details/task_details.dart';
import 'package:boiler/screens/tast_list/widgets/inherited_task_list.dart';
import 'package:boiler/screens/tast_list/widgets/list_item.dart';
import 'package:boiler/screens/tast_list/widgets/search_button.dart';
import 'package:boiler/screens/tast_list/widgets/search_settings.dart';
import 'package:boiler/screens/tast_list/widgets/settings_button.dart';
import 'package:boiler/screens/tast_list/widgets/sort_button.dart';
import 'package:flutter/material.dart';

import '../../global.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  Widget appBarTitle = Text('Список задач');
  TextEditingController textEditingController = TextEditingController();
  bool isSearch = false;
  IconData statusIcon;
  Color statusIconColor;
  bool isSearchByNLP = true;
  Future<List<TaskTitle>> fTaskTitle;
  bool isNeedUpdate = false;

  @override
  void initState() {
    super.initState();
    fTaskTitle = DBProvider.db.getAllTaskTitle(searchText: '');
    getConfig();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedTaskList(
      updateTaskList: updateTaskList,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: isSearch ? 100.0 : 60.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: appBarTitle,
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
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: SettingsButton(),
            ),
          ],
        ),
        body: FutureBuilder<List<TaskTitle>>(
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
                      TaskTitle item = snapshot.data[index];
                      return item.status == 2
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

  void navigateToDetail(TaskTitle taskTitle) async {
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
      fTaskTitle = DBProvider.db.getAllTaskTitle(searchText: '');
    });
  }

  void sort({int sortType}) {
    config.sortTypeId = sortType;
    fTaskTitle = DBProvider.db.getAllTaskTitle(searchText: '');
    setState(() {});
  }

  Future<void> getConfig() async {
    await DBProvider.db.getConfig();
  }

  void setSearch() {
    if (isSearch) {
      setState(() {
        isSearch = false;
        textEditingController.text = '';
        fTaskTitle = DBProvider.db.getAllTaskTitle(searchText: '');
        appBarTitle = Text('Список задач');
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
            fTaskTitle = DBProvider.db.getAllTaskTitle(
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
