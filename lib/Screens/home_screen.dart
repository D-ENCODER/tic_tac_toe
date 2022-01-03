import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
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
  final GetStorage _coinsaver = GetStorage();
  User _user = User.empty();
  RewardedAds ads = RewardedAds();
  AppOpenAds firstad = AppOpenAds();
  final Storage _storage = Storage();

  @override
  void initState() {
    super.initState();
    _userController = UserController();
    _userController.init().then((_) {
      setState(() {
        _user = _userController.user;
      });
      int coin = _user.coin;
      _coinsaver.write('coin', coin);
      firstad.showAd();
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
                            onTap: () =>
                                Navigator.pushNamed(context, 'profile'),
                          ),
                          Text(
                            'Welcome, ${_user.name.toUpperCase()}',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(color: kPrimaryColor),
                          ),
                        ],
                      ),
                    ]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 1 / 8 * MediaQuery.of(context).size.height,
                    ),
                    Container(
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
                              if (_coinsaver.read('coin') >= 100) {
                                _userController.deductCurrency(
                                  _storage.getUID(),
                                  100,
                                );
                                int coin = _coinsaver.read('coin');
                                _coinsaver.write('coin', coin - 100);
                                Navigator.pushNamed(context, 'join_game');
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please earn some money');
                              }
                            },
                          ),
                          const SizedBox(height: 24.0),
                          Button(
                            text: 'HOST GAME (200T)',
                            onPressed: () {
                              if (_coinsaver.read('coin') >= 200) {
                                _userController.deductCurrency(
                                  _storage.getUID(),
                                  200,
                                );
                                int coin = _coinsaver.read('coin');
                                _coinsaver.write('coin', coin - 200);
                                Navigator.pushNamed(context, 'host_game');
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please earn some money');
                              }
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
