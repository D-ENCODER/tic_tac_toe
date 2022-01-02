// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:tic_tac_toe/Utils/storage.dart';

enum BoardStatus { WIN, LOSE, DRAW, PLAY }

class BoardController {
  final Storage _storage = Storage();
  List<List<String>> boardState = [
    ["", "", ""],
    ["", "", ""],
    ["", "", ""],
  ];

  String get boardStateJSON => json.encode(boardState);

  set updateBoardState(String boardStateJSON) {
    final board = json.decode(boardStateJSON);
    List<List<String>> updatedBoardState = [
      ["", "", ""],
      ["", "", ""],
      ["", "", ""],
    ];
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        updatedBoardState[i][j] = board[i][j];
      }
    }
    boardState = updatedBoardState;
  }

  BoardController();

  bool occupy(symbol, {x, y}) {
    if (boardState[x][y] == '') {
      boardState[x][y] = symbol;
      return true;
    }
    return false;
  }

  Future<StreamSubscription<Event>> subscribeToBoard(
      Function(Event) callback) async {
    String code = _storage.getGameCode();
    print('board $code');
    final refs = FirebaseDatabase.instance.reference().child('games/$code');
    return refs.onValue.listen((event) {
      callback(event);
    });
  }

  BoardStatus evaluateBoardState(String player) {
    String startCell = '';

    /// Check Row
    for (int i = 0; i < 3; i++) {
      startCell = boardState[i][0];
      if (startCell.isNotEmpty &&
          boardState[i][1] == startCell &&
          boardState[i][2] == startCell) {
        return startCell == player ? BoardStatus.WIN : BoardStatus.LOSE;
      }
    }

    /// Check Column
    for (int i = 0; i < 3; i++) {
      startCell = boardState[0][i];
      if (startCell.isNotEmpty &&
          boardState[1][i] == startCell &&
          boardState[2][i] == startCell) {
        return startCell == player ? BoardStatus.WIN : BoardStatus.LOSE;
      }
    }

    /// Diagonal Descending
    startCell = boardState[0][0];
    if (startCell.isNotEmpty &&
        boardState[1][1] == startCell &&
        boardState[2][2] == startCell) {
      return startCell == player ? BoardStatus.WIN : BoardStatus.LOSE;
    }

    /// Diagonal Ascending
    startCell = boardState[0][2];
    if (startCell.isNotEmpty &&
        boardState[1][1] == startCell &&
        boardState[2][0] == startCell) {
      return startCell == player ? BoardStatus.WIN : BoardStatus.LOSE;
    }

    int isFilled = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        isFilled += boardState[i][j].isNotEmpty ? 1 : 0;
      }
    }

    if (isFilled == 9) return BoardStatus.DRAW;

    return BoardStatus.PLAY;
  }
}
