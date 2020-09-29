import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messengerish/provider/FirebaseProvider.dart';
import 'package:rxdart/rxdart.dart';

class ObservationBloc {
  FirebaseProvider firebaseProvider;

  bool showIndicator = false;
  List<DocumentSnapshot> documentList;

  BehaviorSubject<List<DocumentSnapshot>> observationController;

  BehaviorSubject<bool> showIndicatorController;

  ObservationBloc(String path) {
    observationController = BehaviorSubject<List<DocumentSnapshot>>();
    showIndicatorController = BehaviorSubject<bool>();
    firebaseProvider = FirebaseProvider(path);
  }

  Stream get getShowIndicatorStream => showIndicatorController.stream;

  Stream<List<DocumentSnapshot>> get observationStream => observationController.stream;

/*This method will automatically fetch first 10 elements from the document list */
  Future fetchFirstList() async {
    try {
      documentList = await firebaseProvider.fetchFirstList();
      print(documentList);
      observationController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          observationController.sink.addError("No Data Available");
        }
      } catch (e) {}
    } on SocketException {
      observationController.sink.addError(SocketException("No Internet Connection"));
    } catch (e) {
      print(e.toString());
      observationController.sink.addError(e);
    }
  }

/*This will automatically fetch the next 10 elements from the list*/
  fetchNextMovies() async {
    try {
      updateIndicator(true);
      List<DocumentSnapshot> newDocumentList = await firebaseProvider.fetchNextList(documentList);
      documentList.addAll(newDocumentList);
      print("new:::::: "+documentList.length.toString());
      observationController.sink.add(documentList);
      try {
        if (documentList.length == 0) {
          observationController.sink.addError("No Data Available");
          updateIndicator(false);
        }
      } catch (e) {
        updateIndicator(false);
      }
    } on SocketException {
      observationController.sink.addError(SocketException("No Internet Connection"));
      updateIndicator(false);
    } catch (e) {
      updateIndicator(false);
      print(e.toString());
      observationController.sink.addError(e);
    }
  }

/*For updating the indicator below every list and paginate*/
  updateIndicator(bool value) async {
    showIndicator = value;
    showIndicatorController.sink.add(value);
  }

  void dispose() {
    observationController.close();
    showIndicatorController.close();
  }
}