import 'package:flutter/material.dart';

class TheAlert extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback onPressed;

  const TheAlert({this.title, this.content, this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText2,
      ),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          child: Text(
            buttonText,
            style: Theme.of(context).textTheme.button,
          ),
          onPressed: onPressed,
        ),
      ],
    );
  }
}
