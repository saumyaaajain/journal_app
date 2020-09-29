import 'package:flutter/material.dart';
import 'package:messengerish/global.dart';
import 'package:messengerish/helper/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({this.uid, this.auth, this.onSignOut});
  String uid;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }

    }

    void getData() async{
      print("hello");
      await Firestore.instance
          .collection(uid)
          .document("W1U13lfchgjOMwVnqUf6")
          .get()
          .then((doc) => {
              print(doc['hello']),
          }).catchError((error) => {
              print("Error getting document:"+ error.toString())
      });
    }

    Widget Experiments(dynamic experiments){
      print(experiments[0]['title']);
      return Text("Hello");
//      return ListView.builder(
//        itemCount: experiments.length,
//        itemBuilder: (ctx, i) {
//          return Padding(
//            padding: EdgeInsets.symmetric(vertical: 7),
//            child: Column(
//              children: <Widget>[
//                ListTile(
//                  onLongPress: () {},
//                  onTap: () => Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => ChatScreen()),
//                  ),
//                  leading: Container(
//                    width: 50,
//                    height: 50,
//                    decoration: BoxDecoration(
//                      shape: BoxShape.circle,
//                      border: Border.all(
//                        color: Colors.white,
//                        width: 3,
//                      ),
//                      boxShadow: [
//                        BoxShadow(
//                            color: Colors.grey.withOpacity(.3),
//                            offset: Offset(0, 5),
//                            blurRadius: 25)
//                      ],
//                    ),
//                    child: Icon(Icons.assignment),
//                  ),
//                  title: Text(
//                    "${experiments[i]['experimentName']}",
//                    style: Theme.of(context).textTheme.title,
//                  ),
////                  trailing: Container(
////                    width: 60,
////                    child: Column(
////                      crossAxisAlignment: CrossAxisAlignment.end,
////                      children: <Widget>[
////                        Row(
////                          mainAxisSize: MainAxisSize.min,
////                          children: <Widget>[
////                            Text("${experiments[i]['lastMsgTime']}")
////                          ],
////                        ),
////                        SizedBox(
////                          height: 5.0,
////                        ),
////                      ],
////                    ),
////                  ),
//                ),
//                Divider()
//              ],
//            ),
//          );
//        },
//      );
    }

    void printLen(dynamic obj) async{
      print("in len");
      int len = await obj.length;
      print(len);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black45),
        iconTheme: IconThemeData(color: Colors.black45),
        title: Text(uid.toString()),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection(uid).snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData) {
            return Experiments(snapshot.data.documents);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },

      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        onPressed: () => getData(), //) () async{
////          await Firestore.instance.collection("$uid/name/experiments/").add({
////            'title' : "Trying to add style",
////            'message' : "map doesnt work",
////            'time' : DateTime.now(),
////            'style' : {
////              'size' : 16.2,
////              'isBold' : true,
////              'isItalic' : false,
////            }
////          }).then((v) => print("Successful")).catchError((e) => print(e));
////        },
//      ),
    );
  }
}
