import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tic_tac_toe/Controllers/user_controller.dart';
import 'package:tic_tac_toe/Models/user.dart';
import 'package:tic_tac_toe/Utils/constants.dart';
import 'package:tic_tac_toe/Utils/storage.dart';
import 'package:tic_tac_toe/Widgets/ad_mob.dart';
import 'package:tic_tac_toe/Widgets/buttons.dart';

class HomeScreen extends StatefulWidget {
  static const String _id = 'home';

  const HomeScreen({Key key}) : super(key: key);
  static String get id => _id;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserController _userController;
  User _user = User.empty();
  RewardedAds ads = RewardedAds();
  final Storage _storage = Storage();

  @override
  void initState() {
    super.initState();
    _userController = UserController();
    _userController.init().then((_) {
      setState(() {
        _user = _userController.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          height: 50,
          child: AdWidget(
            key: UniqueKey(),
            ad: AdMobService.createBannerAd()..load(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ProfileButton(
                          onTap: () => Navigator.pushNamed(context, 'profile'),
                        ),
                        Text(
                          'Hi, ${_user.name.toUpperCase()}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              .copyWith(color: kPrimaryColor),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.1,
                            child: Image.asset('assets/icons/coin.png'),
                          ),
                          Text('${_user.coin}' + 'T',
                              style: const TextStyle(color: kPrimaryColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 1 / 8 * MediaQuery.of(context).size.height,
                    ),
                    Container(
                      // alignment: Alignment.center,
                      margin: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Image.asset(
                        'assets/icons/brand.png',
                        width: MediaQuery.of(context).size.width * 0.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 32.0),
                          Button(
                            text: 'JOIN GAME (100T)',
                            onPressed: () {
                              _userController.deductCurrency(
                                  _storage.getUID(), 100);
                              Navigator.pushNamed(context, 'join_game');
                            },
                          ),
                          const SizedBox(height: 24.0),
                          Button(
                            text: 'HOST GAME (200T)',
                            onPressed: () {
                              _userController.deductCurrency(
                                  _storage.getUID(), 200);
                              Navigator.pushNamed(context, 'host_game');
                            },
                          ),
                          const SizedBox(height: 24.0),
                          Button(
                              text: 'Earn (200T)',
                              onPressed: () => ads.loadRewardedAd()),
                          const SizedBox(height: 24.0),
                          Button(
                            text: 'ABOUT',
                            onPressed: () =>
                                Navigator.pushNamed(context, 'about'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
