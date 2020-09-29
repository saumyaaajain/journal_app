//import 'dart:html';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messengerish/global.dart';
import 'package:messengerish/ui/widgets/widgets.dart';
import 'package:messengerish/ui/widgets/searchwidget.dart';
import 'package:messengerish/model/Message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _showBottom = false;
  bool isBold = false, isItalic = false;
  double _currentSliderValue = 40;
  TextEditingController msg = new TextEditingController();
  TextEditingController _title = new TextEditingController();
  TextEditingController _observation = new TextEditingController();
  CollectionReference db = Firestore.instance.collection('journal');
  Future<List<DocumentSnapshot>> futureData;
  int pageNo = 1;
  DocumentSnapshot lastVisible;

  @override
  void initState() {
    super.initState();
//    futureData = fetchData();
  }

  Future<QuerySnapshot> getData(){
    return db.getDocuments();
  }
//
//  Future<List<dynamic>> fetchData() async {
//    return db;
//  }

  void sendMsg(){
    if(_title.text.length <= 0 || _observation.text.length <= 0){
      return;
    }
    print("reaching");
    setState(() {
      messages.add({
        'status' : MessageType.received,
        'contactImgUrl' : 'https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg',
        'contactName' : 'Client',
        'title' : _title.text,
        'message' : _observation.text,
        'time' : '08:49 AM',
        'style' : {
          'size' : _currentSliderValue,
          'isBold' : isBold,
          'isItalic' : isItalic,
        }
      });
    });
//    addUser();
    msg.clear();
    _title.clear();
    _observation.clear();
    setState(() {
      isBold = false;
      isItalic = false;
      _currentSliderValue = 40;
    });
  }

  Widget bodyContent(dynamic messages){
    return Padding(
      padding: EdgeInsets.only(top: 7, bottom: 7, left: 0, right: 0),
      child: ListTile(
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
              messages['time'],
              style: TextStyle(
//                                fontSize: messages[i]['size'] == null ? 20 : messages[i]['size'],
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
            MyCircleAvatar(
              imgUrl: friendsList[0]['imgUrl'],
            ),
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
                                          fontSize: 35
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
                                    width: 250,
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
              showSearch(context: context, delegate: Search("hello"));
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: StreamBuilder(
                    stream: pageNo == 1 ? db.limit(1).snapshots() : db.startAfterDocument(lastVisible).limit(1).snapshots(),
                    builder: (context, snapshot){
                      if(snapshot.hasData){
                            () async {
                              setState(() {
                              lastVisible = snapshot.data.documents[snapshot.data.documents.length-1];
                              });
                            }();
                        print(snapshot.data.documents[snapshot.data.documents.length-1]);
                        return ListView.builder(
                          itemCount: snapshot.data.documents.length,
                            itemBuilder: (context, i){
                              return bodyContent(snapshot.data.documents[i]);
                        });
                      }
                      return Text("Loading");
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  height: 61,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
//                      Expanded(
//                        child: Container(
//                          decoration: BoxDecoration(
//                            color: Colors.white,
//                            borderRadius: BorderRadius.circular(35.0),
//                            boxShadow: [
//                              BoxShadow(
//                                  offset: Offset(0, 3),
//                                  blurRadius: 5,
//                                  color: Colors.grey)
//                            ],
//                          ),
//                          child: Row(
//                            children: <Widget>[
//                              IconButton(
//                                  icon: Icon(Icons.keyboard), onPressed: () {}),
//                              Expanded(
//                                child: TextField(
//                                  style: TextStyle(
//                                    fontSize: _currentSliderValue == 0 ? 5 : _currentSliderValue*0.6,
//                                  ),
//                                  decoration: InputDecoration(
//                                      hintText: "Type Something...",
//                                      border: InputBorder.none,
//                                  ),
//                                  controller: msg,
//                                ),
//                              ),
//                              IconButton(
//                                icon: Icon(Icons.format_bold),
//                                onPressed: () {},
//                              ),
//                              IconButton(
//                                icon: Icon(Icons.format_italic),
//                                onPressed: () {},
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
//                      SizedBox(width: 15),
//                      Container(
//                        padding: const EdgeInsets.all(15.0),
//                        decoration: BoxDecoration(
//                            color: myGreen, shape: BoxShape.circle),
//                        child: InkWell(
//                          child: Icon(
//                            Icons.note_add,
//                            color: Colors.white,
//                          ),
//                          onLongPress: () {
//                            setState(() {
//                              _showBottom = true;
//                            });
//                          },
//                        ),
//                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        color: Colors.blueAccent,
                        onPressed: (){
                          if(pageNo == 1){
                            return;
                          }
                          setState(() {
                            pageNo -= 1;
                          });
                        },
                      ),
                      Text(
                        pageNo.toString(),
                        style: TextStyle(
                            color: Colors.blue
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        color: Colors.blueAccent,
                        onPressed: (){
                          setState(() {
                            pageNo += 1;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
//          Positioned.fill(
//            child: GestureDetector(
//              onTap: () {
//                  sendMsg();
////                setState(() {
////                  _showBottom = false;
////                });
//              },
//              onLongPress: (){
//                setState(() {
//                  _showBottom = true;
//                });
//              },
//            ),
//          ),
//          _showBottom
//              ? Positioned(
//                  bottom: 90,
////                  left: ,
//                  right: 20,
//                  child: Container(
//                    padding: EdgeInsets.all(25.0),
//                    decoration: BoxDecoration(
//                      color: Colors.white,
//                      borderRadius: BorderRadius.all(Radius.circular(32)),
//                      boxShadow: [
//                        BoxShadow(
//                            offset: Offset(0, 5),
//                            blurRadius: 15.0,
//                            color: Colors.grey)
//                      ],
//                    ),
//                    child: RotatedBox(
//                      quarterTurns: 1,
//                      child: Slider(
//                        value: _currentSliderValue,
//                        min: 0,
//                        max: 100,
//                        divisions: 5,
//                        label: _currentSliderValue.round().toString(),
//                        onChangeEnd: (double value){
//                          setState(() {
//                            _showBottom = false;
//                          });
//                        },
//                        onChanged: (double value) {
//                          setState(() {
//                            _currentSliderValue = value;
//                          });
//                        },
//                      ),
//                    ),
//                  ),
//                )
//              : Container(),
        ],
      ),
    );
  }
}

List<IconData> icons = [
  Icons.image,
  Icons.camera,
  Icons.file_upload,
  Icons.folder,
  Icons.gif
];
