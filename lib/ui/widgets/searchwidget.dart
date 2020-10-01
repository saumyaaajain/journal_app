import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_app/helper/Helper.dart';

class Search extends SearchDelegate<Map<String, dynamic>>{
  List<DocumentSnapshot> mes;
  List<DocumentSnapshot> recent = [];

  DocumentSnapshot result;
  String title = "Title";
  String observations = "Observation";

  Search(dynamic m){
    mes = m;
    print(mes[0].documentID);
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

  Widget observation(){
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
    return   observation();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<DocumentSnapshot> suggestions = query.isEmpty ?
                            recent :
                            mes
                                .where((msg) => check(msg['title'] == null ? "" : msg['title'].toLowerCase(), msg['message'].toLowerCase(), query.toLowerCase()))
//                                .where((msg) => msg['title'].contains(query))
                                .toList();
    if(suggestions.isEmpty){
      return ListTile(
        leading: Icon(Icons.close),
        title: Text("No item found"),
      );
    }
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
                trailing: Text(suggestions[i]['time'] == null ? "WHY??": Helper().getTime(suggestions[i]['time'])),
              );
            },
          );
        }
        );
    }
  
}
