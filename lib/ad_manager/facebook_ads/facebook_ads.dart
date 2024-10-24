import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/widgets.dart';

class FacebookAds {
  static final FacebookAds _instance = FacebookAds._internal();
  bool _isAdLoaded = false;
  //final int _clickThreshold = 4; // Show ad after 4 clicks

  factory FacebookAds() {
    return _instance;
  }

  FacebookAds._internal();

  void initialize() {
    FacebookAudienceNetwork.init();
  }

  void loadInterstitialFacebook() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503", // Test Placement ID
      listener: (result, value) {
        if (result == InterstitialAdResult.LOADED) {
          print("Facebook Interstitial Ad Loaded");
          _isAdLoaded = true;
          FacebookInterstitialAd.showInterstitialAd();
        } else if (result == InterstitialAdResult.ERROR) {
          print("Error loading facebook interstitial ad: $value");
          _isAdLoaded = false;
        }
      },
    );
  }

  void showInterstitialAd() {
    if (_isAdLoaded) {
      FacebookInterstitialAd.showInterstitialAd();
      _isAdLoaded = false; //Reset after showing the ad
    } else {
      print('Facebook ad is not ready');
    }
  }

  bool isAdReady() {
    return _isAdLoaded;
  }

  // Banner Ad
  Widget loadBannerAd() {
    return FacebookBannerAd(
      placementId: "IMG_16_9_APP_INSTALL#2312433698835503", // Test Placement ID
      bannerSize: BannerSize.STANDARD,
      listener: (result, value) {
        switch (result) {
          case BannerAdResult.ERROR:
            print("Error: $value");
            break;
          case BannerAdResult.LOADED:
            print("Banner Ad Loaded: $value");
            break;
          case BannerAdResult.CLICKED:
            print("Banner Ad Clicked");
            break;
          case BannerAdResult.LOGGING_IMPRESSION:
            print("Banner Ad Impression logged");
            break;
        }
      },
    );
  }
}
