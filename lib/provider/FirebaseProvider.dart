import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProvider {
  Future<List<DocumentSnapshot>> fetchFirstList() async {
    return (await Firestore.instance
        .collection("journal")
//        .orderBy("rank")
        .limit(1)
        .getDocuments())
        .documents;
  }

  Future<List<DocumentSnapshot>> fetchNextList(List<DocumentSnapshot> documentList) async {
    return (await Firestore.instance
        .collection("journal")
//        .orderBy("rank")
        .startAfterDocument(documentList[documentList.length - 1])
        .limit(1)
        .getDocuments())
        .documents;
  }
}