import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/app/sign_in/sign_in_page.dart';
import 'package:flutterappcanliapp/view_model/user_model.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/esevs/Flutter/flutter_app_canliapp/lib/app/home_page.dart';

class LandingPage extends StatelessWidget {

  var _userModel;


  @override
  Widget build(BuildContext context) {
     _userModel = Provider.of<UserModel>(context,listen: true);  //listen oxumag

    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(user: _userModel.user);
      }
    }   else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
