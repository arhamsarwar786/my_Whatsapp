import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_whatsapp/Controller/GlobalState.dart';
import 'package:my_whatsapp/config/config.dart';
import 'package:my_whatsapp/screens/ChatScreen.dart';


class ChatsTab extends StatefulWidget {


  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> with WidgetsBindingObserver {



  @override
  void initState() {    
    super.initState();
            WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if (state == AppLifecycleState.resumed) {

      FirebaseFirestore.instance.collection("chats").doc(GlobalState.myNumber).update({"statusOnline":true,"lastSeen":DateTime.now()});
    
    }else{
      FirebaseFirestore.instance.collection("chats").doc(GlobalState.myNumber).update({"statusOnline":false});
      print("%%%%%%%%%%%%% OFF-ONLINE");
    }
        
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
       stream: FirebaseFirestore.instance.collection("chats").doc(GlobalState.myNumber).collection("personalChats")
      //  .orderBy('time', descending: true)
          .snapshots(),
      builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {


        if (snapshot.hasData){
          QuerySnapshot data = snapshot.data as QuerySnapshot;
        return  data.docs.isEmpty ? Center(child: Text("No Chats Found")):  ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: data.docs.length,
          separatorBuilder: (ctx, i) {
            return Divider();
          },
          itemBuilder: (ctx, i) {
            return ListTile(
              
              title: Text(data.docs[i].get("name"),style: TextStyle(fontWeight: FontWeight.bold), ),
              // subtitle: Text(chatListItems[i].lastMessage),
              // trailing: Text(chatListItems[i].date),
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(
                  "assets/blankProfile.webp"
                ),
              ),
              onTap: () {

                 FirebaseFirestore.instance.collection("chats").doc("${snapshot.data!.docs[i].get("number")}").collection("personalChats").doc(GlobalState.myNumber).update({
                    "isSeen":true,
                    "seenTime":DateTime.now()
                });
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      {"name":snapshot.data!.docs[i].get("name"),
                      "number":snapshot.data!.docs[i].get("number"),
                      "seenTime":snapshot.data!.docs[i].get("seenTime"),
                      "isSeen":snapshot.data!.docs[i].get("isSeen"),
                      }
                    ),
                  ),
                );
              },
            );
          },
        );
      
        }

        return Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ));
      }
    );
    
  }
}