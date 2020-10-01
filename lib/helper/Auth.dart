import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAuth {

  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  String id;

  Future<String> signIn(String email, String password) async {
    List<DocumentSnapshot> documentList;
    documentList = (await Firestore.instance
        .collection("auth")
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: password)
        .getDocuments())
        .documents;
    id = documentList[0].documentID;
//    FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return id;
  }

  Future<String> createUser(String email, String password) async {
    print("create user");
    print(email+" "+password);
    DocumentReference docRef = await Firestore.instance.collection('auth')
        .add({'email': email, 'password': password})
        .then((docRef) => docRef).catchError((e) => e);
    id = docRef.documentID;
    await Firestore.instance.collection('users/$id/experiments').add({
      'title': 'MyFirstExperiment',
      'time' : DateTime.now(),
    });
//    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return id;
  }

  Future<String> currentUser() async {
//    FirebaseUser user = await _firebaseAuth.currentUser();
//    return user != null ? user.uid : null;
      return id;
  }

  Future<void> signOut() async {
    id = "";
//    return _firebaseAuth.signOut();
    return id;
  }

}
