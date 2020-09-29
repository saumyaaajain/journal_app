import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messengerish/provider/FirebaseProvider.dart';
import 'package:rxdart/rxdart.dart';

class CRUD{
  FirebaseProvider fp = new FirebaseProvider();
  addObservation(String title, String observation, double size, bool isBold, bool isItalic){
    fp.addObservation(title, observation, size, isBold, isItalic)
        .then((value) => {
          print("User Added"),
        })
        .catchError((error) => print("Failed to add user: $error"));
  }
}