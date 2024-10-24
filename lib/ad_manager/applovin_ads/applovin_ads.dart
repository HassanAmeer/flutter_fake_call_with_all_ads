// import 'package:applovin_max/applovin_max.dart';

// class AppLovinInterstitialManager {
//   static const String _interstitialAdUnitId = "YOUR_AD_UNIT_ID";
//   bool _isAdLoaded = false;

//   void initializeAppLovin() {
//     AppLovinMax.initialize(
//       sdkKey: "",
//       onSdkInitialized: (config) {
//         print("AppLovin SDK initialized.");
//         loadInterstitialAd();
//       },
//     );
//   }

//   void loadInterstitialAd() {
//     AppLovinMax.loadInterstitial(_interstitialAdUnitId);

//     AppLovinMax.setInterstitialListener((AppLovinAdListener event) {
//       switch (event) {
//         case AppLovinAdListener.interstitialLoaded:
//           print("AppLovin Interstitial Ad loaded.");
//           _isAdLoaded = true;
//           break;
//         case AppLovinAdListener.interstitialLoadFailed:
//           print("AppLovin Interstitial Ad failed to load.");
//           _isAdLoaded = false;
//           break;
//         case AppLovinAdListener.interstitialDisplayed:
//           print("AppLovin Interstitial Ad displayed.");
//           break;
//         case AppLovinAdListener.interstitialAdHidden:
//           print("AppLovin Interstitial Ad hidden.");
//           loadInterstitialAd(); // Reload the ad after it is closed
//           break;
//         default:
//           break;
//       }
//     });
//   }

//   void showInterstitialAd() {
//     if (_isAdLoaded) {
//       AppLovinMax.showInterstitial(_interstitialAdUnitId);
//       _isAdLoaded = false; // Reset after showing the ad
//     } else {
//       print("AppLovin Ad is not ready.");
//     }
//   }

//   bool isAdReady() {
//     return _isAdLoaded;
//   }
// }

// class AppLovinBannerManager {
//   static const String _bannerAdUnitId = "YOUR_BANNER_AD_UNIT_ID";

//   void initializeBannerAd() {
//     AppLovinMax.initialize(
//       sdkKey: "YOUR_SDK_KEY",
//       onSdkInitialized: (config) {
//         print("AppLovin SDK for banners initialized.");
//         loadBannerAd();
//       },
//     );
//   }

//   void loadBannerAd() {
//     AppLovinMax.createBanner(_bannerAdUnitId,
//         AdViewPosition.bottomCenter, // You can choose top or bottom
//         size: BannerAdSize.banner);

//     AppLovinMax.setBannerListener((AppLovinAdListener event) {
//       switch (event) {
//         case AppLovinAdListener.bannerAdLoaded:
//           print("AppLovin Banner Ad loaded.");
//           break;
//         case AppLovinAdListener.bannerAdLoadFailed:
//           print("AppLovin Banner Ad failed to load.");
//           break;
//         case AppLovinAdListener.bannerAdClicked:
//           print("AppLovin Banner Ad clicked.");
//           break;
//         case AppLovinAdListener.bannerAdCollapsed:
//           print("AppLovin Banner Ad collapsed.");
//           break;
//         case AppLovinAdListener.bannerAdExpanded:
//           print("AppLovin Banner Ad expanded.");
//           break;
//         default:
//           break;
//       }
//     });
//   }

//   void hideBannerAd() {
//     AppLovinMax.hideBanner(_bannerAdUnitId);
//   }

//   void showBannerAd() {
//     AppLovinMax.showBanner(_bannerAdUnitId);
//   }

//   void removeBannerAd() {
//     AppLovinMax.destroyBanner(_bannerAdUnitId);
//   }
// }
