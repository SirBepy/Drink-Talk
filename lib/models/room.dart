import 'dart:convert';

class Room {
  bool hasStarted;
  String time;
  List<String> players;
  String id;

  Room({
    required this.hasStarted,
    required this.time,
    required this.players,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasStarted': hasStarted,
      'time': time,
      'players': players,
      'id': id,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      hasStarted: map['hasStarted'] as bool,
      time: map['time'] as String,
      players: List<String>.from(map['players'] as List<String>),
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source) as Map<String, dynamic>);
}
