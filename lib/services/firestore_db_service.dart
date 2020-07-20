import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterappcanliapp/models/konusma.dart';
import 'package:flutterappcanliapp/models/mesaj.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/services/database_base.dart';

class FirestoreDBService implements DBBase {
  Firestore _firebaseDB = Firestore.instance;


  @override
  Future<bool> saveUser(User user) async {
    DocumentSnapshot _okunanUser =
        await Firestore.instance.document("users/${user.userID}").get();

    if (_okunanUser.data == null) {
      await _firebaseDB
          .collection("users")
          .document(user.userID)
          .setData(user.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<User> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDB.collection("users").document(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap = _okunanUser.data;

    User _okunanUserNesnesi = User.fromMap(_okunanUserBilgileriMap);
    print("my user READUSER :" + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUserName) async {
    var users = await _firebaseDB
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .getDocuments();
    if (users.documents.length >= 1) {
      return false;
    } else {
      await _firebaseDB
          .collection("users")
          .document(userID)
          .updateData({"userName": yeniUserName});

      return true;
    }
  }

  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    await _firebaseDB
        .collection("users")
        .document(userID)
        .updateData({'profilURL': profilFotoURL});
    return true;
  }



  @override
  Future<List<Konusma>> getAllConservations(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseDB
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .getDocuments();

    List<Konusma> tumKonusmalar = [];

    for (var tekKonusma in querySnapshot.documents) {
      var v = Konusma.fromMap(tekKonusma.data);
      tumKonusmalar.add(v);
    }
    return tumKonusmalar;
  }

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    var snapshot = _firebaseDB
        .collection("konusmalar")
        .document(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .snapshots();

    return snapshot.map((mesajListesi) => mesajListesi.documents
        .map((mesaj) => Mesaj.fromMap(mesaj.data))
        .toList());
  }

  Future<bool> saveMessage(Mesaj mesaj) async {
    var _mesajID = _firebaseDB.collection("konusmalar").document().documentID;
    var _myDocumentID = mesaj.kimden + "--" + mesaj.kime;
    var _recieverDocumentID = mesaj.kime + "--" + mesaj.kimden;

    var _kaydedilecekMesajMapYapisi = mesaj.toMap();

    await _firebaseDB
        .collection("konusmalar")
        .document(_myDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajMapYapisi);

    _kaydedilecekMesajMapYapisi.update("mendenMi", (value) => false);

    await _firebaseDB.collection("konusmalar").document(_myDocumentID).setData({
      "konusma_sahibi": mesaj.kimden,
      "kimle_konusuyor": mesaj.kime,
      "son_yollanan_mesaj": mesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });

    await _firebaseDB
        .collection("konusmalar")
        .document(_recieverDocumentID)
        .collection("mesajlar")
        .document(_mesajID)
        .setData(_kaydedilecekMesajMapYapisi);

    await _firebaseDB
        .collection("konusmalar")
        .document(_recieverDocumentID)
        .setData({
      "konusma_sahibi": mesaj.kime,
      "kimle_konusuyor": mesaj.kimden,
      "son_yollanan_mesaj": mesaj.mesaj,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp()
    });


    return true;
  }

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firebaseDB.collection("server").document(userID).setData({"saat": FieldValue.serverTimestamp()});

    var okunanMap= await _firebaseDB.collection("server").document(userID).get();
    Timestamp okunanTarih= await okunanMap.data["saat"];
    return okunanTarih.toDate();  // to Dateni yuxarida elemek
  }

  @override
  Future<List<User>> getUserWithPagination(User _enSonGetirilenUser,
      int _getirilecekUserSayi) async {

    List<User> tumKullanicilar = [];

    QuerySnapshot querySnapshot;
    if (_enSonGetirilenUser == null) {
      print("ilk defe gelir");
      querySnapshot = await Firestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(_getirilecekUserSayi)
          .getDocuments();

    } else {
      print("ilk defe --deyil-- gelir");
      querySnapshot = await Firestore.instance
          .collection("users")
          .startAfter([_enSonGetirilenUser.userName])
          .orderBy("userName")
          .limit(_getirilecekUserSayi)
          .getDocuments();

      await Future.delayed(Duration(seconds: 1));
    }

    for (var snap in querySnapshot.documents) {
      User _tekUser = User.fromMap(snap.data);
      tumKullanicilar.add(_tekUser);

    }

    return tumKullanicilar;

  }
}
