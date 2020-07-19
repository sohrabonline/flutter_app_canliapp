import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/app/tab_items.dart';

class MyCustomBottomNavi extends StatelessWidget {
  MyCustomBottomNavi(
      {@required this.currentTab,
      @required this.onSelectedTab,
      @required this.sayfaOlusturucu,
      @required this.navigatorKeys});

  TabItem currentTab;
  ValueChanged onSelectedTab;

  Map<TabItem, Widget> sayfaOlusturucu;
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (context, index) {
        var gosterilecekItem = TabItem.values[index];

        return CupertinoTabView(
          navigatorKey: navigatorKeys[gosterilecekItem],
          builder: (context) {
            return sayfaOlusturucu[gosterilecekItem];
          },
        );
      },
      tabBar: CupertinoTabBar(
        items: [
          _naviItemOlustur(TabItem.Konusmalarim),
          _naviItemOlustur(TabItem.Kullanicilar),
          _naviItemOlustur(TabItem.Profil),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
    );
  }

  BottomNavigationBarItem _naviItemOlustur(TabItem tabItem) {
    final currentTab = TabItemData.tumTablar[tabItem];

    return BottomNavigationBarItem(
        icon: Icon(currentTab.icon),
        title: Text(
          currentTab.title,
          style: TextStyle(fontSize: 15),
        ));
  }
}
