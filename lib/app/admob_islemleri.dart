import 'package:firebase_admob/firebase_admob.dart';

class AdmobIslemleri{

String appIDCanli="ca-app-pub-3030830518159011/9243960937";
String appIDTest=FirebaseAdMob.testAppId;
String banner1Canli="ca-app-pub-3030830518159011/9243960937";

admobInitialize()
{
  FirebaseAdMob.instance.initialize(appId: appIDTest);
}

static  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['SHRApp', 'chat app'],
  contentUrl: 'https://flutter.io',
  childDirected: false, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  adUnitId: BannerAd.testAdUnitId,
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
    if (event==MobileAdEvent.loaded) {
      print("BannerAd event is yuuklendi");
    }

  },
);

}