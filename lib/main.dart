import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:my_whatsapp/Controller/global_methods.dart';
import 'package:my_whatsapp/config/config.dart';
import 'package:my_whatsapp/provider/provider.dart';
import 'package:my_whatsapp/screens/all_contacts.dart';
import 'package:my_whatsapp/screens/register.dart';
import 'package:my_whatsapp/tabs/chats_tab.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'Controller/global_state.dart';


// import 'package:contacts_service/contacts_service.dart';




const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    // 'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();  
   MyProvider provider = MyProvider();
   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(App(provider));
}

class App extends StatelessWidget {
  final provider;
  App(this.provider);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProvider>(
      create: (_) => provider,
      child: Consumer<MyProvider>(
        builder: (context,provider,child) {
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

    if(GlobalState.dataListen == null){
      fetchAllMessages();
    }

     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                // channel.description!,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            });
      }
    });
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
              // checkStatusOnline();
  flutterLocalNotificationsPlugin.show(
        0,
        "Testing with Arham",
        "How you doin ?",
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/ic_launcher')));
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              // setState(() {
              // });
                
           fetchContactsAndCheckStatus();
            },
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