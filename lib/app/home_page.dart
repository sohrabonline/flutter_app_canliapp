import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/app/konusmalarim_page.dart';
import 'package:flutterappcanliapp/app/kullanicilar.dart';
import 'package:flutterappcanliapp/app/my_custom_bottom_navi.dart';
import 'package:flutterappcanliapp/app/profile.dart';
import 'package:flutterappcanliapp/app/tab_items.dart';
import 'package:flutterappcanliapp/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/view_model/all_users_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  User user;

  HomePage({
    @required this.user,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Profil;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Konusmalarim: KonusmalarimPage(),
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    _firebaseMessaging.subscribeToTopic("all");
    
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        // _showItemDialog(message);
        PlatformDuyarliAlertDialog(
            baslik: message['data']['title'],
            icerik: message['data']['message'],
            anaButonYazisi: "Ok").goster(context);
      },
      //onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        //  _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        PlatformDuyarliAlertDialog(
            baslik: message['data']['title'],
            icerik: message['data']['body'],
            anaButonYazisi: "Ok").goster(context);
        //  _navigateToItemDetail(message);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      // can pop yoxlamag

      child: Container(
        child: MyCustomBottomNavi(
            navigatorKeys: navigatorKeys,
            sayfaOlusturucu: tumSayfalar(),
            currentTab: _currentTab,
            onSelectedTab: (selectedTab) {
              /*  if (selectedTab==_currentTab) {
                navigatorKeys[selectedTab].currentState.popUntil((route) => route.isFirst);
              }
*/

              setState(() {
                _currentTab = selectedTab;
              });

              print("Secilen tab: " + _currentTab.toString());
            }),
      ),
    );
  }
}
