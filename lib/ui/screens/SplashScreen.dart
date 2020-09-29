import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messengerish/helper/Auth.dart';
import 'package:messengerish/ui/screens/RootPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTime();
  }


  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () => navigationPage());
  }

  void navigationPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RootPage(auth: new Auth(),)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Image.asset('assets/splash_page.png'),
      ),
    );
  }
}
