// import 'dart:io';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// class AdState {
//   Future<InitializationStatus> initiialization;

//   AdState(this.initiialization);
//   String get appId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-2515700971573747~7349882881";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   String get bannerAdUnitId {
//     if (Platform.isAndroid) {
//       return "ca-app-pub-2515700971573747/3093560210";
//     } else {
//       throw new UnsupportedError("Unsupported platform");
//     }
//   }

//   AdListener get adListener => _adListener;

//   AdListener _adListener = AdListener(
//     onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}'),
//     onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}'),
//   );
// }
