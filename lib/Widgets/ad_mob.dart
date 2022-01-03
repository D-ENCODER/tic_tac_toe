import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
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
        request: const AdRequest());
    return ad;
  }
}

class AppOpenAds {
  AppOpenAd openAd;
  int times = 0;
  Future<void> loadAd() async {
    await AppOpenAd.load(
        adUnitId: 'ca-app-pub-3212778043779043/8691025612',
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(onAdLoaded: (ad) {
          openAd = ad;
          showAd();
        }, onAdFailedToLoad: (error) {
          if (times > 5) {
          } else {
            times++;
            loadAd();
          }
          loadAd();
        }),
        orientation: AppOpenAd.orientationPortrait);
  }

  void showAd() {
    if (openAd == null) {
      loadAd();
      return;
    }

    openAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {},
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          openAd = null;
          loadAd();
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          openAd = null;
        });

    openAd.show();
  }
}

class RewardedAds {
  RewardedAd _rewardedAd;
  int times = 0;
  final UserController _user = UserController();
  final GetStorage _coin = GetStorage();

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
          if (times > 5) {
            Fluttertoast.showToast(
                msg: 'No ads available please try again later');
          } else {
            loadRewardedAd();
            times++;
          }
        }));
  }

  void showRewardedAd() {
    _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem rpoint) {
      String uid = FirebaseAuth.instance.currentUser.uid;
      Fluttertoast.showToast(msg: 'Congrats you earned ${rpoint.amount} T');
      _user.updateAdCurrency(uid);
      int coins = _coin.read('coin');
      _coin.write('coin', coins + 200);
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
