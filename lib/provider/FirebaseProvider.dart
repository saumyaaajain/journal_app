import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  CollectionReference db;

  FirebaseProvider(String path){
    print(path);
    db = Firestore.instance.collection(path);
  }

  Future<List<DocumentSnapshot>> fetchFirstList() async {
    return (await db
        .orderBy("time")
        .limit(10)
        .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList(List<DocumentSnapshot> documentList) async {
    return (await db
        .orderBy("time")
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(10)
        .getDocuments())
        .documents;
  }

  Future<void> addObservation(String title, String observation, double size, bool isBold, bool isItalic) {
    // Call the user's CollectionReference to add a new user
    return db
        .add({
      'title' : title,
      'message' : observation,
      'time' : DateTime.now(),
      'style' : {
        'size' : size,
        'isBold' : isBold,
        'isItalic' : isItalic,
      }
    });
  }

  Future<void> deleteObservation(String id){
    return db.document(id).delete();
  }
}