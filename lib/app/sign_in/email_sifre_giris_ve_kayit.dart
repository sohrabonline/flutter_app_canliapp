
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterappcanliapp/app/error_exception.dart';
import 'package:flutterappcanliapp/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutterappcanliapp/common_widget/sign_in_widget.dart';
import 'package:flutterappcanliapp/models/user.dart';
import 'package:flutterappcanliapp/view_model/user_model.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  String _butonText, _linkText;

  // var _userModel;
  var _formType = FormType.LogIn;

  var _formKey = GlobalKey<FormState>();

  void _formSubmit(BuildContext context) async {
    _formKey.currentState.save();
    debugPrint("email :" + _email + " şifre:" + _sifre);

    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_formType == FormType.LogIn) {
      try {

        User _girisYapanUser =
            await _userModel.signInWithEmailAndPassword(_email, _sifre);
        if (_girisYapanUser != null)
          print("daxil olan user id:" + _girisYapanUser.userID.toString());
      } on PlatformException catch (e) {
        debugPrint("Widget xeta ERROR email_sifre_giris_ve_kayit - KOD: 1 :" +
            e.code.toString());

        PlatformDuyarliAlertDialog(
                baslik: "Hesaba daxil olma xətası!",
                icerik: Hatalar().goster(e.code),
                anaButonYazisi: "Geri")
            .goster(context);
      }
    } else {
      try {

        User _olusturulanUser =
            await _userModel.createUserWithEmailAndPassword(_email, _sifre);
        if (_olusturulanUser != null)
          print("qeyd olan user id:" + _olusturulanUser.userID.toString());
      } on PlatformException catch (e) {
        debugPrint("Widget xeta ERROR email_sifre_giris_ve_kayit - KOD: 2 :" +
            Hatalar().goster(e.code));

        PlatformDuyarliAlertDialog(
                baslik: "Qeydiyyat zamanı xəta yarandı!",
                icerik: Hatalar().goster(e.code),
                anaButonYazisi: "Geri")
            .goster(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    _butonText = _formType == FormType.LogIn ? "Daxil ol" : "Qeyd ol";
    _linkText = _formType == FormType.LogIn
        ? "Hesabın yoxdur? Qeyd ol !"
        : "    Hesabın var? Daxil ol !   ";

    var _userModel = Provider.of<UserModel>(context);

    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 2), () {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              _formType == FormType.LogIn ? Colors.blue : Colors.green,
        ),
        body: _userModel.state == ViewState.Idle
            ? Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Center(
                                child: Container(
                                    color: Colors.lightGreenAccent,
                                    height: w / 10,
                                    width: w / 3,
                                    child: Image.asset(
                                      "images/logoA.png",
                                      fit: BoxFit.cover,
                                    ))),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              initialValue: "e@ee.ee",
                              onSaved: (value) {
                                _email = value.toString();
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  labelText: "Email",
                                  hintText: "Email",
                                  errorText: _userModel.emailHataMesaji == null
                                      ? null
                                      : _userModel.emailHataMesaji,
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              initialValue: "123456",
                              obscureText: true,
                              onSaved: (value) {
                                _sifre = value.toString();
                              },
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail),
                                  labelText: "Password",
                                  errorText: _userModel.sifreHataMesaji == null
                                      ? null
                                      : _userModel.sifreHataMesaji,
                                  hintText: "Password",
                                  border: OutlineInputBorder()),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SocialLoginButton(
                              butonText: _butonText,
                              radius: 5,
                              onPressed: () {
                                _formSubmit(context);
                              },
                              butonColor: _formType == FormType.LogIn
                                  ? Colors.blue
                                  : Colors.green,
                            ),
                            OutlineButton(
                              onPressed: () {
                                _degistir();
                              },
                              borderSide: BorderSide(
                                color: _formType == FormType.LogIn
                                    ? Colors.blue
                                    : Colors.green,
                              ),
                              color: Colors.blue,
                              disabledBorderColor: Colors.red,
                              highlightedBorderColor: Colors.blue,
                              textColor: _formType == FormType.LogIn
                                  ? Colors.blue
                                  : Colors.green,
                              child: Center(
                                child: Text(
                                  _linkText,
                                ),
                              ),
                            ),

                          ],
                        ),
                      )),
                ),
              )
            : Center(child: CircularProgressIndicator()));
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }
}
