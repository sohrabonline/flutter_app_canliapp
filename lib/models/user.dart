import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class User {
  String userID;
  String email;
  String userName;
  String profilURL;
  DateTime createdAt;
  DateTime updatedAt;
  int seviye;

  User({@required this.userID, @required this.email});

  Map<String, dynamic> toMap() {
    return {
      "userID": userID,
      "email": email,
      "userName":
          userName ?? email.substring(0, email.indexOf("@")) + randomSayiUret(),
      "profilURL": profilURL ??
          "https://www.pinclipart.com/picdir/big/199-1995994_professional-profile-icon-clipart-transparent-png-icon-back.png",
      "createdAt": createdAt ?? FieldValue.serverTimestamp(),
      "updatedAt": updatedAt ?? FieldValue.serverTimestamp(),
      "seviye": seviye ?? 1,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : userID = map["userID"],
        email = map["email"],
        userName = map["userName"],
        profilURL = map["profilURL"],
        createdAt = (map["createdAt"] as Timestamp).toDate(),
        updatedAt = (map["updatedAt"] as Timestamp).toDate(),
        seviye = map["seviye"];

User.idveResimAD({@required this.userID, @required this.profilURL,@required this.userName});

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(99999);
    return rastgeleSayi.toString();
  }

  @override
  String toString() {
    // TODO: implement toString
    return "User( userID: $userID , "
        "profilURL: $profilURL  , "
        "createdAt: $createdAt  , "
        "updatedAt: $updatedAt  , "
        "seviye = : $seviye    , "
        "username: $userName , )";
  }

}
