import 'package:flutter/material.dart';
import 'package:flutterappcanliapp/locator.dart';
import 'package:flutterappcanliapp/view_model/user_model.dart';
import 'package:provider/provider.dart';

import 'file:///C:/Users/esevs/Flutter/flutter_app_canliapp/lib/app/landing_page.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (contex)=>UserModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: LandingPage(),
      ),
    );
  }
}
