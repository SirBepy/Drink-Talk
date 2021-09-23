import 'dart:async';

import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:drink_n_talk/services/room_service.dart';
import 'package:flutter/material.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({Key? key}) : super(key: key);

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? futureUpdateFirestore;

  @override
  void initState() {
    super.initState();
    RoomService.joinRoom();
    // updateTimeStamp();
  }

  // The logic is weird but simple
  //? Problem: Letting the host know who joined, and who left, but also being able to do that even if the user turns off his phone
  //* Solution: Updating the timestamp for this user every 6 seconds, and the host will delete a user if the timestamp is older than 15 seconds
  void updateTimeStamp() {
    futureUpdateFirestore = Timer(const Duration(seconds: 6), () {
      RoomService.updateUserTimestamp();
      updateTimeStamp();
    });
  }

  @override
  void dispose() {
    futureUpdateFirestore?.cancel();
    RoomService.leaveRoom();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      extendBodyBehindAppBar: true,
      body: Center(
        child: Text('Entered the room'),
      ),
    );
  }
}
