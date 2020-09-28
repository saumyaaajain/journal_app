import 'package:flutter/material.dart';

class Message{
  String title;
  String message;
//  TimeOfDay time;
  String time;
  Style style;

//  Message(Map<String, dynamic> doc){
//    title = doc['title'];
//    message = doc['message'];
//    time = doc['time'];
//    style = new Style(doc['style']);
//  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      title: json['title'],
      message: json['message'],
      time: json['time'],
      style: Style.fromJson(json['style']),
    );
  }

  Message({this.title, this.message, this.time, this.style});
//  {
//    this.style = new Style(size: size, isBold: isBold, isItalic: isItalic);
//  }
}

class Style{
  double size;
  bool isBold;
  bool isItalic;

//  Style(Map<String, dynamic> style){
//    isBold = style['isBold'];
//    isItalic = style['isItalic'];
//    size = style['size'];
//  }

  factory Style.fromJson(Map<String, dynamic> json) {
    return Style(
      size: json['size'],
      isBold: json['isBold'],
      isItalic: json['isItalic'],
    );
  }

  Style({this.size, this.isBold, this.isItalic});
}