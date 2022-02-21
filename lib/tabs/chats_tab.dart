import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_whatsapp/Controller/global_methods.dart';
import 'package:my_whatsapp/Controller/global_state.dart';
import 'package:my_whatsapp/config/config.dart';
import 'package:my_whatsapp/provider/provider.dart';
import 'package:my_whatsapp/screens/chat_screen.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

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

  checkConnection() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      GlobalState.isConnectionEnable = true;
      if (GlobalState.dataListen == null) {
        fetchAllMessages();
      }
      // print(GlobalState.isConnectionEnable);
      // print(InternetConnectionChecker().connectionStatus);
    } else {
      GlobalState.isConnectionEnable = false;
      // print(GlobalState.isConnectionEnable);
      // print('No internet :( Reason:');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkConnection();
      FirebaseFirestore.instance
          .collection("chats")
          .doc(GlobalState.myNumber)
          .update({"statusOnline": true, "lastSeen": DateTime.now()});
    } else {
      checkConnection();
      FirebaseFirestore.instance
          .collection("chats")
          .doc(GlobalState.myNumber)
          .update({"statusOnline": false});
      print("%%%%%%%%%%%%% OFF-ONLINE");
    }

    super.didChangeAppLifecycleState(state);
  }
    var count = 0;
    var lastMessage;
    getLastSeenMessageAndCount(context,dataList){
      print("is UI part :   :   :     ${dataList}");
        // count = dataList.length;
      // setState(() {
      // });
    }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("chats")
            .doc(GlobalState.myNumber)
            .collection("personalChats")
            //  .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot data = snapshot.data as QuerySnapshot;
             
            return data.docs.isEmpty
                ? Center(child: Text("No Chats Found"))
                : ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data.docs.length,
                    separatorBuilder: (ctx, i) {
                      return Divider();
                    },
                    itemBuilder: (ctx, i) {
                      MyProvider provider = Provider.of(context, listen: false);
                      provider.fetchMessagesUser(data.docs[i].get("number"));
                      if (countData == null) {
                      //  getLastSeenMessageAndCount(context,getUnSeenMessages(snapshot.data!.docs[i].get("number")));                        
                      }
                      return Consumer<MyProvider>(
                            builder: (context,provider,child) {
                              return ListTile(
                            title: Text(
                              data.docs[i].get("name"),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            // subtitle: Text(provider.getUnSeenMessagesList.last),
                            // trailing: Text(chatListItems[i].date),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage("images/blankProfile.webp"),
                            ),
                            onTap: () {
                                provider.getUnSeenMessagesList.clear();
                              firebaseInstance.doc("${snapshot.data!.docs[i].get("number")}").update({
                                "seenTime":DateTime.now(),
                              });
                              FirebaseFirestore.instance
                                  .collection("chats")
                                  .doc("${snapshot.data!.docs[i].get("number")}")
                                  .collection("personalChats")
                                  .doc(GlobalState.myNumber)
                                  .update(
                                      {"isSeen": true, "seenTime": DateTime.now(),"status":"seen"});
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen({
                                    "name": snapshot.data!.docs[i].get("name"),
                                    "number": snapshot.data!.docs[i].get("number"),
                                    "seenTime":
                                        snapshot.data!.docs[i].get("seenTime"),
                                    "isSeen": snapshot.data!.docs[i].get("isSeen"),
                                  }),
                                ),
                              );
                            },
                            
                            trailing: Container(
                              child:  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                     Text(provider.getUnSeenMessagesList.length.toString(),style: TextStyle(fontSize: 10,color: Colors.green[400])),
                                      
                                      provider.getUnSeenMessagesList.length <= 0 ? Container(
                                        height: 0,
                                        width: 0,
                                      ): 
                                      Container(
                                        alignment: Alignment.center,
                                        height: 20,
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green[400],
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child:  Text(
                                          "${provider.getUnSeenMessagesList.length}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),));
                        }
                      );
                            
                          
                       
                    },
                  );
          }

          return Center(
              child: CircularProgressIndicator(
            color: primaryColor,
          ));
        });
  }
}
