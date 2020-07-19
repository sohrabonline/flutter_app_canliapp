import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  Color textColor;
  Color butonColor;
  String butonText;
  double radius;
  double yukseklik;
  Widget butonIcon;
  VoidCallback onPressed;

  SocialLoginButton(
      {this.textColor: Colors.white,
      this.butonColor : Colors.transparent,
      @required this.butonText,
      this.radius : 10,
      this.yukseklik : 50,
      this.butonIcon,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: SizedBox(height: yukseklik,
        child: RaisedButton(
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius))),
          color: butonColor,
          child: Row(mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
             if (butonIcon!=null)... [
               butonIcon,
               Text(
                 butonText,
                 style: TextStyle(color: textColor),
               ),
               Opacity(opacity: 0,child: butonIcon)
             ],
              if(butonIcon==null)...[Container(),
                Center(child: Text(butonText,style: TextStyle(color: textColor),)),
                Container()
              ]
            ],
          ),
        ),
      ),
    );
  }
}
