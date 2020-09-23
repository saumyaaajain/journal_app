import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messengerish/global.dart';
import 'package:messengerish/ui/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _showBottom = false;
  double _currentSliderValue = 40;
  TextEditingController msg = new TextEditingController();


  void sendMsg(){
    if(msg.text.length <= 0){
      return;
    }
    print("reaching");
    setState(() {
      messages.add({
        'status' : MessageType.received,
        'contactImgUrl' : 'https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg',
        'contactName' : 'Client',
        'message' : msg.text,
        'time' : '08:49 AM',
        'size' : _currentSliderValue == 0 ? 5 : _currentSliderValue*0.6
      });
    });
    msg.clear();
    print(messages[messages.length-1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black54),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MyCircleAvatar(
              imgUrl: friendsList[0]['imgUrl'],
            ),
            SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Cybdom Tech",
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.clip,
                ),
                Text(
                  "Online",
                  style: Theme.of(context).textTheme.subtitle.apply(
                        color: myGreen,
                      ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.phone),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: messages.length,
                    itemBuilder: (ctx, i) {
                      if (messages[i]['status'] == MessageType.received) {
                        return ReceivedMessagesWidget(i: i);
                      } else {
                        return SentMessageWidget(i: i);
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15.0),
                  height: 61,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(35.0),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 3),
                                  blurRadius: 5,
                                  color: Colors.grey)
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.keyboard), onPressed: () {}),
                              Expanded(
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: _currentSliderValue == 0 ? 5 : _currentSliderValue*0.6,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: "Type Something...",
                                      border: InputBorder.none,
                                  ),
                                  controller: msg,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.photo_camera),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.attach_file),
                                onPressed: () {},
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 15),
                      Container(
                        padding: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                            color: myGreen, shape: BoxShape.circle),
                        child: InkWell(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                          onLongPress: () {
                            setState(() {
                              _showBottom = true;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                  sendMsg();
//                setState(() {
//                  _showBottom = false;
//                });
              },
              onLongPress: (){
                setState(() {
                  _showBottom = true;
                });
              },
            ),
          ),
          _showBottom
              ? Positioned(
                  bottom: 90,
//                  left: ,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(25.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 5),
                            blurRadius: 15.0,
                            color: Colors.grey)
                      ],
                    ),
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: Slider(
                        value: _currentSliderValue,
                        min: 0,
                        max: 100,
                        divisions: 5,
                        label: _currentSliderValue.round().toString(),
                        onChangeEnd: (double value){
                          setState(() {
                            _showBottom = false;
                          });
                        },
                        onChanged: (double value) {
                          setState(() {
                            _currentSliderValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                )
              : Container(),
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
