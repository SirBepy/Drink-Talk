// ignore_for_file: avoid_classes_with_only_static_members

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drink_n_talk/models/room.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomService {
  static late CollectionReference collection;
  static Room? room;

  //* Initializers
  static void init() => collection = FirebaseFirestore.instance.collection('rooms');

  //* Getters
  static Stream<Room> getRoomStream() {
    return collection.doc(room!.id).snapshots().map(
      (DocumentSnapshot snapshot) {
        return Room.fromMap(
          snapshot.data() as Map<String, dynamic>,
        )..id = room!.id;
      },
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
  static Future<bool> createRoom() async {
    final SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
    room = Room(players: [sharedPrefs.getString('username') ?? 'Host']);

    // TODO: Handle crashes
    final DocumentReference docRef = await collection.add({...room!.toMap(), 'timestamp': Timestamp.now()});
    room!.id = docRef.id;
    return true;
  }

  static Future<void> deleteRoom() async {
    if (await roomDoesntExist()) return;
    final DocumentSnapshot snapshot = await collection.doc(room!.id).get();
    snapshot.reference.delete();
  }

  static Future<void> leaveRoom() async {
    if (await roomDoesntExist()) return;
    final sharedPrefs = await SharedPreferences.getInstance();
    collection.doc(room!.id).update({
      'players': FieldValue.arrayRemove([sharedPrefs.getString('username')!])
    });
    final DocumentSnapshot snapshot = await collection.doc(room!.id).get();
    final Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    if ((data['players'] as List<dynamic>).isEmpty) {
      deleteRoom();
    }
  }

  static Future<void> joinRoom(ValueSetter<String> onNameIsDuplicate) async {
    if (await roomDoesntExist()) return;
    final sharedPrefs = await SharedPreferences.getInstance();
    String username = sharedPrefs.getString('username')!;
    final int? firstAvailableNameIndex = getFirstAvailableIndex(username);
    if (firstAvailableNameIndex != null) {
      username += ' $firstAvailableNameIndex';
      sharedPrefs.setString('username', username);
      onNameIsDuplicate(username);
    }

    collection.doc(room!.id).update({
      'players': FieldValue.arrayUnion([username])
    });
  }

  static Future<void> startGame() async {
    if (await roomDoesntExist()) return;
    collection.doc(room!.id).update({'hasStarted': true, 'timestamp': Timestamp.now()});
  }

  static Future<void> updateUserTimestamp() async {}

  //* Helper Functions
  static Future<bool> roomDoesntExist() async {
    if (room == null) return true;
    final bool exists = (await collection.doc(room!.id).get()).exists;
    if (!exists) room = null;

    return !exists;
  }

  // This function combats people having same usernames
  static int? getFirstAvailableIndex(String username) {
    int toReturn = 0;
    for (var i = 0; i < room!.players.length; i++) {
      if (room!.players[i].substring(0, username.length).toLowerCase() == username.toLowerCase()) toReturn++;
    }
    if (toReturn == 0) return null;
    return toReturn;
  }

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
