import 'package:flutter/material.dart';
import 'package:test_app/ui/screens/Login.dart';
import 'package:test_app/ui/screens/SplashScreen.dart';
import 'package:test_app/ui/screens/screens.dart';

Future<void> main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Journal',
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//        textTheme: TextTheme(
//          bodyText1: TextStyle(),
//          bodyText2: TextStyle(),
////          title: TextStyle(),
////          subtitle: TextStyle(),
//          subtitle1: TextStyle(),
//          subtitle2: TextStyle(),
//          caption: TextStyle(),
//        ).apply(
//          bodyColor: Colors.white,
//          displayColor: Colors.white,
//        ),
//        iconTheme: IconThemeData(
//          color: Colors.green
//        ),
//      ),
      home: SplashScreen(), //HomeScreen(),
      routes: {
        'login': (cxt) => LoginPage(),
        'chat': (ctx) => ChatScreen(),
        'home': (ctx) => HomeScreen(),
      },
    );
  }
}
