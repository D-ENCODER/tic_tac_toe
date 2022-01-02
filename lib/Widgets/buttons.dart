// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Utils/constants.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final bool dark;
  final bool disabled;

  const Button({
    @required this.text,
    @required this.onPressed,
    this.color,
    this.dark = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        onPressed: disabled ? null : onPressed,
        color: color != null ? color : kPrimaryColor,
        disabledColor: Colors.grey[300],
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16.0,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(color: kPrimaryLightColor),
        ));
  }
}

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleButton({Key key, @required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
              image: AssetImage('assets/icons/google.png'), height: 32.0),
          const SizedBox(width: 8.0),
          Text('GOOGLE', style: Theme.of(context).textTheme.button),
        ],
      ),
    );
  }
}

class UpButton extends StatelessWidget {
  const UpButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            width: 36.0,
            height: 36.0,
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/up_button.png'),
          ),
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const ProfileButton({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 1 / 6 * MediaQuery.of(context).size.width,
            height: 1 / 6 * MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/profile.png'),
          ),
        ),
      ),
    );
  }
}
