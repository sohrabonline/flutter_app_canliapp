import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutterappcanliapp/locator.dart';
import 'package:flutterappcanliapp/models/konusma.dart';
import 'package:flutterappcanliapp/models/mesaj.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/services/auth_base.dart';
import 'package:flutterappcanliapp/services/fake_auth_service.dart';
import 'package:flutterappcanliapp/services/firebase_auth_service.dart';
import 'package:flutterappcanliapp/services/firebase_storage_service.dart';
import 'package:flutterappcanliapp/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthenticationService _fakeAuthenticationService =
  locator<FakeAuthenticationService>();
  FirestoreDBService _firestoreDBService = locator<FirestoreDBService>();
  FirebaseStorageService _firebaseStorageService = locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;

  List<User> tumKullaniciListesi = [];


  @override
  Future<User> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.currentUser();
    } else {
     User _user =await _firebaseAuthService.currentUser();
      return await _firestoreDBService.readUser(_user.userID);
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<User> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithGoogle();
    } else {
      User user = await _firebaseAuthService.signInWithGoogle();
      bool sonuc = await _firestoreDBService.saveUser(user);
      if (sonuc) {
        return await _firestoreDBService.readUser(user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.signInWithFacebook();
    } else {
      User user = await _firebaseAuthService.signInWithFacebook();
      bool sonuc = await _firestoreDBService.saveUser(user);
      if (sonuc == true) {
        return await _firestoreDBService.readUser(user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email,
      String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthenticationService.createUserWithEmailAndPassword(
          email, sifre);
    } else {
      User user = await _firebaseAuthService.createUserWithEmailAndPassword(
          email, sifre);
      bool sonuc = await _firestoreDBService.saveUser(user);
      if (sonuc == true) {
       return await _firestoreDBService.readUser(user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {

        return await _fakeAuthenticationService.signInWithEmailAndPassword(
            email, sifre);
      } else {

          User _user =
          await _firebaseAuthService.signInWithEmailAndPassword(email, sifre);

          return await _firestoreDBService.readUser(_user.userID);

      }

  }

  updateUserame(String userID, String yeniUserName) async{

    if (appMode==AppMode.DEBUG) {
      return false;
    }
    else{
      return await _firestoreDBService.updateUserName(userID, yeniUserName);
    }

  }

  Future<String> uploadFile(String userID, String fileType, File profilFoto) async {
    if (appMode==AppMode.DEBUG) {
      return "bizim linkimiz";
    }
    else{
      var profilFotoURL= await _firebaseStorageService.uploadFile(userID, fileType, profilFoto);
      await _firestoreDBService.updateProfilFoto(userID,profilFotoURL);
       return profilFotoURL;
    }
  }



  Stream<List<Mesaj>> getMessages(String currentUserID, String sohbetEdilenUserID) {
    
    if (appMode==AppMode.DEBUG) {
      return Stream.empty();
    }
    else {
      return _firestoreDBService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj mesaj) async{

    if (appMode==AppMode.DEBUG) {
      return true;
    }
    else{

    return  _firestoreDBService.saveMessage(mesaj);
    }

  }

 Future<List<Konusma>> getAllConservations(String userID) async{

    if (appMode==AppMode.DEBUG) {
      return [];
    }  else{
            DateTime _indikiZaman=await _firestoreDBService.saatiGoster(userID);

      var konusmaListesi= await _firestoreDBService.getAllConservations(userID);

      for(var oankiKonusma in konusmaListesi){

        var userListesindekiKullanici=findUserFromList(oankiKonusma.kimle_konusuyor);
        if (userListesindekiKullanici!=null) {
          oankiKonusma.konusulanUserName=userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserPpURL=userListesindekiKullanici.profilURL;
          debugPrint("Localdan oxundu sekil ve ad");

        }
        else{
          var veriTabanindanOkunanUser=await _firestoreDBService.readUser(oankiKonusma.kimle_konusuyor);
          oankiKonusma.konusulanUserName=veriTabanindanOkunanUser.userName;
          oankiKonusma.konusulanUserPpURL=veriTabanindanOkunanUser.profilURL;
          debugPrint("ad ve pp databaseden tapildi");
        }

        timeAgoHesanla(oankiKonusma, _indikiZaman);
      }


    return konusmaListesi;
    }
 }

 void timeAgoHesanla(Konusma oankiKonusma, DateTime _indikiZaman) {
    oankiKonusma.sonOkunmaZamani=_indikiZaman;
   timeago.setLocaleMessages("tr", timeago.TrMessages());

   var duration =_indikiZaman.difference(oankiKonusma.olusturulma_tarihi.toDate()) ;
   oankiKonusma.aradakiFark=timeago.format(_indikiZaman.subtract(duration),locale: "tr");
 }

 User findUserFromList (String userID){

    for(int i=0;i<tumKullaniciListesi.length;i++){
      if (tumKullaniciListesi[i].userID==userID) {
        return tumKullaniciListesi[i];
      }  
    }
    return null;
 }

  Future<List<User>>  getUserWithPagination(User enSonGetirilenUser, int getirilecekUserSayi) async{
    if (appMode==AppMode.DEBUG) {
      return  [];
    }  else{
      List<User> _userList=await _firestoreDBService.getUserWithPagination(enSonGetirilenUser, getirilecekUserSayi);
      tumKullaniciListesi.addAll(_userList);
      return _userList;
    }
  }

  Future<List<Mesaj>> getMessageWithPagination(String currentUserID, String sohbetEdilenUserID, Mesaj enSonGetirilenMesaj, int getirilecekMesajSayi) async{
    if (appMode==AppMode.DEBUG) {
       return [];
    } else{
      return await _firestoreDBService.getMessageWithPagination(currentUserID,sohbetEdilenUserID,enSonGetirilenMesaj,getirilecekMesajSayi);
    }
  }


}