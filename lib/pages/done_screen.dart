import 'package:confetti/confetti.dart';
import 'package:drink_n_talk/components/bottom_button.dart';
import 'package:drink_n_talk/utils/app_padding.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoneScreen extends StatefulWidget {
  final String? loser;
  const DoneScreen({Key? key, this.loser}) : super(key: key);

  @override
  State<DoneScreen> createState() => _DoneScreenState();
}

class _DoneScreenState extends State<DoneScreen> {
  late ConfettiController _controllerCenter;
  @override
  void initState() {
    super.initState();
    _controllerCenter = ConfettiController(duration: const Duration(seconds: 3));
    playConfettiIfUserNotLoser();
  }

  Future<void> playConfettiIfUserNotLoser() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    if (widget.loser != sharedPrefs.getString('username')) _controllerCenter.play();
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.width - 140,
                  width: MediaQuery.of(context).size.width - 100,
                  padding: AppPadding.a24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(56),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 12),
                        blurRadius: 24,
                        spreadRadius: 0,
                        color: Theme.of(context).primaryColor.withOpacity(.2),
                      )
                    ],
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/end.svg'),
                      if (widget.loser == null) ...[
                        Spacers.h16,
                        Text(
                          'Bravo!',
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        Spacers.h16,
                        Text(
                          'Vi ste prava ekipa\nkoja može zaboraviti\ntehnologiju na tren.',
                          style: Theme.of(context).textTheme.headline2!,
                          textAlign: TextAlign.center,
                        ),
                        Spacers.h64,
                      ] else ...[
                        Spacers.h16,
                        Text(
                          'Luuuzeer je...',
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
                        ),
                        Spacers.h16,
                        Text(
                          widget.loser!,
                          style: Theme.of(context).textTheme.headline2!,
                        ),
                        Spacers.h16,
                        Text(
                          'Ne sluša ekipu\ni plaća ovu rundu',
                          style: Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Theme.of(context).scaffoldBackgroundColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      Spacers.h64,
                      Spacers.h64,
                    ],
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              emissionFrequency: .3,
              numberOfParticles: 10,
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.yellow, Colors.purple],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomButton(
              text: 'Nova igra?',
              onPressed: Navigator.of(context).pop,
            ),
          ),
        ],
      ),
    );
  }
}
