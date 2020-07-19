

import 'package:flutterappcanliapp/models/konusma.dart';
import 'package:flutterappcanliapp/models/mesaj.dart';
import 'package:flutterappcanliapp/models/user.dart';

abstract class DBBase{
  Future<bool>saveUser(User user);
  Future<User>readUser(String userID);
  Future<bool>updateUserName(String userID,String yeniUserName);
  Future<bool> updateProfilFoto(String userID, String profilFotoURL);
  Future<List<User>> getUserWithPagination(User enSonGetirilenUser,
  int getirilecekUserSayi);
  Future<List<Konusma>> getAllConservations(String userID);
  Stream<List<Mesaj>> getMessages(String currentUserID,String sohbetEdilenUserID);
  Future<bool> saveMessage(Mesaj mesaj);
  Future<DateTime> saatiGoster(String userID);

}