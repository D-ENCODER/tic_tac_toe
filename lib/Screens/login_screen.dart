import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tic_tac_toe/Controllers/auth_controller.dart';
import 'package:tic_tac_toe/Utils/constants.dart';
import 'package:tic_tac_toe/Widgets/already_have_account.dart';
import 'package:tic_tac_toe/Widgets/rounded_button.dart';
import 'package:tic_tac_toe/Widgets/rounded_input_field.dart';
import 'package:tic_tac_toe/Widgets/rounded_password_field.dart';

import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String _id = 'login';
  const LoginScreen({Key key}) : super(key: key);
  static String get id => _id;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool visible = false;
  final _formKey = GlobalKey<FormState>();
  AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _authController.isAuthenticated().then((value) {
      if (value) {
        Navigator.popAndPushNamed(context, 'home');
      }
    });
  }

  final Map _user = {
    "email": '',
    "password": '',
  };

  bool _validateForm() {
    final form = _formKey.currentState;
    bool isValid = form.validate();
    if (isValid) {
      form.save();
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Background(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.05),
                SvgPicture.asset(
                  "assets/icons/login.svg",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.03),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundedInputField(
                        hintText: "Email",
                        icon: Icons.alternate_email_rounded,
                        onChanged: (value) {
                          _user["email"] = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '* Required';
                          }
                          if (value.contains('@') == false) {
                            return 'Invalid email address';
                          } else {
                            return null;
                          }
                        },
                      ),
                      RoundedPasswordField(
                        onChanged: (value) {
                          _user["password"] = value;
                        },
                        visible: (visible == true)
                            ? false
                            : (visible == false)
                                ? true
                                : false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return '* Required';
                          }
                          if (value.length < 8) {
                            return 'Password should be atleast 8 characters long';
                          }
                          if (value.contains(RegExp(r'[A-Z]')) == false) {
                            return 'Password should also contain capital letters';
                          }
                          if (value.contains(RegExp(r'[a-z]')) == false) {
                            return 'Password should also contain small letters';
                          }
                          if (value.contains(RegExp(r'[0-9]')) == false) {
                            return 'Password should also contain number';
                          }
                          if (value.contains(RegExp(r'(?=.*?[!@#\$&*~])')) ==
                              false) {
                            return 'Password should also contain special characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Checkbox(
                              activeColor: kPrimaryColor,
                              value: visible,
                              onChanged: (value) {
                                setState(() {
                                  visible = value;
                                });
                              }),
                          const Text(
                            'Show Password',
                            style: TextStyle(color: kPrimaryColor),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                RoundedButton(
                  text: "LOGIN",
                  onPressed: () async {
                    if (_validateForm()) {
                      Map<String, dynamic> response = await _authController
                          .signInWithEmailAndPassword(_user);
                      if (response['isAuthenticated']) {
                        Navigator.popAndPushNamed(context, 'home');
                      } else {
                        Fluttertoast.showToast(msg: 'Please verify your email');
                      }
                    }
                  },
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.pushNamed(context, 'sign_up');
                  },
                ),
                const OrDivider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SocalIcon(
                      iconSrc: "assets/icons/google-plus.svg",
                      press: () async {
                        if (await _authController.signInWithGoogle()) {
                          Navigator.popAndPushNamed(context, 'home');
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/vectors/main_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/vectors/login_bottom.png",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
