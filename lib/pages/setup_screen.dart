import 'package:drink_n_talk/components/app_button.dart';
import 'package:drink_n_talk/components/bottom_button.dart';
import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:drink_n_talk/components/dotted_divider.dart';
import 'package:drink_n_talk/components/loading_indicator.dart';
import 'package:drink_n_talk/models/room.dart';
import 'package:drink_n_talk/pages/countdown_screen.dart';
import 'package:drink_n_talk/services/room_service.dart';
import 'package:drink_n_talk/utils/app_padding.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool? hadRoom;
  Future<bool>? createRoomFuture;
  bool deleteRoom = true;

  @override
  void initState() {
    super.initState();
    createRoom();
  }

  Future<void> createRoom() async {
    createRoomFuture = RoomService.createRoom();
    setState(() {});
  }

  @override
  void dispose() {
    if (deleteRoom) RoomService.deleteRoom();
    super.dispose();
  }

  Future<void> handleNoMoreRoom() async {
    hadRoom = false;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.roomDoesntExist ?? 'Ova soba više ne postoji')));
    Navigator.of(context).pop();
  }

  Future<void> onStart() async {
    deleteRoom = false;
    Future.delayed(const Duration(seconds: 1), RoomService.startGame);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const CountdownScreen(alreadyJoined: true)),
    );
  }

  Future<void> onTapTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      // 300000 = 5 min, we also need to subtract 1 hour because by default an hour is added
      initialTime: TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(300000).subtract(const Duration(hours: 1)),
      ),
      builder: (context, childWidget) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).scaffoldBackgroundColor,
              onSurface: Theme.of(context).primaryColor,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: childWidget!,
          ),
        );
      },
    );

    if (time == null) return;
    final String min = time.minute.toString();
    RoomService.updateTime('${time.hour}h ${min.length == 1 ? "0$min" : min}min');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
        future: createRoomFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LoadingIndicator();
          return StreamBuilder(
            stream: RoomService.getRoomStream(),
            builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {
              if (!snapshot.hasData) {
                if (hadRoom == true) Future.delayed(const Duration(seconds: 1), handleNoMoreRoom);
                return const LoadingIndicator();
              }
              hadRoom ??= true;
              final bool disableControls = snapshot.data!.players.length > 1;

              return _CustomBottomModalSheet(
                players: snapshot.data!.players,
                onStart: onStart,
                child: Scaffold(
                  appBar: const CustomAppBar(),
                  extendBodyBehindAppBar: true,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(child: SizedBox(), flex: 1),
                        Container(
                          height: 200,
                          width: 200,
                          padding: AppPadding.a24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 10),
                                  blurRadius: 18,
                                  spreadRadius: -8,
                                  color: Theme.of(context).primaryColor.withOpacity(.2))
                            ],
                          ),
                          child: QrImage(
                            data: snapshot.data!.id,
                          ),
                        ),
                        Spacers.h32,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(flex: 3, child: SizedBox()),
                            Text(
                              'Vrijeme igre',
                              style: Theme.of(context).textTheme.headline2!.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline2!
                                      .color!
                                      .withOpacity(disableControls ? 0.2 : 1)),
                            ),
                            const Expanded(flex: 1, child: SizedBox()),
                            InkWell(
                              child: Ink(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(disableControls ? 0.2 : 1),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      snapshot.data!.time,
                                      style: Theme.of(context).textTheme.headline5!.copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline5!
                                              .color!
                                              .withOpacity(disableControls ? 0.4 : 1)),
                                    ),
                                    Spacers.w8,
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8, top: 4),
                                      child: Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Theme.of(context).backgroundColor.withOpacity(disableControls ? 0.4 : 1),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onTap: disableControls ? null : onTapTime,
                            ),
                            const Expanded(flex: 3, child: SizedBox()),
                          ],
                        ),
                        const Expanded(child: SizedBox(), flex: 3),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

//? The following class is mostly just animations and showing the players
class _CustomBottomModalSheet extends StatefulWidget {
  final Widget child;
  final List<String> players;
  final VoidCallback onStart;

  const _CustomBottomModalSheet({required this.child, required this.players, required this.onStart});

  @override
  _CustomBottomModalSheetState createState() => _CustomBottomModalSheetState();
}

class _CustomBottomModalSheetState extends State<_CustomBottomModalSheet> {
  bool isFullscreen = false;
  double dragDistance = 0;

  void openFullscreen() => setState(() => isFullscreen = true);
  void closeFullscreen() => setState(() => isFullscreen = false);

  Widget createPlayerListItem(String player, int index) {
    return Text(
      '$index. $player',
      style: Theme.of(context).textTheme.headline1?.copyWith(color: Theme.of(context).primaryColor),
    );
  }

  void handleVerticalDrag(DragUpdateDetails dragUpdateDetails) {
    dragDistance += dragUpdateDetails.delta.dy;
    print('isFullscreen: $isFullscreen - dragDistance: $dragDistance');
    if (isFullscreen && dragDistance > 300) {
      closeFullscreen();
    } else if (!isFullscreen && dragDistance < -300) {
      openFullscreen();
    }
  }

  void handleVerticalDragEnd(DragEndDetails _) {
    dragDistance = 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];

    // Add 3 players to the children list
    children.add(createPlayerListItem(widget.players[0], 1));
    for (int x = 1; x < widget.players.length; x++) {
      children.add(const Padding(padding: AppPadding.v16, child: DottedDivider()));
      children.add(createPlayerListItem(widget.players[x], x + 1));
    }
    final lengthOfPlayers = widget.players.length > 3 ? 5 : children.length;
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          widget.child,
          Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onVerticalDragUpdate: handleVerticalDrag,
              onVerticalDragEnd: handleVerticalDragEnd,
              child: AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                width: MediaQuery.of(context).size.width,
                height: isFullscreen ? MediaQuery.of(context).size.height : 240 + lengthOfPlayers * 34,
                padding: isFullscreen ? const EdgeInsets.symmetric(vertical: 128) : EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: isFullscreen
                      ? BorderRadius.zero
                      : const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                ),
                child: Padding(
                  padding: AppPadding.a48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prijavljena Ekipa',
                        style: Theme.of(context).textTheme.headline1?.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                      ),
                      Spacers.h16,
                      Spacers.h8,
                      ...children
                    ],
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            bottom: isFullscreen ? MediaQuery.of(context).size.height + 22 : 240 + lengthOfPlayers * 34 - 22,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                  size: 44,
                  icon: Icon(Icons.keyboard_arrow_up_rounded, color: Theme.of(context).backgroundColor),
                  onPressed: openFullscreen,
                )
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            top: 80,
            right: isFullscreen ? 32 : -64,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  size: 44,
                  icon: Icon(Icons.close, color: Theme.of(context).backgroundColor),
                  onPressed: closeFullscreen,
                )
              ],
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            bottom: isFullscreen ? -100 : 0,
            width: MediaQuery.of(context).size.width,
            child: Material(
              child: BottomButton(
                onPressed: widget.onStart,
                isDark: true,
                text: AppLocalizations.of(context)?.startAMatch ?? 'Kreni s igrom',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
