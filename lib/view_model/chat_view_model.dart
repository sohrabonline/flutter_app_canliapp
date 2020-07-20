import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutterappcanliapp/locator.dart';
import 'package:flutterappcanliapp/models/mesaj.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/repository/user_repository.dart';
enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  List<Mesaj> _tumMesajlar;
  ChatViewState _chatViewState = ChatViewState.Idle;
  static final sayfaBasinaGonderiSayisi = 10;
  UserRepository _userRepository = locator<UserRepository>();
  final User currentUser;
  final User sohbetEdilenUser;
  Mesaj _enSonGetirilenMesaj;
  Mesaj _listeyeEklenenIlkMesaj;
  bool _hasMore = true;
  bool _yeniMesajDinleListener = false;
  StreamSubscription _streamSubscription;

  bool get hasMoreLoading => _hasMore;

  ChatViewModel({this.currentUser, this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessageWithPagination(false);
  }

  List<Mesaj> get tumMesajlar => _tumMesajlar;

  ChatViewState get state => _chatViewState;

  set state(ChatViewState value) {
    _chatViewState = value;
    notifyListeners();
  }

  @override
  dispose() {
    //print("Chatviewmodel dispose edildi");
    _streamSubscription.cancel();
    super.dispose();
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    return await _userRepository.saveMessage(kaydedilecekMesaj);
  }

  void getMessageWithPagination(bool yeniMesajlarGetiriliyor) async {
    if (_tumMesajlar.length > 0) {
      _enSonGetirilenMesaj = _tumMesajlar.last;
    }

    if (!yeniMesajlarGetiriliyor) state = ChatViewState.Busy;

    var getirilenMesajlar = await _userRepository.getMessageWithPagination(
        currentUser.userID,
        sohbetEdilenUser.userID,
        _enSonGetirilenMesaj,
        sayfaBasinaGonderiSayisi);

    if (getirilenMesajlar.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }

   // getirilenMesajlar.forEach((msj) => print("getirilen mesajlar:" + msj.mesaj));

    _tumMesajlar.addAll(getirilenMesajlar);
    if (_tumMesajlar.length > 0) {
      _listeyeEklenenIlkMesaj = _tumMesajlar.first;
    //  print("Listeye eklenen ilk mesaj :" + _listeyeEklenenIlkMesaj.mesaj);
    }

    state = ChatViewState.Loaded;

    if (_yeniMesajDinleListener == false) {
      _yeniMesajDinleListener = true;
     // print("Listener yok o yüzden atanacak");
      yeniMesajListenerAta();
    }
  }

  Future<void> dahaFazlaMesajGetir() async {
  //  print("Daha fazla mesaj getir tetiklendi - viewmodeldeyiz -");
    if (_hasMore)
      getMessageWithPagination(true);
    else
    //  print("Daha fazla eleman yok o yüzden çagrılmayacak");
    await Future.delayed(Duration(seconds: 2));
  }

  void yeniMesajListenerAta() {
  //  print("Yeni mesajlar için listener atandı");
   _streamSubscription= _userRepository
        .getMessages(currentUser.userID, sohbetEdilenUser.userID)
        .listen((anlikData) {
      if (anlikData.isNotEmpty) {
       // print("listener tetiklendi ve son getirilen veri:" +
          //  anlikData[0].toString());

        if (anlikData[0].date != null) {
          if (_listeyeEklenenIlkMesaj == null) {
            _tumMesajlar.insert(0, anlikData[0]);
          } else if (_listeyeEklenenIlkMesaj.date.millisecondsSinceEpoch !=
              anlikData[0].date.millisecondsSinceEpoch)
            _tumMesajlar.insert(0, anlikData[0]);
        }

        state = ChatViewState.Loaded;
      }
    });
  }
}