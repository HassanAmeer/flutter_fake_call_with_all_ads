import 'package:flutter/widgets.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class UnityAdsManager {
  static final UnityAdsManager _instance = UnityAdsManager._internal();
  bool _isAdLoaded = false;

  factory UnityAdsManager() {
    return _instance;
  }

  UnityAdsManager._internal();

  // Initialize Unity Ads
  void initialize() {
    UnityAds.init(
      gameId: "14851", // Replace with your Unity Game ID
      testMode: true, // Set to false in production
      onComplete: () => print('Unity Ads initialization complete'),
      onFailed: (error, message) =>
          print('Unity Ads initialization failed: $message'),
    );
  }

  // Load the interstitial ad
  Future<void> loadInterstitialAd() async {
    if (await UnityAds.isInitialized()) {
      UnityAds.load(
        placementId: "video",
        onComplete: (placementId) {
          print("Unity Interstitial Ad Loaded: $placementId");
          _isAdLoaded = true;
        },
        onFailed: (placementId, error, message) {
          print("Unity Interstitial Ad Failed to Load: $message");
          _isAdLoaded = false;
        },
      );
    } else {
      print("Unity Ads not initialized");
    }
  }

  // Show interstitial ad with a listener for ad state
  void showInterstitialAd() {
    if (_isAdLoaded) {
      UnityAds.showVideoAd(
        placementId: "video",
        onComplete: (placementId) =>
            print("Unity Video ad completed: $placementId"),
        onFailed: (placementId, error, message) =>
            print("Unity Video ad failed to show: $message"),
        onSkipped: (placementId) =>
            print("Unity Video ad skipped: $placementId"),
      );
      _isAdLoaded = false; // Reset after showing the ad
      loadInterstitialAd(); // Preload a new ad after showing
    } else {
      print("Unity Interstitial ad is not ready yet.");
    }
  }

  // Load Banner Ad
  Widget loadBannerAd() {
    return UnityBannerAd(
      placementId: "banner", // Replace with your Banner Placement ID
      onLoad: (placementId) => print("Unity Banner Ad loaded: $placementId"),
      onFailed: (placementId, error, message) =>
          print("Unity Banner Ad failed to load: $message"),
      onClick: (placementId) => print("Unity Banner Ad clicked: $placementId"),
      //onImpression: (placementId) =>
      // print("Unity Banner Ad impression: $placementId"),
      size: BannerSize.standard, // Can be 'banner', 'leaderboard', 'medium'
    );
  }

  // Check if the ad is ready
  bool isAdReady() {
    return _isAdLoaded;
  }
}
