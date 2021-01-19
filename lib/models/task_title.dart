class TaskTitleModel {
  String id;
  String nlp;
  String type;
  String city;
  String dateCreate;
  int status;

  TaskTitleModel({
    this.id,
    this.nlp,
    this.type,
    this.city,
    this.dateCreate,
    this.status,
  });

  factory TaskTitleModel.fromMap(Map<String, dynamic> taskTitleJson) =>
      TaskTitleModel(
        id: taskTitleJson['id'],
        nlp: taskTitleJson['nlp'],
        type: taskTitleJson['type'],
        city: taskTitleJson['city'],
        dateCreate: taskTitleJson['date_create'],
        status: taskTitleJson['status'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nlp': nlp,
        'type': type,
        'city': city,
        'date_create': dateCreate,
        'status': status,
      };
}
