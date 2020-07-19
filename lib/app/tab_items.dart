import 'package:flutter/material.dart';

enum TabItem{Konusmalarim,Kullanicilar,Profil}

class TabItemData{

  String title;
  IconData icon;


  TabItemData(this.title, this.icon);

  static Map<TabItem, TabItemData> tumTablar = {   //static

    TabItem.Konusmalarim : TabItemData("Söhbətlər", Icons.chat),
    TabItem.Kullanicilar : TabItemData("Istifadəçilər", Icons.supervised_user_circle  ),
    TabItem.Profil : TabItemData("Hesab", Icons.person_pin)


  };
  
}