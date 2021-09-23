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

  Widget createPlayerListItem(String player, int index) {
    return Text(
      '$index. $player',
      style: Theme.of(context).textTheme.headline1?.copyWith(color: Theme.of(context).primaryColor),
    );
  }

  Widget createPlayersList(List<String> players) {
    final List<Widget> children = [];

    children.add(createPlayerListItem(players[0], 1));

    for (int x = 1; x < players.length; x++) {
      children.add(const Padding(padding: AppPadding.v16, child: DottedDivider()));
      children.add(createPlayerListItem(players[x], x + 1));
    }

    return Padding(
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
    );
  }

  Future<void> handleNoMoreRoom() async {
    hadRoom = false;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ova soba više ne postoji')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      extendBodyBehindAppBar: true,
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

              return Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                        )
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        createPlayersList(snapshot.data!.players),
                        Material(
                          child: BottomButton(
                            onPressed: () {},
                            isDark: true,
                            text: 'Kreni s igrom',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
