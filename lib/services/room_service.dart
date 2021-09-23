import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drink_n_talk/models/room.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomService {
  final CollectionReference collection = FirebaseFirestore.instance.collection('rooms');

  Future<Room> createRoom() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();

    final Room room = Room(players: [sharedPrefs.getString('username') ?? 'Host']);

    // TODO: Handle crashes
    final DocumentReference docRef = await collection.add(room.toMap());
    room.id = docRef.id;
    return room;
  }

  Stream<Room> joinRoom(String id) {
    return collection.doc(id).snapshots().map(
          (DocumentSnapshot snapshot) => Room.fromMap(
            snapshot.data() as Map<String, dynamic>,
          ),
        );
  }
}
