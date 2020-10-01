import 'package:cloud_firestore/cloud_firestore.dart';

class Helper{
  String getTime(Timestamp t){
    DateTime time = DateTime.parse(t.toDate().toString());
    String timeStr;
    if(time.hour > 12){
      String hours = (time.hour-12).toString();
      String mins = time.minute.toString();
      timeStr = hours+":"+mins+" PM";
    } else if(time.hour == 12){
      timeStr = "12:"+time.minute.toString()+" PM";
    }else if(time.hour == 0){
      timeStr = "12:"+time.minute.toString()+" AM";
    } else{
      timeStr = time.hour.toString()+":"+time.minute.toString()+" AM";
    }
    return timeStr;
  }
}
