import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tic_tac_toe/Controllers/auth_controller.dart';
import 'package:tic_tac_toe/Utils/constants.dart';
import 'package:tic_tac_toe/Widgets/already_have_account.dart';
import 'package:tic_tac_toe/Widgets/rounded_button.dart';
import 'package:tic_tac_toe/Widgets/rounded_input_field.dart';
import 'package:tic_tac_toe/Widgets/rounded_password_field.dart';

class SignUpScreen extends StatefulWidget {
  static const String _id = 'sign_up';
  const SignUpScreen({Key key}) : super(key: key);
  static String get id => _id;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  final Map _user = {
    "name": '',
    "nickname": '',
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

  String confirmPassword = '';
  bool visible = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Background1(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.05),
                SvgPicture.asset(
                  "assets/icons/signup.svg",
                  height: size.height * 0.35,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundedInputField(
                        hintText: "Name",
                        onChanged: (value) {
                          _user["name"] = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '* Required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      RoundedInputField(
                        hintText: "Nick Name (max. 8 character long)",
                        icon: Icons.account_circle,
                        onChanged: (value) {
                          _user["nickname"] = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return '* Required';
                          }
                          if (value.length < 8) {
                            return 'Nickname should be atleast 8 characters long';
                          } else {
                            return null;
                          }
                        },
                      ),
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
                      RoundedPasswordField(
                        onChanged: (value) {
                          confirmPassword = value;
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
                          if (confirmPassword != _user["password"]) {
                            return 'Passwords don\'t match';
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
                      ),
                    ],
                  ),
                ),
                RoundedButton(
                  text: "SIGN UP",
                  onPressed: () async {
                    if (_validateForm()) {
                      await _authController.registerWithEmailAndPassword(_user);
                      Navigator.pushNamed(context, 'login');
                    }
                  },
                ),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  login: false,
                  press: () {
                    Navigator.pushNamed(context, 'login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Background1 extends StatelessWidget {
  final Widget child;
  const Background1({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/vectors/signup_top.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              "assets/vectors/main_bottom.png",
              width: size.width * 0.25,
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          buildDivider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "OR",
              style: TextStyle(
                color: Color(0xFF6F35A5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          buildDivider(),
        ],
      ),
    );
  }

  Expanded buildDivider() {
    return const Expanded(
      child: Divider(
        color: Color(0xFFD9D9D9),
        height: 1.5,
      ),
    );
  }
}

class SocalIcon extends StatelessWidget {
  final String iconSrc;
  final Function press;
  const SocalIcon({
    Key key,
    this.iconSrc,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: const Color(0xFFF1E6FF),
          ),
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          iconSrc,
          height: 20,
          width: 20,
        ),
      ),
    );
  }
}
