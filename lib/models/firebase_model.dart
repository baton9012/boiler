import 'package:boiler/models/task.dart';
import 'package:boiler/models/task_title.dart';
import 'package:boiler/services/db_sqlite.dart';
import 'package:flutter/material.dart';

class FirebaseModel {
  String userId;
  String id;
  String address;
  String descriptionMaster;
  String descriptionCustomer;
  String dateAttached;
  String dateInWork;
  String dateDone;
  int status;
  String boilerType;
  String nlpCustomer;
  String type;
  String city;
  String dateCreatedOrder;

  FirebaseModel({
    this.id,
    this.userId,
    this.address,
    this.descriptionMaster,
    this.descriptionCustomer,
    this.dateAttached,
    this.status,
    this.boilerType,
    this.nlpCustomer,
    this.type,
    this.city,
    this.dateCreatedOrder,
    this.dateInWork,
    this.dateDone,
  });

  Map<String, dynamic> toJSON() => {
        'userId': userId,
        'address': address,
        'descriptionMaster': descriptionMaster,
        'descriptionCustomer': descriptionCustomer,
        'dateAttached': dateAttached,
        'status': status,
        'boilerType': boilerType,
        'nlpCustomer': nlpCustomer,
        'type': type,
        'city': city,
        'dateCreatedOrder': dateCreatedOrder,
        'dateInWork': dateInWork,
        'dateDone': dateDone,
      };

  FirebaseModel parseFirebaseModel(record, String id) {
    Map<String, dynamic> attributes = {
      'address': '',
      'descriptionMaster': '',
      'descriptionCustomer': '',
      'dateAttached': '',
      'status': 0,
      'boilerType': '',
      'nlpCustomer': '',
      'type': '',
      'city': '',
      'dateCreatedOrder': '',
      'dateInWork': '',
      'dateDone': '',
    };

    record.forEach((key, value) => {attributes[key] = value});
    FirebaseModel firebaseModel = FirebaseModel(
      id: id,
      address: attributes['address'],
      descriptionMaster: attributes['descriptionMaster'],
      descriptionCustomer: attributes['descriptionCustomer'],
      dateAttached: attributes['dateAttached'],
      status: attributes['status'],
      boilerType: attributes['boilerType'],
      nlpCustomer: attributes['nlpCustomer'],
      type: attributes['type'],
      city: attributes['city'],
      dateCreatedOrder: attributes['dateCreatedOrder'],
      dateInWork: attributes['dateInWork'],
      dateDone: attributes['dateDone'],
    );
    return firebaseModel;
  }

  bool recordToSQLite({@required List<FirebaseModel> firebaseModels}) {
    bool res = false;
    _toTaskTitleModel(firebaseModels).forEach((taskTitle) async =>
        res = await SQLiteDBProvider.db.insertIntoTaskTitle(taskTitle));
    _toTaskModel(firebaseModels).forEach(
        (task) async => res = await SQLiteDBProvider.db.insertIntoTask(task));
    return res;
  }

  List<TaskTitleModel> _toTaskTitleModel(List<FirebaseModel> firebaseModels) {
    List<TaskTitleModel> list = List<TaskTitleModel>();
    firebaseModels.forEach((firebaseModel) => list.add(TaskTitleModel(
          id: firebaseModel.id,
          nlp: firebaseModel.nlpCustomer,
          type: firebaseModel.type,
          city: firebaseModel.city,
          dateCreate: firebaseModel.dateCreatedOrder,
          status: firebaseModel.status,
        )));
    return list;
  }

  List<TaskModel> _toTaskModel(List<FirebaseModel> firebaseModels) {
    List<TaskModel> list = List<TaskModel>();
    firebaseModels.forEach((firebaseModel) => list.add(TaskModel(
          id: firebaseModel.id,
          address: firebaseModel.address,
          dateAttached: firebaseModel.dateAttached,
          dateInWork: firebaseModel.dateInWork,
          dateDone: firebaseModel.dateDone,
          boilerType: firebaseModel.boilerType,
          descriptionCustomer: firebaseModel.descriptionCustomer,
          descriptionMaster: firebaseModel.descriptionMaster,
        )));
    return list;
  }

  FirebaseModel update({TaskModel task}) {
    FirebaseModel firebaseModel = FirebaseModel(
      address: task.address,
      descriptionMaster: task.descriptionMaster,
      descriptionCustomer: task.descriptionMaster,
      dateAttached: task.dateAttached,
      status: task.status,
      boilerType: task.boilerType,
      nlpCustomer: task.nlp,
      type: task.type,
      city: task.city,
      dateCreatedOrder: task.dateCreate,
      dateInWork: task.dateInWork,
      dateDone: task.dateDone,
    );
    return firebaseModel;
  }
}
