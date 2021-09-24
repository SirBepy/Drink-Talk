import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  bool hasStarted;
  String time;
  String id;
  String? loser;
  List<String> players;
  Timestamp? timestamp;

  Room({
    this.hasStarted = false,
    this.time = '0h 05min',
    this.id = '',
    this.loser,
    this.players = const [],
    this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasStarted': hasStarted,
      'time': time,
      'loser': loser,
      'timestamp': timestamp,
      'players': players,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    final List<dynamic> players = map['players'] as List<dynamic>;

    return Room(
      hasStarted: map['hasStarted'] as bool,
      time: map['time'] as String,
      loser: map['loser'] as String?,
      timestamp: map['timestamp'] as Timestamp,
      players: players.map((e) => e.toString()).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source) as Map<String, dynamic>);
}
