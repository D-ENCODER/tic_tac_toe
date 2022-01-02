class User {
  final String name;
  final String nickname;
  final String email;
  final int gamesPlayed;
  final int gamesWon;
  final int gamesLost;
  final int gamesDrawn;
  final int coin;

  User(
      {this.name,
      this.nickname,
      this.email,
      this.gamesPlayed,
      this.gamesWon,
      this.gamesDrawn,
      this.gamesLost,
      this.coin});

  factory User.empty() {
    return User(
      name: '',
      nickname: '',
      email: '',
      gamesPlayed: 0,
      gamesWon: 0,
      gamesLost: 0,
      gamesDrawn: 0,
      coin: 0,
    );
  }

  List<Map> toProfileData() {
    return [
      _mapProfileData('Nick Name', nickname, 'email'),
      _mapProfileData('Total Games Played', gamesPlayed, 'game'),
      _mapProfileData('Total Wons', gamesWon, 'win'),
      _mapProfileData('Total Losts', gamesLost, 'lose'),
      _mapProfileData('Total Drawns', gamesDrawn, 'draw'),
      _mapProfileData('Coins', coin, 'coin')
    ];
  }

  Map _mapProfileData(label, value, icon) {
    return {
      'label': label,
      'value': value.toString(),
      'icon': icon,
    };
  }
}
