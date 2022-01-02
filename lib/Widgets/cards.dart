import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Widgets/icons.dart';

final BoxDecoration _boxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(16.0),
  color: Colors.white,
  boxShadow: [
    const BoxShadow(
      color: Colors.black26,
      offset: Offset(0.0, 2.0),
      blurRadius: 4.0,
    ),
  ],
);

String _parseAssetName(name) => 'assets/icons/$name.png';

class GameCard extends StatelessWidget {
  final String roomId;
  final String username;
  final String win;
  final String lose;
  final String draw;
  final VoidCallback onTap;

  GameCard({
    @required this.roomId,
    @required this.username,
    @required this.win,
    @required this.lose,
    @required this.draw,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: _boxDecoration,
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 16.0),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 72.0,
                  height: 72.0,
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(_parseAssetName('profile')),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username ?? '',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Row(
                      children: [
                        Text(
                          'Win: ${win ?? 0}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .apply(color: const Color(0xff4caf50)),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Lose: ${lose ?? 0}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .apply(color: const Color(0xffff0303)),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          'Draw: ${draw ?? 0}',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .apply(color: const Color(0xffffc803)),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Positioned(
              right: 8.0,
              child: Text(
                '#$roomId',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextCard extends StatelessWidget {
  final String text;
  final TextStyle textStyle;

  TextCard(this.text, {this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
          boxShadow: [
            const BoxShadow(
              color: Colors.black26,
              offset: const Offset(0.0, 2.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        width: MediaQuery.of(context).size.width * 0.6,
        alignment: Alignment.center,
        child: Text(text, style: textStyle));
  }
}

class ScoreCard extends StatelessWidget {
  final Map<String, int> scores;

  ScoreCard(this.scores);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: scores
          .map((key, value) => MapEntry(
              key,
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(children: [
                    Image.asset(_parseAssetName(key), width: 24.0),
                    Text(
                      value.toString(),
                      style: Theme.of(context).textTheme.caption,
                    )
                  ]))))
          .values
          .toList(),
    ));
  }
}

class PlayerCard extends StatelessWidget {
  final String name;
  final String player;

  PlayerCard({
    @required this.name,
    @required this.player,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.36,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Column(children: [
              TheIcon('profile', lg: true),
              const SizedBox(height: 8.0),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(height: 2.0),
              Text(
                'Player: $player',
                style: Theme.of(context).textTheme.bodyText1,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
