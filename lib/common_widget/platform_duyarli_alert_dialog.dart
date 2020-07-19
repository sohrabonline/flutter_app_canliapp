import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/common_widget/platform_duyarli_widget.dart';


class PlatformDuyarliAlertDialog extends PlatformDuyarliWidget {
  String baslik;
  String icerik;
  String anaButonYazisi;
  String iptalButonYazisi;
  Color titleColor;

  PlatformDuyarliAlertDialog(
      {@required this.baslik,
      @required this.icerik,
      @required this.anaButonYazisi,
      this.iptalButonYazisi,
      this.titleColor});

  Future<bool> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog(
            context: context, builder: (context) => this)
        : showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => this);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {


    return AlertDialog(
      title: Text(
        baslik,
        style: TextStyle(color: titleColor),
      ),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        baslik,
        style: TextStyle(color: titleColor),
      ),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  List<Widget> _dialogButonlariniAyarla(BuildContext context) {
    var tumButonlar = <Widget>[];

    if (Platform.isIOS) {
      if (iptalButonYazisi != null) {
        tumButonlar.add(CupertinoDialogAction(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            iptalButonYazisi,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
      }

      tumButonlar.add(
        CupertinoDialogAction(
          child: Text(anaButonYazisi),
          onPressed: () {Navigator.of(context).pop(true);},
        ),
      );
    } else {
      if (iptalButonYazisi != null) {
        tumButonlar.add(RaisedButton(color: Colors.red,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            iptalButonYazisi,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ));
      }

      tumButonlar.add(
        OutlineButton(
          onPressed: () {Navigator.of(context).pop(true);},
          child: Text(anaButonYazisi,style: TextStyle(color: Colors.red),),
        ),
      );


    }
    return tumButonlar;
  }





}
