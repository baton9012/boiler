import 'package:flutter/material.dart';

class InheritedTaskList extends InheritedWidget {
  final Function updateTaskList;

  InheritedTaskList({@required this.updateTaskList, @required Widget child})
      : super(child: child);

  static InheritedTaskList of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<InheritedTaskList>();

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
