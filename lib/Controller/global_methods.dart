import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_whatsapp/Controller/global_state.dart';

var firebaseInstance = FirebaseFirestore.instance
    .collection("chats")
    .doc(GlobalState.myNumber)
    .collection("personalChats");

fetchAllMessages() {
  firebaseInstance.snapshots().listen((event) {
    print(event.docs);
    GlobalState.dataListen = event.docs;
  });
}

getLastOpenChat() {
  // firebaseInstance.doc(uid)
}

var unSeenMessagesList = [];

var countData;
getUnSeenMessages(uid) {
  // var count = '2';
  var seenTime;

  firebaseInstance.doc(uid).snapshots().listen((event) {
    seenTime = DateTime.parse(event.get('seenTime').toDate().toString());
    firebaseInstance.doc(uid).collection("privateChat").get().then((value) {
      value.docs.forEach((element) {
        print("inside me");
        if (element.get("isSentByMe") == false) {
          // print(element.get("isSentByMe") == false);
          if (DateTime.parse(element.get("time").toDate().toString())
                  .compareTo(seenTime) >
              0) {
            unSeenMessagesList.add(element);
            // print(count++);
            print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ${unSeenMessagesList.length}");
          }
        } else if (element.get("isSentByMe") == true) {
          if (DateTime.parse(element.get("time").toDate().toString())
                  .compareTo(seenTime) >
              0) {
            firebaseInstance
                .doc(uid)
                .collection("privateChat")
                .doc(element.id)
                .update({
              "isSeen": false,
              "deliverTime": DateTime.now(),
              "status": "deliver"
            });
          }
        }
        // print("&&&&&&&&&&&&&&& ${element.id}");
        // return "${unSeenMessagesList.length}";

        // }
      });
    });

    countData = unSeenMessagesList;
  });

  unSeenMessagesList.clear();

  return countData;
  // print("%%%%%%%%%%%%${await count}");
  // firebaseInstance.doc(uid).collection("prviateChat").orderBy(field).snapshots().listen((event) {
  //   event.docs.forEach((element) {
  //     print(element.data());
  //   });
  // });
// unSeenMessagesList.forEach((val){
//   print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55 ${val.get('message')}");

// });
}

fetchContactsAndCheckStatus() {
  // ignore: avoid_function_literals_in_foreach_calls
  GlobalState.dataListen!.forEach((element) {
    // print(element.id);

    firebaseInstance
        .doc(element.id)
        .collection('privateChat')
        .snapshots()
        .listen((event) {
      // print(event.docs);

      event.docs.forEach((item) {
        if (item.get("status") == "sent") {
          // print(item);
          firebaseInstance
              .doc(element.id)
              .collection('privateChat')
              .doc(item.id)
              .update({
            "isSeen": false,
            "deliverTime": DateTime.now(),
            "status": "deliver"
          });
          // .update(
          //     {"isSeen": false, "deliverTime": DateTime.now(),"status":"deliver"});
        }
      });
    });
  });
  // FirebaseFirestore.instance.collection("chats").doc(GlobalState.myNumber).collection("personalChats").snapshots().listen((event) {
  //   print(event.docs);
  //    GlobalState.dataListen = event.docs;
  // });
}

// class {

// }
