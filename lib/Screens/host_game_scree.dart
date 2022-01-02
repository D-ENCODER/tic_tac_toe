import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Controllers/game_controller.dart';
import 'package:tic_tac_toe/Controllers/lobby_controller.dart';
import 'package:tic_tac_toe/Screens/headers.dart';
import 'package:tic_tac_toe/Widgets/buttons.dart';
import 'package:tic_tac_toe/Widgets/cards.dart';

class HostGameScreen extends StatefulWidget {
  static const String _id = 'host_game';

  const HostGameScreen({Key key}) : super(key: key);
  static String get id => _id;

  @override
  _HostGameScreenState createState() => _HostGameScreenState();
}

class _HostGameScreenState extends State<HostGameScreen> {
  LobbyController _lobbyController;
  GameController _gameController;
  StreamSubscription<Event> _hostedStream;
  String _code = '';
  bool _disabled = true;

  @override
  void initState() {
    super.initState();
    _lobbyController = LobbyController();
    _gameController = GameController();
    _lobbyController.hostAndSubscribeToLobby((event) async {
      setState(() {
        _code = event.snapshot.value['code'];
      });
      if (event.snapshot.value['guest'] != null) {
        setState(() {
          _disabled = false;
        });
      }
    }).then((stream) {
      _hostedStream = stream;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _hostedStream.cancel();
    _lobbyController.disposeLobbyWhenExit(_code);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
            child: Header(
              label: 'Host Game',
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Image(
                    image: const AssetImage('assets/vectors/host_game.png'),
                    width: MediaQuery.of(context).size.width * 0.8,
                  ),
                ),
                const SizedBox(height: 32.0),
                Text(
                  'Game Code',
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .apply(fontWeightDelta: 2),
                ),
                TextCard(_code,
                    textStyle: Theme.of(context).textTheme.headline1),
                const SizedBox(height: 48.0),
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Button(
                    text: 'LET\'S GO',
                    color: Theme.of(context).primaryColor,
                    disabled: _disabled,
                    onPressed: () {
                      _gameController.init();
                      Navigator.pushReplacementNamed(context, 'game');
                    },
                  ),
                ),
                const SizedBox(height: 32.0),
                Text(
                  _disabled ? 'Waiting for other player ...' : 'LET\'S GO',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ]),
            ),
          ),
        ],
      )),
    );
  }
}
