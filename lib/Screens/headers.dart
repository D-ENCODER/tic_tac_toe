import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Utils/constants.dart';
import 'package:tic_tac_toe/Widgets/buttons.dart';

class Header extends StatelessWidget {
  final String label;

  const Header({Key key, @required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Row(
        children: [
          const UpButton(),
          const SizedBox(width: 8.0),
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .headline2
                  .copyWith(color: kPrimaryLightColor)),
        ],
      ),
    );
  }
}
