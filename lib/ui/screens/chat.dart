import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messengerish/global.dart';
import 'package:messengerish/ui/widgets/searchwidget.dart';
import 'package:messengerish/bloc/ObservationBloc.dart';
import 'package:messengerish/helper/Crud.dart';
import 'package:messengerish/helper/Helper.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.title, this.uid});
  String title;
  String uid;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool isBold = false, isItalic = false;
  double _currentSliderValue = 40;
  TextEditingController msg = new TextEditingController();
  TextEditingController _title = new TextEditingController();
  TextEditingController _observation = new TextEditingController();
  CollectionReference db = Firestore.instance.collection('journal');
  Future<List<DocumentSnapshot>> futureData;
  int pageNo = 1;
  DocumentSnapshot lastVisible;
  ObservationBloc observationBloc;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    observationBloc= ObservationBloc("users/${widget.uid}/experiments/${widget.title}/listOfExperiments");
    observationBloc.fetchFirstList();
    controller.addListener(_scrollListener);
    print(widget.title);
//    futureData = fetchData();
  }

  Future<QuerySnapshot> getData(){
    return db.getDocuments();
  }
//
//  Future<List<dynamic>> fetchData() async {
//    return db;
//  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      observationBloc.fetchNextMovies();
    }
  }

  void sendMsg(){
    if(_title.text.length <= 0 || _observation.text.length <= 0){
      return;
    }
    print("reaching");
    setState(() {
      messages.add({
        'title' : _title.text,
        'message' : _observation.text,
        'time' : DateTime.now(),
        'style' : {
          'size' : _currentSliderValue,
          'isBold' : isBold,
          'isItalic' : isItalic,
        }
      });
    });
    CRUD("users/${widget.uid}/experiments/${widget.title}/listOfExperiments").addObservation(_title.text, _observation.text, _currentSliderValue, isBold, isItalic);
    msg.clear();
    _title.clear();
    _observation.clear();
    setState(() {
      isBold = false;
      isItalic = false;
      _currentSliderValue = 40;
    });
    _scrollListener();
  }

  Widget bodyContent(dynamic messages){
    String time = Helper().getTime(messages['time']);
    return Padding(
      padding: EdgeInsets.only(top: 7, bottom: 7, left: 0, right: 0),
      child: ListTile(
        onLongPress: (){
          CRUD("users/${widget.uid}/experiments/${widget.title}/listOfExperiments").deleteObservation(messages.documentID);
          observationBloc.fetchFirstList();
          },
//                        leading: Icon(Icons.assignment),
        title: Text(
          messages['title'] != null ? messages['title'] : "Title",
          style: TextStyle(
              fontSize: messages['style']['size'] == null ? 20 : messages['style']['size'],
              fontWeight: messages['style']['isBold'] ? FontWeight.bold : FontWeight.normal,
              fontStyle: messages['style']['isItalic'] ? FontStyle.italic : FontStyle.normal
          ),
        ),
        subtitle: Text(
          messages['message'],
          style: TextStyle(
              fontSize: messages['style']['size'] == null ? 20 : messages['style']['size'],
              fontWeight: messages['style']['isBold'] ? FontWeight.bold : FontWeight.normal,
              fontStyle: messages['style']['isItalic'] ? FontStyle.italic : FontStyle.normal
          ),
        ),
        trailing: Column(
          children: <Widget>[
            Icon(
              Icons.calendar_today,
//                              color: Colors.white,
            ),
            Text(
              time,
              style: TextStyle(
//                fontSize: messages['size'] == null ? 20 : messages['size'],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Colors.white,
      appBar: AppBar(
//        backgroundColor: Colors.blueGrey,
//        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.assignment),
            SizedBox(width: 15),
            Text(
              "My Experiment-1",
              style: Theme.of(context).textTheme.subhead,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet<void>(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                ),
                context: context,
                builder: (BuildContext context) {
                  return Container(
                      height: 12200,
                      width: 500,
//                    color: Colors.black12,
                      child:  StatefulBuilder(
                        builder: (context, state) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only( bottom: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(
                                        Icons.note_add,
                                      size: 32,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "Add an observation",
                                      style: TextStyle(
                                        color: Colors.blue,
                                          fontSize: 27
                                      ),
                                    ),
                                  ],
                                )
                              ),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                      fontSize: _currentSliderValue,
                                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                                    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal
                                  ),
                                  controller: _title,
//                              maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: "Title of observation",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                      fontSize: _currentSliderValue,
                                      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                                      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal
                                  ),
                                  controller: _observation,
//                              maxLines: 10,
                                  decoration: InputDecoration(
                                    hintText: "Observation",
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBox(
                                    width: 220,
                                    child: Slider(
                                      value: _currentSliderValue,
                                      min: 20,
                                      max: 60,
                                      divisions: 8,
                                      label: _currentSliderValue.round().toString(),
                                      onChanged: (double value) {
                                        print(value);
                                        state(() {
                                          _currentSliderValue = value;
                                        });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    color: isBold ? Colors.blue : Colors.black26,
                                    icon: Icon(Icons.format_bold),
                                    onPressed: (){
                                      state(() {
                                        isBold = !isBold;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    color: isItalic ? Colors.blue : Colors.black26,
                                    icon: Icon(Icons.format_italic),
                                    onPressed: (){
                                      state(() {
                                        isItalic = !isItalic;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              FlatButton(
                                textColor: Colors.blue,
//                                color: Colors.blue,
                                child: Text(
                                    "Submit",
                                  style: TextStyle(
                                    fontSize: 27
                                  ),
                                ),
                                onPressed: (){
                                  sendMsg();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: Search(observationBloc.documentList));
            },
          ),
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: observationBloc.observationStream,
        builder: (context, snapshot){
          if(snapshot.connectionState != ConnectionState.waiting){
            if(!snapshot.hasData){
              return Center(
                child: Card(
                  child: ListTile(
                    leading: Icon(Icons.clear),
                    title: Text("No Observations found"),
                  ),
                ),
              );
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                controller: controller,
                itemBuilder: (context, i){
                  return bodyContent(snapshot.data[i]);
                });
          }
          return Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}
