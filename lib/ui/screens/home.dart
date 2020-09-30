import 'package:flutter/material.dart';
import 'package:messengerish/helper/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messengerish/helper/Helper.dart';
import 'package:messengerish/helper/Crud.dart';

import 'chat.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({this.uid, this.auth, this.onSignOut});
  String uid;
  final BaseAuth auth;
  final VoidCallback onSignOut;
  TextEditingController experimentController = new TextEditingController();
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

    void addData() async{
      CRUD("users/$uid/experiments").addExperiment(experimentController.text);
    }

    void deleteData(String id) async{
      CRUD("users/$uid/experiments").deleteObservation(id);
    }

    Widget Experiments(dynamic experiments){
      print(experiments[0]['title']);
//      return Text("Hello");
      return ListView.builder(
        itemCount: experiments.length + 1,
        itemBuilder: (ctx, i) {
          if(i < experiments.length){
            String time = Helper().getTime(experiments[i]['time']);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 7),
              child: Column(
                children: <Widget>[
                  ListTile(
                    onLongPress: () {
                      deleteData(experiments[i].documentID);
                    },
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatScreen(
                        uid: uid,
                        title: experiments[i].documentID,
                      )),
                    ),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.3),
                              offset: Offset(0, 5),
                              blurRadius: 25)
                        ],
                      ),
                      child: Icon(Icons.assignment),
                    ),
                    title: Text(
                      "${experiments[i]['title']}",
                      style: Theme.of(context).textTheme.title,
                    ),
                    trailing: Container(
                      width: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("$time")
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider()
                ],
              ),
            );
          } else{
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 250,
                  child: TextField(
                    controller: experimentController,
                    decoration: InputDecoration(
                        hintText: 'Add an experiment'
                    ),
                  ),
                ),
                FlatButton(
                    onPressed: addData,
                    child: Icon(Icons.add)
                ),
              ],
            );
          }
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.black45),
        iconTheme: IconThemeData(color: Colors.black45),
        title: Text("Experiments Tracker App"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("/users/$uid/experiments").snapshots(),
        builder: (context, snapshot){
          if(snapshot.hasData) {
            return Experiments(snapshot.data.documents);
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
