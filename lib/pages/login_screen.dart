import 'package:drink_n_talk/components/app_button.dart';
import 'package:drink_n_talk/pages/home_screen.dart';
import 'package:drink_n_talk/utils/app_padding.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController textEditingController = TextEditingController();

  Future<void> onLogin(BuildContext context) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    final sharedPrefs = await SharedPreferences.getInstance();
    final String value = textEditingController.text;

    if (value.replaceAll(' ', '').isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)?.nicknameEmpty ??'Nadimak nesmije bit prazan')));
      return;
    }

    await sharedPrefs.setString('username', value);
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
            Padding(
              padding: AppPadding.h32,
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)?.provideUsername ?? 'Daj nadimak ili ime',
                ),
              ),
            ),
            Spacers.h32,
            AppButton(
              text: AppLocalizations.of(context)?.signUp ?? 'Prijavi se',
              size: 140,
              onPressed: () => onLogin(context),
            ),
          ],
        ),
      ),
    );
  }
}
