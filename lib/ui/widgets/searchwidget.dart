import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messengerish/global.dart';
import 'package:messengerish/ui/widgets/widgets.dart';

class Search extends SearchDelegate<Map<String, dynamic>>{

  Search(String m){
    print(m);
  }

  List<Map<String, dynamic>> recent = [
    {
    'status' : MessageType.received,
    'contactImgUrl' : 'https://cdn.pixabay.com/photo/2015/01/08/18/29/entrepreneur-593358_960_720.jpg',
    'contactName' : 'Client',
    'message' : 'Hi mate, I\d like to hire you to create a mobile app for my business' ,
    'time' : '08:43 AM',
    'style' : {
        'size' : 16.0,
        'isBold' : false,
        'isItalic' : false,
        }
    },
  ];

  Map<String, dynamic> result;
  String title = "Title";
  String observations = "Observation";
  void setSuggestions(Map<String, dynamic> res){
    result = res;
  }

  Map<String, dynamic> getSggestions(){
    return result;
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null || query.isEmpty) {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty) {
      return [TextSpan(text: source)];
    }
    matches.sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches) {
      if (match.end <= lastMatchEnd) {
        // already matched -> ignore
      } else if (match.start <= lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.end),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ));
      } else if (match.start > lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));

        children.add(TextSpan(
          text: source.substring(match.start, match.end),
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ));
      }

      if (lastMatchEnd < match.end) {
        lastMatchEnd = match.end;
      }
    }

    if (lastMatchEnd < source.length) {
      children.add(TextSpan(
        text: source.substring(lastMatchEnd, source.length),
      ));
    }

    return children;
  }

  bool check(String source1, String source2, String query){
    if((source1 != null && source1.contains(query)) || source2.contains(query)){
      return true;
    }
    return false;
  }

  Widget Observation(){
//    final Map<String, dynamic> res = getSggestions();
//    final String title = res['title'] == null
//        ? "Title"
//        : res['title'];
//    final String msg = res['message'] == null
//        ? "Observation"
//        : res['message'];
//    print(title+" "+ msg);
    return Center(
//      width: 200,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.blue,
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.assignment, size: 70),
              title: Text(
                  title,
                  style: TextStyle(color: Colors.white)),
              subtitle: Text(
                  observations,
                  style: TextStyle(color: Colors.white)
              ),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Edit', style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                  FlatButton(
                    child: const Text('Delete', style: TextStyle(color: Colors.white)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return   Observation();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty ?
                            recent :
                            messages
                                .where((msg) => check(msg['title'] == null ? "" : msg['title'].toLowerCase(), msg['message'].toLowerCase(), query.toLowerCase()))
//                                .where((msg) => msg['title'].contains(query))
                                .toList();
    return ListView.builder(
      itemCount: suggestions.length,
        itemBuilder: (context, i){
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter state){
              return ListTile(
                onTap: (){
                  state(() => {
                    result = suggestions[i],
                    title = suggestions[i]['title'] == null ? "Title" : suggestions[i]['title'],
                    observations = suggestions[i]['message'] == null ? "Observation" : suggestions[i]['message']
                  });
                  showResults(context);
                },
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: highlightOccurrences(suggestions[i]['title'] == null ? "Title" : suggestions[i]['title'] , query),
                  ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: highlightOccurrences(suggestions[i]['message'] , query),
                  ),
                ),
                trailing: Text(suggestions[i]['time'] == null ? "WHY??": suggestions[i]['time']),
              );
            },
          );
        }
        );
    }
  
}