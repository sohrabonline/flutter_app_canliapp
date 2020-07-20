/*
import 'package:flutter/cupertino.dart';
import 'package:flutterappcanliapp/models/mesaj.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/repository/user_repository.dart';

enum ChatViewState { Busy, Idle, Loaded }

class ChatViewModel with ChangeNotifier {
  ChatViewState _chatViewState = ChatViewState.Idle;
  User currentUser;
  User sohbetEdilenUser;
  List<Mesaj> _tumMesajlar = [];
  UserRepository _userRepository = UserRepository();
  int _getirilecekMesajSayi = 20;
  Mesaj _enSonGetirilenMesaj;
  bool _hasMore = true;
  bool _yeniMesajDinleListener = false;
  Mesaj _listElaveOlunacaqIlkMesaj;



  bool get hasMore => _hasMore;

  set hasMore(bool value) {
    _hasMore = value;
  }


  ChatViewState get chatViewState => _chatViewState;

  set chatViewState(ChatViewState value) {
    _chatViewState = value;
    notifyListeners();
  }

  List<Mesaj> get tumMesajlar => _tumMesajlar;

  set tumMesajlar(List<Mesaj> value) {
    _tumMesajlar = value;
  }

  ChatViewModel({this.currentUser, this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessagesWithPagination(false);
  }

  getMessagesWithPagination(bool yeniMesajlarGetiriliyor) async {

    if (_tumMesajlar.length > 0) {
      _enSonGetirilenMesaj = _tumMesajlar.last;
    }

    if (!yeniMesajlarGetiriliyor) _chatViewState = ChatViewState.Busy;

    var getirilenMesajlar = await _userRepository.getMessageWithPagination(
        currentUser.userID,
        sohbetEdilenUser.userID,
        _enSonGetirilenMesaj,
        _getirilecekMesajSayi);

    if (getirilenMesajlar.length < _getirilecekMesajSayi) {
      _hasMore = false;
    }

    getirilenMesajlar
        .forEach((msj) => print("getirilen mesajlar:" + msj.mesaj));

    _tumMesajlar.addAll(getirilenMesajlar);
    if (_tumMesajlar.length>0) {
      _listElaveOlunacaqIlkMesaj=_tumMesajlar.first;
      print("Liste Elave Olunacaq Ilk Mesaj :" + _listElaveOlunacaqIlkMesaj.mesaj);
    }
    chatViewState = ChatViewState.Loaded;

    if (_yeniMesajDinleListener==false) {
      _yeniMesajDinleListener=true;
      print("Listener yox ona gore elave olunacaq");
      yeniMesajListenerAdd();
    }
  }

  Future<bool> saveMessage(Mesaj mesaj) async {
    return await _userRepository.saveMessage(mesaj); //awaiti sil
  }

  Future<void>  dahaFazlaMesajGetir() async {    // futre voidi sil
    if (_hasMore) {
      debugPrint("daha mesaj +++var+++");
      getMessagesWithPagination(true);
    } else {
      debugPrint("daha mesaj yoxdu");
    }
  }

  void yeniMesajListenerAdd() {
    print("Yeni mesajlar için listener atandı");
    _userRepository
        .getMessages(currentUser.userID, sohbetEdilenUser.userID)
        .listen((anlikData) {
      if (anlikData.isNotEmpty) {
        print("listener tetiklendi ve son getirilen veri:" +
            anlikData[0].toString());

        if (anlikData[0].date != null) {
          if (_listElaveOlunacaqIlkMesaj == null) {
            _tumMesajlar.insert(0, anlikData[0]);
          } else if (_listElaveOlunacaqIlkMesaj.date.millisecondsSinceEpoch !=
              anlikData[0].date.millisecondsSinceEpoch)
            _tumMesajlar.insert(0, anlikData[0]);
        }

        _chatViewState = ChatViewState.Loaded;
      }
    });
  }
}

*/
