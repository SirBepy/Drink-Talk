import 'package:drink_n_talk/components/app_button.dart';
import 'package:drink_n_talk/pages/home_screen.dart';
import 'package:drink_n_talk/utils/app_padding.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void onLogin(BuildContext context) {
    // TODO: Add firebase logic
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                width: 200,
              ),
            ),
            Spacers.h32,
            const Padding(
              padding: AppPadding.h32,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Daj nadimak ili ime',
                ),
              ),
            ),
            Spacers.h32,
            AppButton(
              text: 'Prijavi se',
              size: 140,
              onPressed: () => onLogin(context),
            ),
          ],
        ),
      ),
    );
  }
}
