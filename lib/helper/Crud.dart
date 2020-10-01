import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/provider/FirebaseProvider.dart';

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

  Future<bool> deleteObservation(String id){
    return fp.deleteObservation(id)
        .then((e) => true)
        .catchError((e) => false);
  }

  addExperiment(String title){
    fp.addExperiment(title)
        .then((e) => print("successfull"))
        .catchError((e) => print(e));
  }
}
