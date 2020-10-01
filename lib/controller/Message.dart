import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message{
  CollectionReference db = Firestore.instance.collection('journal');

  Future<QuerySnapshot> getData(){
    return db.getDocuments();
  }

  Future<void> addObservation(String title, String observation, int size, bool isBold, bool isItalic) {
    // Call the user's CollectionReference to add a new user
    return db
        .add({
      'title' : title,
      'message' : observation,
      'time' : TimeOfDay,
      'style' : {
        'size' : size,
        'isBold' : isBold,
        'isItalic' : isItalic,
      }
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
