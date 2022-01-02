import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:tic_tac_toe/Controllers/board_controller.dart';
import 'package:tic_tac_toe/Utils/storage.dart';

class GameController {
  Storage _storage = Storage();
  BoardController _boardController = BoardController();

  Future<void> init() async {
    String code = _storage.getGameCode();

    final refLobby =
        FirebaseDatabase.instance.reference().child('lobbies/$code');

    final snapshot = await refLobby.once();
    print(snapshot.value);

    final refGames = FirebaseDatabase.instance.reference().child('games/$code');
    refGames.set({
      'code': code,
      'boardState': _boardController.boardStateJSON,
      'ended': false,
      'guest': snapshot.value['guest'],
      'guestResult': '',
      'host': snapshot.value['host'],
      'hostResult': '',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'turn': 'X',
    });
  }

  Future<void> joinGame(String code) async {
    String uid = _storage.getUID();

    final refs = FirebaseDatabase.instance.reference().child('lobbies/$code');
    refs.update({
      'guest': uid,
    });

    await _storage.setGameCode(code);
  }

  Future<StreamSubscription<Event>> subscribeToGame(
      Function(Event) callback) async {
    String code = _storage.getGameCode();

    final refs = FirebaseDatabase.instance.reference().child('games/$code');
    return refs.onValue.listen((event) {
      callback(event);
    });
  }

  Future<void> updateBoardState(
      String code, String boardState, String turn) async {
    final refs = FirebaseDatabase.instance.reference().child('games/$code');
    refs.update({
      'boardState': boardState,
      'turn': turn,
    });
  }

  Future<void> updateGamePlay(String code, bool isHost, String result) async {
    final refs = FirebaseDatabase.instance.reference().child('games/$code');
    refs.update(isHost
        ? {'hostResult': result, 'ended': true}
        : {'guestResult': result});
  }
}
