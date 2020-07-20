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
  int _getirilecekMesajSayi = 13;
  Mesaj _enSonGetirilenMesaj;
  bool _hasMore = true;



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

    if (_tumMesajlar.length > 1) {
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
    chatViewState = ChatViewState.Loaded;
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
}
