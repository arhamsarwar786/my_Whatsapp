import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:my_whatsapp/config/config.dart';
import 'package:my_whatsapp/screens/all_contacts.dart';
import 'package:my_whatsapp/screens/register.dart';
import 'package:my_whatsapp/tabs/ChatsTab.dart';

import 'Controller/GlobalState.dart';


// import 'package:contacts_service/contacts_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();  
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Register(),
      theme: ThemeData(
        fontFamily: "PopinRegular",
        brightness: Brightness.light,
        primaryColor: primaryColor,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.grey,
        primaryColor: primaryColor,
      ),
    );
  }
}

class HomePage extends StatefulWidget  {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool status = false;

checkStatusOnline(){
    FirebaseFirestore.instance.collection("chats").doc(GlobalState.myNumber).snapshots().listen((event) {
      setState(() {
      status =  event.get("statusOnline");        
      });
    });    
  }


  @override
  void initState() {    
    super.initState();
    checkStatusOnline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(
         leading: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=> Register()));
            }, icon: Icon(Icons.arrow_back_sharp)),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "WhatsApp",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 10,
              width: 10,
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: status ? Colors.green :Colors.red),
            ),
          ],
        ),
        centerTitle: false,
        backgroundColor: primaryColor,      
        actions: [
          IconButton(
            onPressed: () {
              checkStatusOnline();
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ChatsTab(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.chat),
        onPressed: () async{
          Navigator.push(context, MaterialPageRoute(builder: (_)=> Contacts()));


        },
        backgroundColor: primaryColor,
      ),
    );
  }
}


// 3203192467
// 3218270128