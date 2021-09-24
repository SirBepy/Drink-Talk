import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:drink_n_talk/components/bottom_button.dart';
import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:drink_n_talk/components/loading_indicator.dart';
import 'package:drink_n_talk/models/room.dart';
import 'package:drink_n_talk/services/room_service.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';

enum CountdownState { waiting, started, finished }

class CountdownScreen extends StatefulWidget {
  final bool alreadyJoined;
  const CountdownScreen({Key? key, this.alreadyJoined = false}) : super(key: key);

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  Timer? futureUpdateFirestore;
  bool? hadRoom;
  CountDownController countDownController = CountDownController();
  CountdownState countdownState = CountdownState.waiting;

  @override
  void initState() {
    super.initState();
    if (!widget.alreadyJoined) RoomService.joinRoom(onNameIsDuplicate);
    // updateTimeStamp();
  }

  void onNameIsDuplicate(String newName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ovo ime već postoji u ovoj sobi, novo ime je: $newName',
        ),
      ),
    );
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

  Future<void> handleNoMoreRoom() async {
    hadRoom = false;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ova soba više ne postoji')));
    Navigator.of(context).pop();
  }

  Future<void> startTimer() async {
    setState(() => countdownState = CountdownState.started);
    countDownController.start();
  }

  // I shouldve checked this before, not sure what newGame is meant to do
  // TODO: Ask what needs to be done
  void onNewGame() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: RoomService.getRoomStream(),
        builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {
          if (!snapshot.hasData) {
            if (hadRoom == true) Future.delayed(const Duration(seconds: 1), handleNoMoreRoom);
            return const LoadingIndicator();
          }
          hadRoom ??= true;
          if (snapshot.data!.hasStarted && countdownState == CountdownState.waiting)
            Future.delayed(const Duration(milliseconds: 500), startTimer);

          return Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Spusti i ne diraj\nmobitel za',
                      style: Theme.of(context).textTheme.headline3,
                      textAlign: TextAlign.center,
                    ),
                    Spacers.h16,
                    CircularCountDownTimer(
                      duration: 10,
                      initialDuration: 0,
                      controller: countDownController,
                      width: 200,
                      height: 200,
                      ringColor: Theme.of(context).backgroundColor,
                      fillColor: Theme.of(context).primaryColor,
                      backgroundColor: Colors.transparent,
                      strokeWidth: 6,
                      strokeCap: StrokeCap.round,
                      textStyle: Theme.of(context).textTheme.headline4,
                      textFormat: CountdownTextFormat.S,
                      isReverse: true,
                      isReverseAnimation: true,
                      isTimerTextShown: true,
                      autoStart: false,
                      onComplete: () => Future.delayed(
                        const Duration(seconds: 1),
                        () => setState(() => countdownState = CountdownState.finished),
                      ),
                    ),
                    Spacers.h16,
                    Text(
                      'Sekundi',
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                bottom: countdownState == CountdownState.started ? -80 : (MediaQuery.of(context).size.height - 300) / 2,
                left: (MediaQuery.of(context).size.width - 250) / 2,
                child: Container(
                  height: 300,
                  width: 250,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          if (countdownState == CountdownState.waiting)
                            TextSpan(
                              text: 'Čekamo host-a da započne igru.\n\n',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          const TextSpan(
                            text: 'Ukoliko podigneš mobitel u sljedećih ',
                          ),
                          TextSpan(
                            text: '1 sat i 30 min',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          const TextSpan(
                            text: ' ostalim sudionicima igre doći će notifikacija da si izgubio.\n\n',
                          ),
                          TextSpan(
                            text: 'Budi fer i plati piće ako gubiš.',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
