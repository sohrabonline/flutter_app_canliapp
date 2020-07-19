import 'dart:io';

import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutterappcanliapp/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:flutterappcanliapp/common_widget/sign_in_widget.dart';
import 'package:flutterappcanliapp/view_model/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController _controllerUserName;
  File _profilFoto;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerUserName = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void _galeridenResimSec() async{
    try{
      var _yeniResim=await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        _profilFoto=File(_yeniResim.path);
        Navigator.of(context).pop();
      });

    }
    catch(e){
      Navigator.of(context).pop();
      FlushbarHelper.createInformation(
        title: null,
        message:
        "Yeni foto seçmədiniz!",
        duration: Duration(seconds: 3),
      )..show(context);
      debugPrint("sec xeta "+e.toString());

    }
  }

  void _kameradanFotoCek() async{
   try{
     var _yeniResim=await ImagePicker().getImage(source: ImageSource.camera);
     setState(() {
       _profilFoto=File(_yeniResim.path);
       Navigator.of(context).pop();
     });

   }
   catch (e){
     Navigator.of(context).pop();
     FlushbarHelper.createInformation(
       title: null,
       message:
       "Yeni foto seçmədiniz!",
       duration: Duration(seconds: 3),
     )..show(context);
     debugPrint("sec xeta "+e.toString());


   }
  }


  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    print("info melumtalar of profile" + _userModel.user.toString());
    _controllerUserName.text = _userModel.user.userName;

    return Scaffold(
        appBar: AppBar(title: Text(_userModel.user.userName),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app, color: Colors.white),
                onPressed: () {
                  return _cikisIcinOnayIste(context);
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            color: Colors.black12,
                            height: 190,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                InkWell(
                                  splashColor: Colors.blue.shade100,
                                  onTap: () {
                                    _galeridenResimSec();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width /
                                            2,
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.insert_photo,
                                          size: 110,
                                          color: Colors.blue.shade700,
                                        ),
                                        Text(
                                          "Seç",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  splashColor: Colors.blue.shade100,
                                  onTap: () {
                                    _kameradanFotoCek();
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width /
                                            2,
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          Icons.camera_alt,
                                          size: 110,
                                          color: Colors.blue.shade700,
                                        ),
                                        Text(
                                          "Çək",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  child: Container(
                      padding: EdgeInsets.only(top: 20, left: 30),
                      child: CircleAvatar(  radius: 82,backgroundColor: Colors.blue,
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: _profilFoto==null ?
                              NetworkImage(_userModel.user.profilURL) : FileImage(_profilFoto),
                        ),
                      )),
                ),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: TextFormField(
                    onTap: () {
                      FlushbarHelper.createInformation(
                        title: "Hörmətli, ${_userModel.user.userName}",
                        message:
                        " E-Mail ünvanını dəyişdirmə hüququna malik deyilsiniz!",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    },
                    readOnly: true,
                    initialValue: _userModel.user.email,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "E-Mail"),
                  ),
                )
                ,
                Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: TextFormField(
                    autofocus: false,
                    controller: _controllerUserName,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "İstifadəçi adı"),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 35),
                  child: SocialLoginButton(
                    butonColor: Colors.green,
                    butonText: "Təsdiqlə",
                    onPressed: () {
                      _userNameGuncelle(context);
                      _profilFotoGuncelle(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future _cikisYap(BuildContext context) async {
    var _userModel = Provider.of<UserModel>(context, listen: false);
    var sonuc = await _userModel.signOut();

    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    var sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Əminmisiniz?",
      icerik: "Çıxış etmək istədiyinizden əminmisiniz?",
      anaButonYazisi: "Təsdiqlə",
      iptalButonYazisi: "Geri",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user.userID, _controllerUserName.text);

      if (updateResult == true) {
        FlushbarHelper.createSuccess(
          title: "Hörmətli , ${_controllerUserName.text}",
          message:
              "Istifadəçi adınız , ${_controllerUserName.text} olaraq dəyişdirildi!",
          duration: Duration(seconds: 3),
        )..show(context);
        debugPrint("balaca if ishledi");
      } else {
        var xName = _controllerUserName.text;
        _controllerUserName.text = _userModel.user.userName;
        FlushbarHelper.createError(
          title: "Hörmətli, ${_userModel.user.userName}",
          message: "$xName adı başqa biri tərəfindən istifadə olunur",
          duration: Duration(seconds: 3),
        )..show(context);
      }
    }
  }

  void _profilFotoGuncelle(BuildContext context) async{
    UserModel _userModel=Provider.of<UserModel>(context,listen: false);

    if (_profilFoto!=null) {
       var url=await _userModel.uploadFile(_userModel.user.userID,"profil_foto",_profilFoto);
       print(" +++++ photo uploaded ++++ "+url);
       if (url!=null) {

         FlushbarHelper.createSuccess(
           title: "Hörmətli , ${_controllerUserName.text}",
           message:
           "Profil şəkli uğurla dəyişdirildi!",
           duration: Duration(seconds: 3),
         )..show(context);
       }
    }
  }


}
