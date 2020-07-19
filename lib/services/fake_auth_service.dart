

import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/services/auth_base.dart';

class FakeAuthenticationService implements AuthBase{

  String userID="36725763484863";

  String fakeMail="fake@mail.ru";

  @override
  Future<User> currentUser() async {
   return await Future.value(User(userID: userID,email: fakeMail));
  }

  @override
  Future<User> signInAnonymously() async{

    return await Future.delayed(Duration(seconds: 2),()=>User(userID: userID,email: fakeMail));

  }

  @override
  Future<bool> signOut() async {

    return await Future.value(true);
  }

  @override
  Future<User> signInWithGoogle() async {
    return await Future.delayed(Duration(seconds: 2),()=>User(userID: "google_fake_user_id_12983939398",email: fakeMail));
  }

  @override
  Future<User> signInWithFacebook() async{
    return await Future.delayed(Duration(seconds: 2),()=>User(userID: "facebook_fake_user_id_12432",email: fakeMail));
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String sifre) async{

    return await Future.delayed(Duration(seconds: 2),()=>User(userID: "simple_user_new_fake_user_id_129",email: fakeMail));

  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre)async {

    return await Future.delayed(Duration(seconds: 2),()=>User(userID: "simple_user_fake_user_id_129",email: fakeMail));

  }



}