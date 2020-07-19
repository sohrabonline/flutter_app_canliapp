import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutterappcanliapp/locator.dart';
import 'package:flutterappcanliapp/models/konusma.dart';
import 'package:flutterappcanliapp/models/mesaj.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/repository/user_repository.dart';
import 'package:flutterappcanliapp/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  User _user;
  UserRepository _userRepository = locator<UserRepository>();

  String emailHataMesaji;
  String sifreHataMesaji;

  User get user => _user;

  UserModel() {
    currentUser();
  }

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      return _user;
    } catch (error) {
      debugPrint(
          "MY USER MODEL - signInAnonymously da ERROR" + error.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      debugPrint("MY USER MODEL - currentUser try isheldi ");
      return _user;
    } catch (error) {
      debugPrint("MY USER MODEL - currentUser da ERROR" + error.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;

      bool sonuc = await _userRepository.signOut();
      _user = null;
      debugPrint("MY USER MODEL - SIGN OUT try isheldi ");
      return sonuc;
    } catch (error) {
      debugPrint("MY USER MODEL - SIGN OUT da ERROR" + error.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      return _user;
    } catch (error) {
      debugPrint(
          "MY USER MODEL - signInWithGoogle da ERROR" + error.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithFacebook();
      return _user;
    } catch (error) {
      debugPrint(
          "MY USER MODEL - signInWithFacebook da ERROR" + error.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String sifre) async {
    if (_emailSifreKontrol(email, sifre) == true) {
      try {
        state = ViewState.Busy;
        _user =
            await _userRepository.createUserWithEmailAndPassword(email, sifre);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else {
      return null;
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailAndPassword(email, sifre);
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;

    if (!email.contains("@")) {
      emailHataMesaji = "Mail ünvanınızı düzgün daxil edin";
      sonuc = false;
    } else {
      emailHataMesaji = null;
    }

    if (sifre.length <= 5) {
      sifreHataMesaji = "Şifrə ən azı 5 simvoldan ibarət olmalııdır";
      sonuc = false;
    } else {
      sifreHataMesaji = null;
    }

    return sonuc;
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
   var sonuc= await _userRepository.updateUserame(userID,yeniUserName);
   if (sonuc==true) {
     _user.userName=yeniUserName;
   }  

   return sonuc;
  }

 Future <String> uploadFile(String userID, String fileType, File profilFoto) async{

    var indirmeLinki=await _userRepository.uploadFile(userID,fileType,profilFoto);
    return indirmeLinki;
 }




 Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetEdilenUserID){

    return _userRepository.getMessages(currentUserID, sohbetEdilenUserID);

 }

  Future<bool> saveMessage(Mesaj mesaj)  async{

    return  await _userRepository.saveMessage(mesaj) ; //awaiti sil

  }

  Future <List<Konusma>> getAllConservations(String userID) async{
    return await _userRepository.getAllConservations(userID);
  }

  Future<List<User>> getUserWithPagination(User enSonGetirilenUser, int getirilecekUserSayi) async{

    return  await _userRepository.getUserWithPagination( enSonGetirilenUser,
         getirilecekUserSayi);

  }




}
