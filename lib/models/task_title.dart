class TaskTitle {
  int id;
  String nlp;
  String type;
  String city;
  String date_create;
  int status;

  TaskTitle({
    this.id,
    this.nlp,
    this.type,
    this.city,
    this.date_create,
    this.status,
  });

  factory TaskTitle.fromMap(Map<String, dynamic> taskTitleJson) => TaskTitle(
        id: taskTitleJson['id'],
        nlp: taskTitleJson['nlp'],
        type: taskTitleJson['type'],
        city: taskTitleJson['city'],
        date_create: taskTitleJson['date_create'],
        status: taskTitleJson['status'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'nlp': nlp,
        'type': type,
        'city': city,
        'date_create': date_create,
        'status': status,
      };
}
