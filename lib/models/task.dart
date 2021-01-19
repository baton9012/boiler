import 'package:boiler/models/task_title.dart';

class TaskModel extends TaskTitleModel {
  int id;
  String address;
  String descriptionCustomer;
  String descriptionMaster;
  String dateAttached;
  String dateInWork;
  String dateDone;
  String boilerType;

  TaskModel({
    this.id,
    this.address,
    this.dateAttached,
    this.dateDone,
    this.boilerType,
    this.dateInWork,
    this.descriptionCustomer,
    this.descriptionMaster,
  });

  factory TaskModel.fromMap(Map<String, dynamic> taskJson) => TaskModel(
        id: taskJson['id'],
        address: taskJson['address'],
        dateAttached: taskJson['date_attached'],
        dateDone: taskJson['date_done'],
        boilerType: taskJson['boiler_type'],
        dateInWork: taskJson['date_in_work'],
        descriptionCustomer: taskJson['description_customer'],
        descriptionMaster: taskJson['description_master'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'address': address,
        'date_attached': dateAttached,
        'date_done': dateDone,
        'boiler_type': boilerType,
        'date_in_work': dateInWork,
        'description_customer': descriptionCustomer,
        'description_master': descriptionMaster
      };
}
