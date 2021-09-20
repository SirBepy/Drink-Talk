import 'package:drink_n_talk/pages/splash_screen.dart';
import 'package:drink_n_talk/utils/app_padding.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drink & Talk',
      theme: kLightTheme,
      darkTheme: kLightTheme,
      home: const SplashScreen(),
    );
  }
}

final ThemeData kLightTheme = ThemeData(
  primaryColor: const Color(0xFF000000),
  scaffoldBackgroundColor: const Color(0xFFFFAC07),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(
      color: Color(0xFFADADAD),
      fontSize: 12,
      fontFamily: 'GothamRounded',
    ),
    fillColor: Colors.white,
    contentPadding: AppPadding.h32,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(200),
    ),
  ),
  brightness: Brightness.light,
  textTheme: const TextTheme(
    button: TextStyle(
      fontSize: 20,
      fontFamily: 'Baruta',
      color: Color(0xFFFFFFFF),
    ),
  ),
);

final ThemeData kDarkTheme = ThemeData(
  primaryColor: const Color(0xFF000000),
  scaffoldBackgroundColor: const Color(0xFFFFAC07),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(
      color: Color(0xFFADADAD),
      fontSize: 12,
      fontFamily: 'GothamRounded',
    ),
    fillColor: Colors.white,
    contentPadding: AppPadding.h32,
    filled: true,
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(200),
    ),
  ),
  brightness: Brightness.light,
  textTheme: const TextTheme(
    button: TextStyle(
      fontSize: 20,
      fontFamily: 'Baruta',
      color: Color(0xFFFFFFFF),
    ),
  ),
);
