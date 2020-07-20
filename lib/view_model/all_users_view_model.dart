import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/locator.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/repository/user_repository.dart';

enum AllUseriewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  List<User> _tumKullanicilar;
  User _enSonGetirilenUser;
  int getirilecekUserSayi = 13;
  bool _hasMore = true;
  AllUseriewState _state = AllUseriewState.Idle;

  UserRepository _userRepository = locator<UserRepository>();

  List<User> get tumKullanicilar => _tumKullanicilar;


  bool get hasMore => _hasMore;

  AllUseriewState get state => _state;

  set state(AllUseriewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
   _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPaginationg(_enSonGetirilenUser, false);
  }

  getUserWithPaginationg(User enSonGetirilenUser, bool yeniElementGelir) async {
    if (_tumKullanicilar.length > 0) {
      _enSonGetirilenUser = _tumKullanicilar.last;
      debugPrint("en son get user " + _enSonGetirilenUser.userName);
    }

    if (yeniElementGelir) {
      debugPrint("yeni element gelir gozdeee.");
    } else {
      state = AllUseriewState.Busy;
    }

    var yeniList = await _userRepository.getUserWithPagination(
        _enSonGetirilenUser, getirilecekUserSayi);

    if (yeniList.length<getirilecekUserSayi) {
      _hasMore=false;
    }

    yeniList.forEach((element) {
      debugPrint("user: " + element.userName);
    });

    _tumKullanicilar.addAll(yeniList);
    state = AllUseriewState.Loaded;
  }

 Future<void> getMoreUser() async {
    if (_hasMore) {
      _tumKullanicilar=[];
      getUserWithPaginationg(_enSonGetirilenUser, true);
      debugPrint("daha element **var**");
    }  else{
      debugPrint("daha element yoxdu");
    }await Future.delayed(Duration(seconds: 2));

  }
}
