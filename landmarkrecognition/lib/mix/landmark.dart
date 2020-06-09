import 'package:firebase_database/firebase_database.dart';

class Landmark {
  String key;
  String name;
  String id;
  String userId;

  Landmark(this.name, this.id,this.userId);

  Landmark.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        userId = snapshot.value["userId"],
        id = snapshot.value["id"],
        name = snapshot.value["name"];

  toJson() {
    return {
      "userId": userId,
      "id": id,
      "name": name,
    };
  }
}