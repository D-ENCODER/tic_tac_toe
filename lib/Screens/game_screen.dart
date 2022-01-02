import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Controllers/game_controller.dart';
import 'package:tic_tac_toe/Controllers/user_controller.dart';
import 'package:tic_tac_toe/Utils/storage.dart';
import 'package:tic_tac_toe/Widgets/board.dart';
import 'package:tic_tac_toe/Widgets/cards.dart';

class GameScreen extends StatefulWidget {
  static const String _id = 'game';

  const GameScreen({Key key}) : super(key: key);
  static String get id => _id;

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  GameController _gameController;
  UserController _userController;
  Storage _storage;
  Map _game;
  StreamSubscription<Event> _gameStream;

  String _hostNickName = '', _guestNickName = '';
  bool _isHost;

  @override
  void initState() {
    _storage = Storage();
    _gameController = GameController();
    _userController = UserController();
    _gameController.subscribeToGame((event) {
      final value = event.snapshot.value;
      setState(() {
        _game = {
          'boardState': value['boardState'],
          'code': value['code'],
          'ended': value['ended'],
          'guest': value['guest'],
          'guestResult': value['guestResult'],
          'host': value['host'],
          'hostResult': value['hostResult'],
          'timestamp': value['timestamp'],
          'turn': value['turn']
        };
        _isHost = (_storage.getUID() == value['host']) ?? false;
        print(_game);
      });
      _userController.getNickName(value['host']).then((value) {
        setState(() {
          _hostNickName = value;
        });
      });
      _userController.getNickName(value['guest']).then((value) {
        setState(() {
          _guestNickName = value;
        });
      });
    }).then((stream) {
      _gameStream = stream;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _gameStream.cancel();
  }

  String _determineMessageToShow() {
    String go = 'Your Turn';
    String wait = 'Waiting for your opponent';
    if (_isHost == true && _game['turn'] == 'X') {
      return go;
    } else if (_isHost == false && _game['turn'] == 'O') {
      return go;
    } else {
      return wait;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Image.asset(
                      'assets/icons/brand.png',
                      width: 60.0,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    'Let\'s Play',
                    style: Theme.of(context).textTheme.headline1,
                  )
                ],
              ),
              const SizedBox(height: 12.0),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                PlayerCard(
                  name: _hostNickName,
                  player: 'X',
                ),
                const SizedBox(width: 8.0),
                Text(
                  'VS',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .apply(fontWeightDelta: 2),
                ),
                const SizedBox(width: 8.0),
                PlayerCard(
                  name: _guestNickName,
                  player: 'O',
                ),
              ]),
              const SizedBox(height: 16.0),
              Text(
                _determineMessageToShow(),
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .apply(fontWeightDelta: 2),
              ),
              const SizedBox(height: 16.0),
              Board()
            ]),
          ],
        ),
      ),
    );
  }
}
