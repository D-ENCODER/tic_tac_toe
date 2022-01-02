import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tic_tac_toe/Controllers/game_controller.dart';
import 'package:tic_tac_toe/Controllers/lobby_controller.dart';
import 'package:tic_tac_toe/Models/user.dart';
import 'package:tic_tac_toe/Screens/headers.dart';
import 'package:tic_tac_toe/Utils/storage.dart';
import 'package:tic_tac_toe/Widgets/cards.dart';
import 'package:tic_tac_toe/Widgets/inputs.dart';

class JoinGameScreen extends StatefulWidget {
  static const String _id = 'join_game';

  const JoinGameScreen({Key key}) : super(key: key);
  static String get id => _id;

  @override
  _JoinGameScreenState createState() => _JoinGameScreenState();
}

class _JoinGameScreenState extends State<JoinGameScreen> {
  LobbyController _lobbyController;
  GameController _gameController;
  List _lobbies = [];
  List _filteredLobbies = [];
  final Map<String, User> _users = {};
  String _uid = '';
  StreamSubscription<Event> _lobbyStream;
  final Storage _storage = Storage();

  @override
  void initState() {
    super.initState();
    _loadUserUidFromStorage();
    _lobbyController = LobbyController();
    _gameController = GameController();
    _lobbyStream = _lobbyController.subscribeToLobbies((event) {
      setState(() {
        if (event.snapshot.value == null) {
          Fluttertoast.showToast(
              msg: 'Please host a game first', toastLength: Toast.LENGTH_LONG);
        } else {
          _lobbies = event.snapshot.value.entries
              .where((lobby) =>
                  lobby.value['guest'] == null && lobby.value['host'] != _uid)
              .toList();
          _filteredLobbies = _lobbies;
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _lobbyStream.cancel();
  }

  void _loadUserUidFromStorage() async {
    setState(() {
      _uid = _storage.getUID();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 0.0),
              child: Header(
                label: 'Join Game',
              ),
            ),
            const SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Input(
                onSaved: (value) => value,
                validator: (value) => value,
                leftIcon: 'search',
                type: 'search',
                onChanged: (string) {
                  setState(() {
                    _filteredLobbies = _lobbies
                        .where((lobby) =>
                            lobby.value['code'].toString().contains(string))
                        .toList();
                  });
                },
              ),
            ),
            const SizedBox(height: 24.0),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredLobbies.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final code = _filteredLobbies[index].key;
                  final hostUid = _filteredLobbies[index].value['host'];
                  if (_users[code] == null) {
                    _lobbyController.getUserData(hostUid).then((user) {
                      setState(() {
                        _users[code] = user;
                      });
                    });
                  }
                  return GameCard(
                      roomId: code,
                      username: _users[code].name,
                      win: _users[code].gamesWon.toString(),
                      lose: _users[code].gamesLost.toString(),
                      draw: _users[code].gamesDrawn.toString(),
                      onTap: () async {
                        await _gameController.joinGame(code);
                        Navigator.popAndPushNamed(context, 'game');
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
