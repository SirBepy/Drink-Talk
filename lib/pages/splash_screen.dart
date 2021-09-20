import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void redirect(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => redirect(context));

    return Scaffold(
      body: Hero(
        tag: 'logo',
        child: Center(
          child: SvgPicture.asset('assets/images/logo.svg'),
        ),
      ),
    );
  }
}
