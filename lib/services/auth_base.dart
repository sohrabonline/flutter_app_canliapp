
import 'package:flutterappcanliapp/models/user.dart';

abstract class AuthBase{


  Future<bool> signOut();
  Future<User> currentUser();
  Future<User> signInAnonymously();
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<User> signInWithEmailAndPassword(String email,String sifre);
  Future<User> createUserWithEmailAndPassword(String email,String sifre);




}