import 'package:flutter/material.dart';
import 'package:messengerish/helper/Auth.dart';
import 'package:messengerish/ui/screens/Login.dart';
import 'package:messengerish/ui/screens/home.dart';

class RootPage extends StatefulWidget {
  RootPage({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {

  AuthStatus authStatus = AuthStatus.notSignedIn;
  String uid;

  initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
        uid = userId;
        authStatus = userId != null ? AuthStatus.signedIn : AuthStatus.notSignedIn;
      });
    });
  }

  void _updateAuthStatus(AuthStatus status) {
    setState(() {
      authStatus = status;
    });
  }

  void setUid(String uid){
    print(uid);
    setState(() {
      this.uid = uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return new LoginPage(
          title: 'Flutter Login',
          auth: widget.auth,
          setUid: (String uid) => setUid(uid),
          onSignIn: () => _updateAuthStatus(AuthStatus.signedIn),
        );
      case AuthStatus.signedIn:
        return new HomeScreen(
            auth: widget.auth,
            uid: uid,
            onSignOut: () => _updateAuthStatus(AuthStatus.notSignedIn)
        );
    }
  }
}