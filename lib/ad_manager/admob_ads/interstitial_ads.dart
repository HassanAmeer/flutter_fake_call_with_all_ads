import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobAds {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  BannerAd? _bannerAd;

  // Initialize Banner Ad
  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-5080833301669041/8364859227', // Replace with your banner ad unit ID
      size: AdSize.banner, // You can choose other sizes like AdSize.largeBanner
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Banner Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Banner Ad failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
  }

  // Widget to display the banner ad
  Widget getBannerAdWidget() {
    if (_bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return const SizedBox
          .shrink(); // Return an empty widget if banner is not loaded
    }
  }

  // Load the interstitial ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-5080833301669041/8364859227', // Test ad unit ID
      request: const AdRequest(), // No need for testDevices here
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('Interstitial Ad loaded.');
          _interstitialAd = ad;
          _isAdLoaded = true; // Set the flag when the ad is loaded
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial Ad failed to load: $error');
          _isAdLoaded = false; // Reset the flag if loading fails
        },
      ),
    );
  }

  // Show the interstitial ad if it's ready
  void showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd!.dispose();
      _interstitialAd = null;
      _isAdLoaded = false; // Reset the flag after the ad is shown
      loadInterstitialAd(); // Preload a new ad after showing
    } else {
      print('Interstitial ad is not ready yet.');
    }
  }

  bool isAdReady() {
    return _isAdLoaded;
  }
}
