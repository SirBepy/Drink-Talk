import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:drink_n_talk/components/loading_indicator.dart';
import 'package:drink_n_talk/models/room.dart';
import 'package:drink_n_talk/pages/done_screen.dart';
import 'package:drink_n_talk/services/room_service.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum CountdownState { waiting, started, finished }

class CountdownScreen extends StatefulWidget {
  final bool alreadyJoined;
  const CountdownScreen({Key? key, this.alreadyJoined = false}) : super(key: key);

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> with WidgetsBindingObserver {
  Timer? futureUpdateTimeStamp;
  bool? hadRoom;
  bool matchDone = false;
  CountDownController countDownController = CountDownController();
  CountdownState countdownState = CountdownState.waiting;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (!matchDone &&
        hadRoom == true &&
        countdownState == CountdownState.finished &&
        state == AppLifecycleState.paused) {
      RoomService.setAsLoser();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!widget.alreadyJoined) RoomService.joinRoom(onNameIsDuplicate);
    WidgetsBinding.instance!.addObserver(this);
  }

  void onNameIsDuplicate(String newName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppLocalizations.of(context)?.nameExists} $newName',
        ),
      ),
    );
  }

  // Not a good practice, but i need to force update the state
  void updateTimeStamp() {
    futureUpdateTimeStamp?.cancel();
    futureUpdateTimeStamp = Timer(const Duration(seconds: 1), () {
      setState(() {});
      if (!matchDone) updateTimeStamp();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    futureUpdateTimeStamp?.cancel();
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

  String getTime(Room room) {
    if (countdownState != CountdownState.finished) return room.time;

    final DateTime timeElapsed = DateTime.now().subtract(
      Duration(milliseconds: room.timestamp!.millisecondsSinceEpoch),
    );

    final DateTime timeLeft = DateTime(
      1970,
      1,
      1,
      int.tryParse(room.time.substring(0, room.time.indexOf('h ')))!,
      int.tryParse(room.time.substring(room.time.indexOf('h ') + 2, room.time.indexOf('min')))!,
      10,
    ).subtract(Duration(milliseconds: timeElapsed.millisecondsSinceEpoch));

    if (DateTime(1970).compareTo(timeLeft) > 0) {
      Future.delayed(const Duration(seconds: 1), finishGame);
      return '0sek';
    }
    if (timeLeft.minute <= 0) return '${timeLeft.second}sek';
    if (timeLeft.hour > 0) return '${timeLeft.hour}h ${timeLeft.minute}min';

    return '${timeLeft.minute}min';
  }

  void finishGame([String? loser]) {
    if (matchDone) return;
    FlutterScreenWake.keepOn(false);
    FlutterScreenWake.setBrightness(0);
    setState(() => matchDone = true);
    if (loser == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DoneScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DoneScreen(loser: loser)),
      );
    }
  }

  void onCountdownDone() {
    setState(() => countdownState = CountdownState.finished);
    updateTimeStamp();
    FlutterScreenWake.keepOn(true);
    FlutterScreenWake.setBrightness(0);
  }

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
            Future.delayed(const Duration(milliseconds: 50), startTimer);
          print('loser je ${snapshot.data!.loser}');
          if (snapshot.data!.loser != null && !matchDone)
            Future.delayed(const Duration(milliseconds: 50), () => finishGame(snapshot.data!.loser));

          return Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)?.leavePhone ?? 'Spusti i ne diraj\nmobitel za',
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
                        onCountdownDone,
                      ),
                    ),
                    Spacers.h16,
                    Text(
                      AppLocalizations.of(context)?.seconds ?? 'Sekundi',
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
                              text: AppLocalizations.of(context)?.waitingForHost ?? 'Čekamo host-a da započne igru.\n\n',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                           TextSpan(
                            text: AppLocalizations.of(context)?.instructionsFirst ??'Ukoliko podigneš mobitel u sljedećih ',
                          ),
                          TextSpan(
                            text: getTime(snapshot.data!),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                           TextSpan(
                            text: AppLocalizations.of(context)?.instructionsSecond ?? ' ostalim sudionicima igre doći će notifikacija da si izgubio.\n\n',
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)?.beFair ?? 'Budi fer i plati piće ako gubiš.',
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
