import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:my_whatsapp/Controller/GlobalState.dart';
import 'package:my_whatsapp/config/config.dart';
import 'package:my_whatsapp/screens/ChatScreen.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:autocomplete_textfield/autocomplete_textfield.dart';

class Contacts extends StatefulWidget {
  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  void initState() {
    super.initState();
    fetchContacts();
  }

  List<Contact> contacts = [];

  fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts();
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      fetchDBUsers();
      // print(contacts);
    } else {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      fetchDBUsers();
    }

    setState(() {});
  }

  fetchDBUsers() {
    FirebaseFirestore.instance.collection('chats').snapshots().listen((event) {
      event.docs.forEach((element) {
        setState(() {
          dbSavedUsers.add(element.id);
        });
      });
    });
  }

  List dbSavedUsers = [];

  List searchresult = [];

  bool isSearch = false;

  var query = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      appBar: isSearch
          ? AppBar(
              leading: IconButton(
                  onPressed: () {
                    if (isSearch) {
                      setState(() {
                        isSearch = false;
                      });
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  )),
              backgroundColor: Colors.white,
              title: Container(
                color: Colors.white,
                child: TextField(
                  // onChanged: (searchText) {
                  //   // searchresult.clear();
                  //   if (searchText != null) {
                  //     for (var i = 0; i < contacts.length; i++) {
                  //       if (contacts[i].displayName.toLowerCase() ==
                  //           searchText.toLowerCase()) {
                  //         setState(() {
                  //           searchresult.add(contacts[i]);
                  //         });
                  //       }
                  //     }
                  //     print(searchresult);
                  //   }
                  // },
                  // controller: query,
                  decoration: InputDecoration.collapsed(
                    fillColor: Colors.white,
                    hintText: "Search...",
                  ),
                ),
              ),
            )
          : AppBar(
            
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Contact",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${contacts.length} contacts",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              centerTitle: false,
              backgroundColor: primaryColor,
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    setState(() {
                      isSearch = true;
                    });
                  },
                  icon: Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert),
                ),
              ],
            ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: contacts.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              ))
            :



            // isSearch ?

            // searchresult.isEmpty ?
            // Center(
            //   child: Text("No Contacts Found"),
            // )
            // :
            //  ListView.builder(
            //     itemCount: searchresult.isEmpty ? 0: searchresult.length,
            // shrinkWrap: true,
            //     itemBuilder: (context,i){
            //     return searchresult[i].phones.isEmpty  ? Container() :
            //     Container(
            //       // height: 50,
            //       child: ListTile(
            //         onTap: (){
            //           if(dbSavedUsers.contains(searchresult[i].phones[0].normalizedNumber)){
            //             Navigator.push(context, MaterialPageRoute(builder: (_)=>
            //             ChatScreen({"personName":searchresult[i].displayName,"profileURL":"assets/blankProfile.webp",})  ));
            //           }
            //         },
            //         leading: CircleAvatar(
            //           backgroundImage: AssetImage("assets/blankProfile.webp"),
            //         ),
            //         title: Text(searchresult[i].displayName,style: TextStyle(overflow: TextOverflow.ellipsis),),
            //         subtitle: Text(searchresult[i].phones[0].number.toString()),
            //         trailing: dbSavedUsers.contains(searchresult[i].phones[0].normalizedNumber) ?  Container():MaterialButton(
            //           minWidth: 30,
            //           onPressed: (){},child: Text("Invite",style: TextStyle(color: Colors.white),),color: primaryColor,),
            //       ),
            //     );
            //   })

            // :
            ListView.builder(
                itemCount: contacts.length,
                shrinkWrap: true,
                itemBuilder: (context, i) {
                  return contacts[i].phones.isEmpty
                      ? Container()
                      : Container(
                          // height: 50,
                          child: ListTile(
                            onTap: () {
                              if (dbSavedUsers.contains(
                                  contacts[i].phones[0].normalizedNumber)) {
                                    FirebaseFirestore.instance.collection("chats").doc("${contacts[i].phones[0].normalizedNumber}").collection("personalChats").doc("${contacts[i].phones[0].normalizedNumber}").set({
                                      "name": "${GlobalState.name}",
                                      "number":"${GlobalState.myNumber}",
                                      "seenTime":DateTime.now(),
                                      "isSeen": true,
                                    });
                                  
                                    FirebaseFirestore.instance.collection("chats").doc("${GlobalState.myNumber}").collection("personalChats").doc("${contacts[i].phones[0].normalizedNumber}").set({
                                      "name": "${contacts[i].displayName}",
                                      "number":"${contacts[i].phones[0].normalizedNumber}",
                                      "seenTime":null,
                                      "isSeen": false,
                                    });

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ChatScreen({
                                      "name": "${contacts[i].displayName}",
                                      "number":"${contacts[i].phones[0].normalizedNumber}",
                                      "seenTime":DateTime.now(),
                                      "isSeen": true,
                                    })));
                              }
                              
                            },
                            leading: CircleAvatar(
                              backgroundImage:
                                  AssetImage("images/blankProfile.webp"),
                            ),
                            title: Text(
                              contacts[i].displayName,
                              style: TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                            subtitle:
                                Text(contacts[i].phones[0].number.toString()),
                            trailing: dbSavedUsers.contains(
                                    contacts[i].phones[0].normalizedNumber)
                                ? Container()
                                : MaterialButton(
                                    minWidth: 30,
                                    onPressed: () {
                                      launchWhatsapp(contacts[i].phones[0].normalizedNumber,"Our Application is Under Development phase ignore this Message its just for test1");
                                    },
                                    child: Text(
                                      "Invite",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color: primaryColor,
                                  ),
                          ),
                        );
                }),
      ),
    );
  }

    launchWhatsapp(phone, message) async{
    String url(){
      if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/$phone/?text=${Uri.parse(message)}"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(message)}"; // new line
    }
    }



  if (await canLaunch(url())) {
    await launch(url());
  } else {
    throw 'Could not launch ${url()}';
  }
  }
}
