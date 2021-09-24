import 'package:drink_n_talk/pages/splash_screen.dart';
import 'package:drink_n_talk/services/room_service.dart';
import 'package:drink_n_talk/utils/app_padding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  RoomService.init();
  FlutterScreenWake.keepOn(true);
  FlutterScreenWake.setBrightness(.6);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocaleService _localeService = Provider.of<LocaleService>(context);
    
    return MaterialApp(
      title: 'Drink & Talk',
      theme: kLightTheme,
      darkTheme: kLightTheme,
      locale: _localeService.locale ?? Locale(locale),
      supportedLocales: L10n.all,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
      home: const SplashScreen(),
    );
  }
}

final ThemeData kLightTheme = ThemeData(
  //? Color palette
  primaryColor: const Color(0xFF000000),
  scaffoldBackgroundColor: const Color(0xFFFFAC07),
  splashColor: const Color(0x44FFAC07),
  backgroundColor: const Color(0xFFFFFFFF),
  brightness: Brightness.light,
  buttonTheme: const ButtonThemeData(
    colorScheme: ColorScheme.light(
      primary: Color(0xFFFFAC07),
      secondary: Color(0xFFFFAC07),
    ),
  ),

  dividerColor: const Color(0xFF979797),
  //? Input theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: AppPadding.h32,
    hintStyle: const TextStyle(
      color: Color(0xFFADADAD),
      fontSize: 12,
      fontFamily: 'GothamRounded',
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(200),
    ),
  ),

  //? Snackbar Theme
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black,
    contentTextStyle: TextStyle(fontSize: 16, color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
    behavior: SnackBarBehavior.floating,
  ),

  //? Text theme
  textTheme: const TextTheme(
    // All of the super big fonts, just the color is change
    headline1: TextStyle(
      fontSize: 30,
      fontFamily: 'Baruta',
      color: Color(0xFFFFFFFF),
    ),
    // All of the second biggest fonts (theyre all black)
    headline2: TextStyle(
      fontSize: 19,
      fontFamily: 'Baruta',
      color: Color(0xFF000000),
    ),
    // ModalButton and the timer
    headline3: TextStyle(
      fontSize: 15,
      fontFamily: 'Baruta',
      color: Color(0xFF000000),
    ),
    // Only used for the countdown
    headline4: TextStyle(
      fontSize: 100,
      fontFamily: 'Baruta',
      color: Color(0xFF000000),
    ),
    // Only used for the dropdown
    headline5: TextStyle(
      fontSize: 23,
      fontFamily: 'Baruta',
      color: Color(0xFFFFFFFF),
    ),
    bodyText1: TextStyle(
      fontSize: 16,
      fontFamily: 'GothamRounded',
      fontWeight: FontWeight.w100,
      color: Color(0xFF000000),
    ),
    bodyText2: TextStyle(
      fontSize: 16,
      fontFamily: 'GothamRounded',
      fontWeight: FontWeight.w900,
      color: Color(0xFF000000),
    ),
    button: TextStyle(
      fontSize: 20,
      fontFamily: 'Baruta',
      color: Color(0xFFFFFFFF),
    ),
  ),
);

// TODO: Change dark theme
final ThemeData kDarkTheme = ThemeData();
