import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';


class FirebaseAuthService implements AuthBase {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User> currentUser() async {
    try {
      FirebaseUser user = await _firebaseAuth.currentUser();
      return _userFromFirebase(user);
    } catch (error) {
      debugPrint("my CURRENT USER ERROR: " + error.toString());

      return null;
    }
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    } else {
      return User(userID: user.uid,email: user.email);
    }
  }

  @override
  Future<User> signInAnonymously() async {
    try {
      AuthResult sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (error) {
      debugPrint("my SIGNinANONM. ERROR: " + error.toString());

      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {

      GoogleSignIn googleSignIn = GoogleSignIn();
      googleSignIn.signOut();
      final _facebookLogin = FacebookLogin();
      await _facebookLogin.logOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (error) {
      debugPrint("my signOUT USER ERROR: " + error.toString());
      return false;
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(); //burda await yoxdu
    GoogleSignInAccount _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null)  {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        AuthResult sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));

        FirebaseUser _user =  sonuc.user;    //her ikisinde await silindi
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<User> signInWithFacebook() async {
    final _facebookLogin = FacebookLogin();

    FacebookLoginResult _faceResult = await _facebookLogin
        .logIn(['public_profile', 'email']);

    switch (_faceResult.status) {
      case FacebookLoginStatus.loggedIn:
        if (_faceResult.accessToken != null) {
          AuthResult _firebaseResult = await _firebaseAuth.signInWithCredential(
              FacebookAuthProvider.getCredential(
                  accessToken: _faceResult.accessToken.token));

          FirebaseUser _user = _firebaseResult.user;
          return _userFromFirebase(_user);
        }

        break;

      case FacebookLoginStatus.cancelledByUser:
        print("user facebook girişi cancelled");
        break;

      case FacebookLoginStatus.error:
        print("myError :" + _faceResult.errorMessage);
        break;
    }

    return null;
  }

  @override
  Future<User> createUserWithEmailAndPassword(String email, String sifre) async{


     AuthResult sonuc= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: sifre);
     return _userFromFirebase(sonuc.user);



  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String sifre)async {


      AuthResult sonuc = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: sifre);
      return _userFromFirebase(sonuc.user);



  }
}
