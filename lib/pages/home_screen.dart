import 'package:drink_n_talk/components/app_button.dart';
import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void onCreate() {
    // TODO: Add firebase logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                width: 180,
              ),
            ),
            Spacers.h32,
            Spacers.h8,
            Text('Hellou', style: Theme.of(context).textTheme.headline1),
            Text(
              'Predrag',
              style: Theme.of(context).textTheme.headline1!.copyWith(color: Theme.of(context).primaryColor),
            ),
            Spacers.h64,
            AppButton(
              text: 'Kreiraj Igru',
              size: 180,
              onPressed: onCreate,
            ),
            Spacers.h64,
          ],
        ),
      ),
    );
  }
}
