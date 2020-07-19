import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/app/sign_in/email_sifre_giris_ve_kayit.dart';
import 'package:flutterappcanliapp/common_widget/sign_in_widget.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/view_model/user_model.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  void signInAsGuide(BuildContext context) async {
    var _userModel = Provider.of<UserModel>(context, listen: false);
    User user = await _userModel.signInAnonymously();

    print("daxil olan user id:" + user.userID.toString());
  }

  void signInWithGoogle(BuildContext context) async {
    var _userModel = Provider.of<UserModel>(context, listen: false);
    User user = await _userModel.signInWithGoogle();
    if (user.userID != null) {
      print("google ile daxil olan user id:" + user.userID.toString());
    }
  }

  void signInWithFacebook(BuildContext context) async {
    var _userModel = Provider.of<UserModel>(context, listen: false);
    User _user = await _userModel.signInWithFacebook();

    if (_user != null) print("Oturum açan user id:" + _user.userID.toString());
  }

  void _emailVeSifreGiris(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailveSifreLoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    var w=MediaQuery.of(context).size.width;
    var h=MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('SHRApp'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                  child: Container(color: Colors.lightGreenAccent,
                      height: w/10,
                      width: w/3,
                      child: Image.asset("images/logoA.png",fit: BoxFit.cover,))
              ),
              SizedBox(
                height: 10,
              ),
              SocialLoginButton(
                butonText: "Mail və şifrə ilə daxil ol",
                butonColor: Colors.red,
                onPressed: () {
                  _emailVeSifreGiris(context);
                },
                radius: 10,
                textColor: Colors.white,
                butonIcon: Icon(
                  Icons.mail_outline,
                  size: 35,
                  color: Colors.white,
                ),
              ),
              SocialLoginButton(
                butonColor: Colors.white,
                butonIcon: Image.asset("images/google-logo.png"),
                onPressed: () {
                  signInWithGoogle(context);
                },
                butonText: "Google ilə daxil ol",
                radius: 10,
                textColor: Colors.black,
              ),
              SocialLoginButton(
                butonColor: Color(0xFF334D92),
                butonIcon: Image.asset("images/facebook-logo.png"),
                onPressed: () {
                  signInWithFacebook(context);
                },
                butonText: "Fcaebook ilə daxil ol",
                radius: 10,
                textColor: Colors.white,
              ),

              SocialLoginButton(
                butonText: "Qonaq kimi daxil ol",
                butonColor: Colors.green,
                butonIcon: Icon(Icons.supervised_user_circle,
                    color: Colors.white, size: 35),
                onPressed: () {
                  signInAsGuide(context);
                },
                radius: 10,
                textColor: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
