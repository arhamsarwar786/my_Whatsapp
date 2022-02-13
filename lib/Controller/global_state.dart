

import 'package:cloud_firestore/cloud_firestore.dart';

class GlobalState{

  static String myNumber = '';
  static String name = '';


  static bool isConnectionEnable = false;


  static List<QueryDocumentSnapshot>? dataListen;

}


