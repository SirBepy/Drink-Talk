import 'dart:convert';

class Room {
  bool hasStarted;
  String time;
  List<String> players;
  String id;

  Room({
    this.hasStarted = false,
    this.time = '0h 30min',
    this.players = const [],
    this.id = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'hasStarted': hasStarted,
      'time': time,
      'players': players,
    };
  }

  factory Room.fromMap(Map<String, dynamic> map) {
    final List<dynamic> players = map['players'] as List<dynamic>;

    return Room(
      hasStarted: map['hasStarted'] as bool,
      time: map['time'] as String,
      players: players.map((e) => e.toString()).toList(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Room.fromJson(String source) => Room.fromMap(json.decode(source) as Map<String, dynamic>);
}
