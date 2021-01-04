class TaskTitle {
  int id;
  String nlp;
  String type;
  String city;
  String dateCreate;
  int status;

  TaskTitle({
    this.id,
    this.nlp,
    this.type,
    this.city,
    this.dateCreate,
    this.status,
  });

  factory TaskTitle.fromMap(Map<String, dynamic> taskTitleJson) => TaskTitle(
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
