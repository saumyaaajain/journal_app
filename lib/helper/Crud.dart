import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messengerish/provider/FirebaseProvider.dart';

class CRUD{
  FirebaseProvider fp;

  CRUD(String id){
    fp = new FirebaseProvider(id);
  }

  addObservation(String title, String observation, double size, bool isBold, bool isItalic){
    fp.addObservation(title, observation, size, isBold, isItalic)
        .then((value) => print("successful"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  deleteObservation(String id){
    fp.deleteObservation(id)
        .then((e) => print("Sucessfull"))
        .catchError((e) => print(e.toString()));
  }

  addExperiment(String title){
    fp.addExperiment(title)
        .then((e) => print("successfull"))
        .catchError((e) => print(e));
  }
}