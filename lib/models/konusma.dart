import 'package:cloud_firestore/cloud_firestore.dart';

class Konusma {

  String konusma_sahibi;
  String kimle_konusuyor;
  String son_yollanan_mesaj;
  bool goruldu;
  Timestamp olusturulma_tarihi;
  Timestamp gorulme_tarihi;
  String konusulanUserName;
  String konusulanUserPpURL;
  DateTime sonOkunmaZamani;
  String aradakiFark;

  Konusma({this.konusma_sahibi, this.kimle_konusuyor, this.son_yollanan_mesaj,
      this.goruldu, this.olusturulma_tarihi, this.gorulme_tarihi});



  Map<String, dynamic> toMap(){
return {
  "konusma_sahibi" : konusma_sahibi,
  "kimle_konusuyor" : kimle_konusuyor,
  "goruldu" : goruldu,
  "olusturulma_tarihi" : olusturulma_tarihi ?? FieldValue.serverTimestamp(),
  "son_yollanan_mesaj" : son_yollanan_mesaj  ?? FieldValue.serverTimestamp(),
  "gorulme_tarihi" : gorulme_tarihi,

};}
Konusma.fromMap(Map<String, dynamic> map):
      konusma_sahibi=map["konusma_sahibi"],
      kimle_konusuyor=map["kimle_konusuyor"],
      goruldu=map["goruldu"],
      olusturulma_tarihi=map["olusturulma_tarihi"],
      son_yollanan_mesaj=map["son_yollanan_mesaj"],
      gorulme_tarihi=map["gorulme_tarihi"]; }


