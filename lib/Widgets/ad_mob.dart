import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:tic_tac_toe/Controllers/user_controller.dart';

class AdMobService {
  static BannerAd createBannerAd() {
    BannerAd ad = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3212778043779043/7372422127',
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {},
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
          onAdOpened: (Ad ad) {},
          onAdClosed: (Ad ad) {},
        ),
        request: AdRequest());
    return ad;
  }
}

class RewardedAds {
  RewardedAd _rewardedAd;
  final UserController _user = UserController();

  void loadRewardedAd() {
    RewardedAd.load(
        adUnitId: 'ca-app-pub-3212778043779043/9834933931',
        request: const AdRequest(),
        rewardedAdLoadCallback:
            RewardedAdLoadCallback(onAdLoaded: (RewardedAd ad) {
          Fluttertoast.showToast(msg: 'ad loaded');
          _rewardedAd = ad;
          showRewardedAd();
        }, onAdFailedToLoad: (LoadAdError error) {
          Fluttertoast.showToast(msg: error.message);
          loadRewardedAd();
        }));
  }

  void showRewardedAd() {
    _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem rpoint) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      Fluttertoast.showToast(msg: 'Congrats you earned ${rpoint.amount} T');
      _user.updateAdCurrency(uid);
    });
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (RewardedAd ad) {},
        onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
          ad.dispose();
        },
        onAdDismissedFullScreenContent: (RewardedAd ad) {
          ad.dispose();
        });
  }
}
