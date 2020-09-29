import 'package:messengerish/provider/FirebaseProvider.dart';

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