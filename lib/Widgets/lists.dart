import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Widgets/icons.dart';

class InformationList extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  InformationList({
    @required this.icon,
    @required this.label,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 1 / 6 * MediaQuery.of(context).size.width,
        vertical: 8.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TheIcon(icon),
          SizedBox(width: 16.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.caption),
                Text(value, style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
