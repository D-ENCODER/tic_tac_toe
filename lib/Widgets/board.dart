import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Controllers/board_controller.dart';
import 'package:tic_tac_toe/Controllers/game_controller.dart';
import 'package:tic_tac_toe/Controllers/user_controller.dart';
import 'package:tic_tac_toe/Utils/storage.dart';
import 'package:tic_tac_toe/Widgets/dialogs.dart';

class Cell extends StatelessWidget {
  final String value;
  final VoidCallback onTap;
  final bool disable;

  const Cell(this.value,
      {Key key, @required this.onTap, @required this.disable})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disable ? null : onTap,
      child: Container(
        width: 1 / 3 * (.75 * MediaQuery.of(context).size.width - 48.0),
        height: 1 / 3 * (.75 * MediaQuery.of(context).size.width - 48.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: value != '' ? Image.asset('assets/icons/$value.png') : null,
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({Key key}) : super(key: key);

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  BoardController _boardController;
  GameController _gameController;
  UserController _userController;
  StreamSubscription<Event> _boardStream;
  Storage _storage;
  bool _isHost;
  String _turn;
  String _code;
  String _uid;

  @override
  void initState() {
    _storage = Storage();
    _boardController = BoardController();
    _gameController = GameController();
    _userController = UserController();
    _boardController.subscribeToBoard((event) {
      final value = event.snapshot.value;
      setState(() {
        _boardController.updateBoardState = value['boardState'];
        _uid = _storage.getUID();
        _isHost = (_storage.getUID() == value['host']) ?? false;
        _turn = value['turn'];
        _code = value['code'];
        _showGameResult();
      });
    }).then((stream) {
      _boardStream = stream;
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _boardStream.cancel();
  }

  bool _determineDisableCell() {
    if (_isHost == true && _turn == 'X') {
      return false;
    } else if (_isHost == false && _turn == 'O') {
      return false;
    } else {
      return true;
    }
  }

  void _showGameResult() {
    switch (_boardController.evaluateBoardState(_isHost ? 'X' : 'O')) {
      case BoardStatus.WIN:
        _boardStream.cancel();
        _gameController.updateGamePlay(_code, _isHost, 'win');
        _userController.updateUserGamePlay(_uid, 'win');
        showDialog(
            context: context,
            builder: (ctx) => TheAlert(
                title: 'Game Result',
                content: 'It\'s a win. Congratulations!',
                buttonText: 'Close',
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushNamed(context, 'profile');
                }));
        break;
      case BoardStatus.LOSE:
        _boardStream.cancel();
        _gameController.updateGamePlay(_code, _isHost, 'lose');
        _userController.updateUserGamePlay(_uid, 'lose');
        showDialog(
            context: context,
            builder: (ctx) => TheAlert(
                title: 'Game Result',
                content: 'Alas. You lose',
                buttonText: 'Close',
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushNamed(context, 'profile');
                }));
        break;
      case BoardStatus.DRAW:
        _boardStream.cancel();
        _gameController.updateGamePlay(_code, _isHost, 'draw');
        _userController.updateUserGamePlay(_uid, 'draw');
        showDialog(
            context: context,
            builder: (ctx) => TheAlert(
                title: 'Game Result',
                content: 'It\'s a draw. Good Job!',
                buttonText: 'Close',
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  Navigator.pushNamed(context, 'profile');
                }));
        break;
      case BoardStatus.PLAY:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: .75 * MediaQuery.of(context).size.width,
      height: .75 * MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _boardController.boardState
            .asMap()
            .map((x, row) {
              return MapEntry(
                x,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: row
                      .asMap()
                      .map((y, cell) {
                        return MapEntry(
                          y,
                          Cell(
                            cell,
                            disable: _determineDisableCell(),
                            onTap: () {
                              if (_isHost && _turn == 'X') {
                                setState(() {
                                  if (_boardController.occupy(_turn,
                                      x: x, y: y)) {
                                    _gameController.updateBoardState(_code,
                                        _boardController.boardStateJSON, 'O');
                                  }
                                });
                              }
                              if (!_isHost && _turn == 'O') {
                                setState(() {
                                  if (_boardController.occupy(_turn,
                                      x: x, y: y)) {
                                    _gameController.updateBoardState(_code,
                                        _boardController.boardStateJSON, 'X');
                                  }
                                });
                              }
                            },
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
              );
            })
            .values
            .toList(),
      ),
    );
  }
}
