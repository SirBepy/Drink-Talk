// ignore_for_file: avoid_classes_with_only_static_members

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drink_n_talk/models/room.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomService {
  static late CollectionReference collection;
  static Room? room;

  //* Initializers
  static void init() => collection = FirebaseFirestore.instance.collection('rooms');

  //* Getters
  static Stream<Room> getRoomStream() {
    return collection.doc(room!.id).snapshots().map(
          (DocumentSnapshot snapshot) => Room.fromMap(
            snapshot.data() as Map<String, dynamic>,
          ),
        );
  }

  static Future<Room?> getRoom(String id) async {
    final DocumentSnapshot snapshot = await collection.doc(id).get();

    if (snapshot.data() is! Map<String, dynamic>) return null;
    room = Room.fromMap(snapshot.data() as Map<String, dynamic>);
    room!.id = id;
    return room;
  }

  //* Data Handlers
  static Future<Room> createRoom() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    room = Room(players: [sharedPrefs.getString('username') ?? 'Host']);

    // TODO: Handle crashes
    final DocumentReference docRef = await collection.add({...room!.toMap(), 'timestamp': Timestamp.now()});
    room!.id = docRef.id;
    return room!;
  }

  static Future<void> deleteRoom() async {
    final DocumentSnapshot snapshot = await collection.doc(room!.id).get();
    snapshot.reference.delete();
  }

  static Future<void> leaveRoom() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    collection.doc(room!.id).update({
      'players': FieldValue.arrayRemove([sharedPrefs.getString('username')!])
    });
  }

  static Future<void> joinRoom() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    collection.doc(room!.id).update({
      'players': FieldValue.arrayUnion([sharedPrefs.getString('username')!])
    });
  }

  static Future<void> updateUserTimestamp() async {}

  //* Functions that should be replaced
  // Ideally, this function will later be deleted and we would use a CRON function to delete older entries
  //? Problem: In case user opens a room but forces the app to shutdown, there will be some rooms left open
  //* Solution: Delete all data older than 16 hours
  static void deleteOldData() {
    final timestamp16hrAgo = Timestamp.fromMillisecondsSinceEpoch(
      DateTime.now().subtract(const Duration(hours: 16)).millisecondsSinceEpoch,
    );

    collection.where('timestamp', isLessThan: timestamp16hrAgo).get().then((QuerySnapshot snapshot) {
      for (final DocumentSnapshot snapshot in snapshot.docs) snapshot.reference.delete();
    });
  }
}
