import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_whatsapp/Controller/GlobalState.dart';
import 'package:my_whatsapp/main.dart';




class Register extends StatelessWidget {  


  var number = TextEditingController();
  var name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             TextFormField(
            controller: name,
            decoration: InputDecoration(
              hintText: "Name",
              border: OutlineInputBorder()
            ),
          ),
            SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: number,
            decoration: InputDecoration(
              hintText: "+923xxxxxxxxxx",
              border: OutlineInputBorder(),
            ),
          ),
            SizedBox(
            height: 30,
          ),
          MaterialButton(onPressed: (){
            FirebaseFirestore.instance.collection("chats").doc(number.text).set({
              "name":"${name.text}",
              "number":"${number.text}",
              "statusOnline":true,
              "lastSeen": DateTime.now(),
            });

            GlobalState.myNumber = number.text;
            GlobalState.name = name.text;
            Navigator.push(context, MaterialPageRoute(builder: (_)=> HomePage() ));
          },child: Text("Register",style: TextStyle(color: Colors.white),), color: Colors.blueAccent,),
          SizedBox(
            height: 50,
          ),
          Text("+923xxxxxxxxxx Use this Format Now "),
        ],),
      ),
    );
  }
}