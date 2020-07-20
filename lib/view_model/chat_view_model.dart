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

  ChatViewState get chatViewState => _chatViewState;

  set chatViewState(ChatViewState value) {
    _chatViewState = value;
  }

  List<Mesaj> get tumMesajlar => _tumMesajlar;

  set tumMesajlar(List<Mesaj> value) {
    _tumMesajlar = value;
  }

  ChatViewModel({this.currentUser, this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessagesWithPagination();
  }

  getMessagesWithPagination() async {
    _chatViewState = ChatViewState.Busy;
   var mesajList= await _userRepository.getMessageWithPagination(currentUser.userID,
        sohbetEdilenUser.userID, _enSonGetirilenMesaj, _getirilecekMesajSayi);
   _tumMesajlar.addAll(mesajList);
    _chatViewState = ChatViewState.Loaded;
  }
}
