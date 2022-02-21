import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_whatsapp/Controller/global_methods.dart';
import 'package:my_whatsapp/config/config.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

import '../main.dart';

class MyProvider extends ChangeNotifier{
  var messages;
  var getUnSeenMessagesList = [];

  fetchMessagesUser(uid){
    
      var seenTime;

  firebaseInstance.doc(uid).get().then((event) {
    seenTime = DateTime.parse(event.get('seenTime').toDate().toString());
    firebaseInstance.doc(uid).collection("privateChat").get().then((value) {
    getUnSeenMessagesList.clear();
      value.docs.forEach((element) {
        if (element.get("isSentByMe") == false) {
        print("inside me");
          // print(element.get("isSentByMe") == false);
          if (DateTime.parse(element.get("time").toDate().toString())
                  .compareTo(seenTime) >
              0) {
                // showNotification(element);
            getUnSeenMessagesList.add(element);
              notifyListeners();
            // print(count++);
            print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ${getUnSeenMessagesList.length}");
          }else{
            print("No Message");
          }
        }       
      });
    });

    // countData = getUnSeenMessagesList;
  });
          
  }




  showNotification(QueryDocumentSnapshot message){
      flutterLocalNotificationsPlugin.show(
        0,
        message.get("time").toString(),
        message.get("message"),
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: primaryColor,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
  }


}