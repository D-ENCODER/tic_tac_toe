import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tic_tac_toe/Utils/constants.dart';
import 'package:tic_tac_toe/Screens/login_screen.dart';
import 'package:tic_tac_toe/Screens/about_screen.dart';
import 'package:tic_tac_toe/Screens/game_screen.dart';
import 'package:tic_tac_toe/Screens/home_screen.dart';
import 'package:tic_tac_toe/Screens/host_game_scree.dart';
import 'package:tic_tac_toe/Screens/join_game_screen.dart';
import 'package:tic_tac_toe/Screens/profile_screen.dart';
import 'package:tic_tac_toe/Screens/signup_screen.dart';
import 'package:tic_tac_toe/Screens/splash_screen.dart';

final kTheme = ThemeData(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kPrimaryLightColor,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      button: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      bodyText1: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w800),
      headline1: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w900),
      headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w800),
      headline6: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w900),
      caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
    ));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe',
      debugShowCheckedModeBanner: false,
      theme: kTheme,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
        SignUpScreen.id: (context) => const SignUpScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        ProfileScreen.id: (context) => const ProfileScreen(),
        JoinGameScreen.id: (context) => const JoinGameScreen(),
        GameScreen.id: (context) => const GameScreen(),
        AboutScreen.id: (context) => const AboutScreen(),
        HostGameScreen.id: (context) => const HostGameScreen(),
      },
    );
  }
}
