import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AnchorText extends StatelessWidget {
  final String leftText;
  final String rightText;
  final VoidCallback onTap;

  const AnchorText({
    @required this.leftText,
    @required this.rightText,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(text: leftText, style: Theme.of(context).textTheme.bodyText1),
      TextSpan(
          text: rightText,
          recognizer: TapGestureRecognizer()..onTap = onTap,
          style: Theme.of(context).textTheme.bodyText1.apply(
                color: Theme.of(context).primaryColor,
                fontWeightDelta: 2,
              ))
    ]));
  }
}
