import 'package:boiler/models/firebase_model.dart';
import 'package:boiler/models/task.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseDBProvider {
  FirebaseDBProvider._();

  static final FirebaseDBProvider firebaseDB = FirebaseDBProvider._();

  final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  DatabaseReference get databaseReference => _databaseReference;

  Map<String, FirebaseModel> firebaseItem = {};
  List<String> uniqueIds = List<String>();
  List<FirebaseModel> firebaseModels = List<FirebaseModel>();
  FirebaseModel firebaseModel = FirebaseModel();

  Future<List<FirebaseModel>> getAllOrder() async {
    DataSnapshot snapshot = await _databaseReference.child('order/').once();
    if (snapshot.value != null) {
      snapshot.value.forEach((key, value) {
        firebaseModels.add(firebaseModel.parseFirebaseModel(value));
        uniqueIds.add(_databaseReference.child('order/').key);
        firebaseItem['$key'] = value;
      });
    }
    firebaseModel.recordToSQLite(firebaseModels: firebaseModels);
    return firebaseModels;
  }

  void updateFirebaseRecord({TaskModel taskModel}) {
    firebaseModel.update(task: taskModel);
    taskModel.id.update(firebaseModel.toJSON());
  }

  DatabaseReference saveOrder(FirebaseModel firebaseModel) {
    print('databaseRefence ${firebaseModel.userId}');
    DatabaseReference id = databaseReference.child('order/').push();
    id.set(firebaseModel.toJSON());
    return id;
  }
}
