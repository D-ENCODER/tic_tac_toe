import 'package:flutter/material.dart';
import 'package:tic_tac_toe/Controllers/auth_controller.dart';
import 'package:tic_tac_toe/Controllers/user_controller.dart';
import 'package:tic_tac_toe/Models/user.dart';
import 'package:tic_tac_toe/Screens/headers.dart';
import 'package:tic_tac_toe/Utils/constants.dart';
import 'package:tic_tac_toe/Widgets/buttons.dart';
import 'package:tic_tac_toe/Widgets/icons.dart';
import 'package:tic_tac_toe/Widgets/lists.dart';

class ProfileScreen extends StatefulWidget {
  static const String _id = 'profile';

  const ProfileScreen({Key key}) : super(key: key);
  static String get id => _id;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController _userController;
  AuthController _authController;
  User _user = User.empty();

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
    _userController = UserController();
    _userController.init().then((_) {
      setState(() {
        _user = _userController.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                // Positioned(
                //   top: -1 / 5 * MediaQuery.of(context).size.height,
                //   left: -1 / 4 * MediaQuery.of(context).size.width,
                //   child: SizedBox(
                //     width: 3 / 2 * MediaQuery.of(context).size.width,
                //     child: Image.asset('assets/vectors/profile_blob.png'),
                //   ),
                // ),
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
                  child: Column(
                    children: [
                      const Header(label: 'Profile'),
                      const SizedBox(height: 24.0),
                      const TheIcon('profile', xl: true),
                      const SizedBox(height: 8.0),
                      Text(
                        _user.name.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(color: kPrimaryColor),
                      ),
                      const SizedBox(height: 40.0),
                      ..._user.toProfileData().map((profile) {
                        return InformationList(
                          icon: profile['icon'],
                          label: profile['label'],
                          value: profile['value'],
                        );
                      }).toList(),
                      const SizedBox(height: 32.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16.0),
                            Button(
                              text: 'Log Out',
                              onPressed: () async {
                                await _authController.logout();
                                Navigator.pushNamedAndRemoveUntil(
                                    context, 'login', (route) => false);
                              },
                              color: kPrimaryColor,
                              dark: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
