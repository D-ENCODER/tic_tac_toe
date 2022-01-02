import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Utils/constants.dart';

class SplashScreen extends StatefulWidget {
  static const String _id = 'splashscreen';
  static String get id => _id;
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  double _fontSize = 2;
  double _containerSize = 1.5;
  double _textOpacity = 0.0;
  double _containerOpacity = 0.0;

  AnimationController _controller;
  Animation<double> animation1;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    animation1 = Tween<double>(begin: 40, end: 20).animate(CurvedAnimation(
        parent: _controller, curve: Curves.fastLinearToSlowEaseIn))
      ..addListener(() {
        setState(() {
          _textOpacity = 1.0;
        });
      });

    _controller.forward();

    Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        _fontSize = 1;
      });
    });

    Timer(const Duration(milliseconds: 2250), () {
      setState(() {
        _containerSize = 2;
        _containerOpacity = 1;
      });
    });

    Timer(
      const Duration(seconds: 4),
      () {
        setState(
          () {
            Navigator.popAndPushNamed(
              context,
              'login',
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: kPrimaryLightColor,
        body: Stack(
          children: [
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: (_height - 150) / _fontSize,
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 1000),
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      Text(
                        'Made By',
                        style: TextStyle(
                          fontSize: animation1.value - 5,
                          letterSpacing: 1,
                          fontFamily: 'Nunito',
                          color: kPrimaryMediumColor,
                        ),
                      ),
                      Text(
                        'DENCODER',
                        style: TextStyle(
                          letterSpacing: 2,
                          fontSize: animation1.value,
                          color: kPrimaryColor,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 2000),
                curve: Curves.fastLinearToSlowEaseIn,
                opacity: _containerOpacity,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 2000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  height: _width / _containerSize,
                  width: _width / _containerSize,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Image.asset('assets/icons/brand.png'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
