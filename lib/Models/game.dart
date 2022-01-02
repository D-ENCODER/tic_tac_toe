class Game {
  final String code;
  final String boardState;
  final bool ended;
  final String guest;
  final String guestResult;
  final String host;
  final String hostResult;
  final String timestamp;
  final String turn;

  Game(
      {this.code,
      this.boardState,
      this.ended,
      this.guest,
      this.guestResult,
      this.host,
      this.hostResult,
      this.timestamp,
      this.turn});

  factory Game.empty() {
    return Game(
        code: '',
        boardState: "[[\"\",\"\",\"\"],[\"\",\"\",\"\"],[\"\",\"\",\"\"]]",
        ended: false,
        guest: '',
        guestResult: '',
        host: '',
        hostResult: '',
        timestamp: '',
        turn: '');
  }

  Map toGameData() {
    return ({
      'code': code,
      'boardState': boardState,
      'ended': ended,
      'guest': guest,
      'guestResult': guestResult,
      'host': host,
      'hostResult': hostResult,
      'timestamp': timestamp,
      'turn': turn
    });
  }
}
