import 'package:boiler/models/task_title.dart';

class Task extends TaskTitle {
  int id;
  String address;
  String description_customer;
  String description_master;
  String date_attached;
  String date_in_work;
  String date_done;
  String boiler_type;

  Task({
    this.id,
    this.address,
    this.date_attached,
    this.date_done,
    this.boiler_type,
    this.date_in_work,
    this.description_customer,
    this.description_master,
  });

  factory Task.fromMap(Map<String, dynamic> taskJson) => Task(
        id: taskJson['id'],
        address: taskJson['address'],
        date_attached: taskJson['date_attached'],
        date_done: taskJson['date_done'],
        boiler_type: taskJson['boiler_type'],
        date_in_work: taskJson['date_in_work'],
        description_customer: taskJson['description_customer'],
        description_master: taskJson['description_master'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'address': address,
        'date_attached': date_attached,
        'date_done': date_done,
        'boiler_type': boiler_type,
        'date_in_work': date_in_work,
        'description_customer': description_customer,
        'description_master': description_master
      };
}
