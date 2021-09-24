import 'package:drink_n_talk/components/app_button.dart';
import 'package:drink_n_talk/components/bottom_button.dart';
import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:drink_n_talk/components/dotted_divider.dart';
import 'package:drink_n_talk/components/loading_indicator.dart';
import 'package:drink_n_talk/models/room.dart';
import 'package:drink_n_talk/services/room_service.dart';
import 'package:drink_n_talk/utils/app_padding.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({Key? key}) : super(key: key);

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool? hadRoom;
  Future<bool>? createRoomFuture;

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
    RoomService.deleteRoom();
    super.dispose();
  }

  Future<void> handleNoMoreRoom() async {
    hadRoom = false;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ova soba više ne postoji')));
    Navigator.of(context).pop();
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

              return _CustomBottomModalSheet(
                players: snapshot.data!.players,
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

class _CustomBottomModalSheet extends StatefulWidget {
  final Widget child;
  final List<String> players;

  const _CustomBottomModalSheet({Key? key, required this.child, required this.players}) : super(key: key);

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
                onPressed: () {},
                isDark: true,
                text: 'Kreni s igrom',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
