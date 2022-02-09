import 'package:flutter/material.dart';

class InfoMessage extends StatefulWidget {
  @override
  State<InfoMessage> createState() => _InfoMessageState();
}

class _InfoMessageState extends State<InfoMessage> {


  @override
  void initState() {
    super.initState();

    getTimings();
  }


  getTimings(){

    
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFECE5DD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading:
            IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: Icon(Icons.arrow_back_rounded)),
        title: Text("Message Info"),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Align(
                alignment:
                    // queryData.get('isSentByMe')
                    Alignment.centerRight,
                // : Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical:
                        // queryData.get('isSentByMe') ? 2 :
                        7,
                  ),
                  decoration: BoxDecoration(
                    color:
                        // queryData.get('isSentByMe')
                        Color(0xFFDCF8C6),
                    // : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Color(0x22000000),
                        offset: Offset(1, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right:
                                //  queryData.get('isSentByMe') ?
                                60
                            //  : 50
                            ),
                        child: Text(
                          "Arham",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      Container(
                          // alignment: Alignment.bottomRight,
                          // child: Row(
                          //   // mainAxisAlignment: MainAxisAlignment.end,
                          //   mainAxisSize: MainAxisSize.min,
                          //   children: [
                          //     Text(
                          //       DateFormat('jm').format(queryData.get('time').toDate()),
                          //       style: TextStyle(fontSize: 10),
                          //     ),
                          //     queryData.get('isSentByMe')
                          //         ? Container(
                          //           height: 20,
                          //           // color: Colors.amber,
                          //           child: Stack(
                          //             alignment: Alignment.topCenter,
                          //             children: [
                          //               Icon(
                          //                   Icons.check,
                          //                   size: 15,
                          //                 ),
                          //                 // Positioned(
                          //                 //   top: 3,
                          //                 //   child: Icon(
                          //                 //     Icons.check,
                          //                 //     size: 15,
                          //                 //   ),
                          //                 // ),
                          //                 // Positioned(
                          //                 //   top: 6,
                          //                 //   child: Icon(
                          //                 //     Icons.check,
                          //                 //     size: 15,
                          //                 //   ),
                          //                 // ),
                          //             ],
                          //           ),
                          //         )
                          //         : Container(),
                          //   ],
                          // ),

                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              width: size.width,
              
              child: Column(
                children: [
                  Card(
                      child: ListTile(
                    leading: Stack(
                      children: [
                        Icon(
                          Icons.check,
                          size: 25,
                          color: Colors.blue,
                        ),
                        
                        Positioned(
                          top: 2,
                          left: 2,
                          child: Icon(
                            Icons.check,
                            color: Colors.blue,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    title: Text("READ",style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("january, 21-2022"),
                  )),
                  Card(
                      child: ListTile(
                    leading: Stack(
                      children: [
                        Icon(
                          Icons.check,
                          size: 25,
                          // color: Colors.blue,
                        ),
                        
                        Positioned(
                          top: 2,
                          left: 2,
                          child: Icon(
                            Icons.check,
                            // color: Colors.blue,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                    title: Text("Deliver",style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text("january, 21-2022"),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
