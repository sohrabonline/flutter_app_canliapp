import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/app/konusmalarim_page.dart';
import 'package:flutterappcanliapp/app/kullanicilar.dart';
import 'package:flutterappcanliapp/app/my_custom_bottom_navi.dart';
import 'package:flutterappcanliapp/app/profile.dart';
import 'package:flutterappcanliapp/app/tab_items.dart';
import 'package:flutterappcanliapp/models/user.dart';



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

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Konusmalarim : GlobalKey<NavigatorState>(),
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Konusmalarim : KonusmalarimPage(),
      TabItem.Kullanicilar: KullanicilarPage(),
      TabItem.Profil: ProfilPage(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
       ! await navigatorKeys[_currentTab].currentState.maybePop(),  // can pop yoxlamag
      
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
