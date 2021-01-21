import 'package:boiler/models/firebase_model.dart';
import 'package:boiler/models/task.dart';
import 'package:boiler/models/task_title.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDBProvider {
  FirebaseDBProvider._();

  static final FirebaseDBProvider firebaseDB = FirebaseDBProvider._();

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  DatabaseReference get databaseReference => _databaseReference;

  List<FirebaseModel> firebaseModels = List<FirebaseModel>();
  FirebaseModel firebaseModel = FirebaseModel();
  List<DatabaseReference> idRef = List<DatabaseReference>();

  Future<List<FirebaseModel>> getAllOrder() async {
    DataSnapshot snapshot = await _databaseReference.child('order/').once();
    if (snapshot.value != null) {
      snapshot.value.forEach((key, value) {
        firebaseModels.add(firebaseModel.parseFirebaseModel(value, key));
      });
    }
    return firebaseModels;
  }

  void updateFirebaseRecord(
      {TaskTitleModel taskTitleModel,
      TaskModel taskModel,
      bool isUpdateStatus = false}) {
    firebaseModel = firebaseModel.update(
        task: taskModel,
        taskTitle: taskTitleModel,
        isUpdateStatus: isUpdateStatus);
    _databaseReference
        .child('order/')
        .child(taskTitleModel.id)
        .update(firebaseModel.toJSON());
  }

  DatabaseReference saveOrder(FirebaseModel firebaseModel) {
    print('databaseRefence ${firebaseModel.userId}');
    DatabaseReference id = databaseReference.child('order/').push();
    id.set(firebaseModel.toJSON());
    return id;
  }
}
