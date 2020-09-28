import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messengerish/controller/Message.dart';
import 'package:messengerish/model/Message.dart' as MessageModel;


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTime();
//    getData();
  }

  startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(_duration, () => navigationPage('chat'));
  }


  void getData(){
    List<MessageModel.Message> msg = [];
    Message().getData().then((value) => {
//      print(value.documents.length),
//      value.documents.forEach((doc) => msg.add(MessageModel.Message(doc.data))),
//      print(msg),
      navigationPage('chat'),
    }).catchError((e) => {
      print(e),
      navigationPage('home')
    });
  }

  void navigationPage(String page) {
    Navigator.of(context).pushReplacementNamed(page);
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
