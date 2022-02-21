import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// import 'package:social_media_recorder/audio_encoder_type.dart';
// import 'package:social_media_recorder/screen/social_media_recorder.dart';
// import 'package:emoji_picker/emoji_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_whatsapp/Controller/global_methods.dart';
import 'package:my_whatsapp/Controller/global_state.dart';
import 'package:my_whatsapp/config/config.dart';
import 'package:my_whatsapp/main.dart';
import 'package:my_whatsapp/models/selected_messages.dart';
import 'info_message.dart';

class ChatScreen extends StatefulWidget {
  final Map info;

  // ignore: use_key_in_widget_constructors
  const ChatScreen(this.info);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Widget renderChatMessage(QueryDocumentSnapshot queryData, index) {
    return Dismissible(
      key: Key("$queryData"),
      dragStartBehavior: DragStartBehavior.start,
      confirmDismiss: (a) async {
        // print("^^^^^^^^^^^^^ $a");
        if (a == DismissDirection.startToEnd) {
          // print('Selected ${queryData.get('message')}');
          // print(queryData.id);
          selectedText = queryData.get('message');
          focusNode.requestFocus();
          setState(() {
            isSelectedtext = true;
          });
          // focusNode.
        }
      },
      onDismissed: (direction) {
        print(direction);
      },
      secondaryBackground: Container(color: Colors.red[100]),
      background: Container(color: Colors.transparent),
      child: Align(
        alignment: queryData.get('isSentByMe')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5,
          ),
          margin: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: queryData.get('isSentByMe') ? 2 : 7,
          ),
          decoration: BoxDecoration(
            color:
                queryData.get('isSentByMe') ? Color(0xFFDCF8C6) : Colors.white,
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
            // mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !queryData.get("isReplyMessage")
                  ? Container(
                      width: 0,
                    )
                  : Container(
                      // alignment: Alignment.centerLeft,
                      height: 50,
                      // color: Colors.red,
                      // width: MediaQuery.of(context).size.width,

                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                        ),
                        child: Container(
                          color: Colors.grey[100],
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 5,
                                decoration: BoxDecoration(
                                  color: Colors.green[400],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10)),
                                ),
                              ),
                              Container(
                                // width: MediaQuery.of(context).size.width - 76,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10)),
                                ),
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "you",
                                            style: TextStyle(
                                                color: Colors.green[400],
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        queryData.get("repliedMessage"),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.only(
                    left: 5, right: queryData.get('isSentByMe') ? 20 : 10),
                child: Text(
                  queryData.get('message'),
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                // alignment: Alignment.bottomRight,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('jm').format(queryData.get('time').toDate()),
                      style: TextStyle(fontSize: 10),
                    ),
                    queryData.get('isSentByMe')
                        ? Container(
                            height: 20,
                            // color: Colors.amber,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 15,
                                  color: (queryData.get("status") != 'sent') ||
                                          (queryData.get("status") == 'deliver')
                                      ? Colors.blue
                                      : Colors.grey,
                                ),
                                queryData.get("status") == 'deliver'
                                    ? Positioned(
                                        top: 3,
                                        child: Icon(
                                          Icons.check,
                                          size: 15,
                                          color: queryData.get("status") !=
                                                      'sent' ||
                                                  queryData.get("status") ==
                                                      'deliver'
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                      )
                                    : Container()
                                // Positioned(
                                //   top: 6,
                                //   child: Icon(
                                //     Icons.check,
                                //     size: 15,
                                //   ),
                                // ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isRecording = false;

  var selectedText = null;

  Widget renderTextBox(context) {
    return Align(
      alignment: Alignment.bottomCenter,
      // ignore: avoid_unnecessary_containers
      child: Container(
        // height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            !isSelectedtext
                ? Container()
                : Container(
                    alignment: Alignment.centerLeft,
                    height: 50,
                    // color: Colors.red,
                    width: MediaQuery.of(context).size.width,

                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: Container(
                        color: Colors.grey[100],
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 5,
                              decoration: BoxDecoration(
                                color: Colors.green[400],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 76,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "you",
                                          style: TextStyle(
                                              color: Colors.green[400],
                                              fontWeight: FontWeight.w500),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedText = null;
                                              isSelectedtext = false;
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            size: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "$selectedText",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 60,
                  child: Card(
                    margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: !isSelectedtext
                          ? BorderRadius.circular(25)
                          : BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25)),
                    ),
                    child: TextFormField(
                      controller: _controller,
                      autofocus: true,
                      focusNode: focusNode,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      minLines: 1,
                      onChanged: (value) {
                        if (value.length > 0) {
                          setState(() {
                            sendButton = true;
                          });
                        } else {
                          setState(() {
                            sendButton = false;
                          });
                        }
                      },
                      //  style: TextStyle(fontSize: 17.0, color: Colors.grey),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: IconButton(
                          icon: Icon(
                            show
                                ? Icons.keyboard
                                : Icons.emoji_emotions_outlined,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            if (!show) {
                              focusNode.unfocus();
                              focusNode.canRequestFocus = false;
                            }
                            setState(() {
                              show = !show;
                            });
                          },
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.attach_file,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (builder) => bottomSheet());
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (builder) =>
                                //             CameraApp()));
                              },
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.all(5),
                      ),
                    ),
                  ),
                ),

                ///  Send Message
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 8,
                    right: 2,
                    left: 2,
                  ),
                  child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Color(0xFF128C7E),
                      child: IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (sendButton) {
                            // selectedMessages!.add(
                            //               SelectedMessages<String>(
                            //                   "${data.docs[i].id}"));
                            FirebaseFirestore.instance
                                .collection("chats")
                                .doc(GlobalState.myNumber)
                                .collection("personalChats")
                                .doc(widget.info['number'])
                                .collection("privateChat")
                                .add({
                              "time": DateTime.now(),
                              "isSentByMe": true,
                              "message": _controller.text,
                              "status": "sent",
                              "sentTime": DateTime.now(),
                              "deliverTime": null,
                              "seenTime": null,
                              "isReplyMessage":
                                  selectedText != null ? true : false,
                              "repliedMessage": selectedText
                            });

                            ///  Person Contact
                            FirebaseFirestore.instance
                                .collection("chats")
                                .doc(widget.info["number"])
                                .collection("personalChats")
                                .doc(GlobalState.myNumber)
                                .collection("privateChat")
                                .add({
                              "time": DateTime.now(),
                              "isSentByMe": false,
                              "message": _controller.text,
                              "status": "sent",
                              "sentTime": DateTime.now(),
                              "deliverTime": null,
                              "seenTime": null,
                              "isReplyMessage":
                                  selectedText != null ? true : false,
                              "repliedMessage": selectedText,
                              // "number" : isSentByMe ? widget.info['number'] :GlobalState.myNumber,
                            });

                            _controller.clear();
                            selectedText = null;

                            setState(() {
                              isSelectedtext = false;
                            });
                          } else {
                            setState(() {
                              isRecording = true;
                            });
                          }

// 03203192467
                          // if (sendButton) {
                          //   _scrollController.animateTo(
                          //       _scrollController
                          //           .position.maxScrollExtent,
                          //       duration:
                          //           Duration(milliseconds: 300),
                          //       curve: Curves.easeOut);
                          //   sendMessage(
                          //       _controller.text,
                          //       widget.sourchat.id,
                          //       widget.chatModel.id);
                          //   _controller.clear();
                          //   setState(() {
                          //     sendButton = false;
                          //   });
                          // }
                        },
                      )
                      //                 : SocialMediaRecorder(
                      // // recordIcon: ,
                      //   recordIconBackGroundColor: Color(0xFF128C7E),
                      //   // recordIconWhenLockBackGroundColor: Colors.yellow,
                      //   // storeSoundRecoringPath: is,
                      //   backGroundColor: Colors.white,
                      //   sendRequestFunction: (soundFile) {
                      //       print("Click");
                      //     setState(() {
                      //       // isRecording = false;
                      //     });
                      //     //  # soundFile represent the sound you recording
                      //   },
                      //   encode: AudioEncoderType.AAC,
                      // ),

                      ),
                ),
              ],
            ),
            // show ? emojiSelect() : Container(),
          ],
        ),
      ),
    );
  }

  FocusNode focusNode = FocusNode();

  bool sendButton = false;
  bool show = false;
  TextEditingController _controller = TextEditingController();

  Widget bottomSheet() {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 278,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.camera_alt, Colors.pink, "Camera"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery"),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget emojiSelect() {
  //   return EmojiPicker(
  //       rows: 4,
  //       columns: 7,
  //       onEmojiSelected: (emoji, category) {
  //         print(emoji);
  //         setState(() {
  //           _controller.text = _controller.text + emoji.emoji;
  //         });
  //       });
  // }

//// Status Check;
  bool status = false;
  var lastSeen;

  checkStatusOnline() {
    FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.info['number'])
        .snapshots()
        .listen((event) {
      setState(() {
        status = event.get("statusOnline");
        lastSeen = event.get("lastSeen");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    selectedMessages = [];
    checkStatusOnline();

    // FirebaseFirestore.instance.collection("chats").doc(GlobalState.myNumber).update({"statusOnline":true,"lastSeen":DateTime.now()})
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  Widget iconCreation(IconData icons, Color color, String text) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icons,
              // semanticLabel: "Help",
              size: 29,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  dateFetch(date) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text("January 23, 2022"),
    );
  }

  /// POP UP Handler
  ///
  void handleClick(String value) {
    switch (value) {
      case 'info':
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => InfoMessage()));
        break;
    }
  }

  List<SelectedMessages<String>>? selectedMessages;

  bool isSelectedtext = false;
  bool isAnySelected = false;

  deleteMessage(BuildContext context, midList) {
    // set up the buttons
    Widget remindButton = TextButton(
      child: Text("Remind me later"),
      onPressed: () {},
    );
    Widget cancelButton = TextButton(
      child: Text(
        "CANCEL",
        style: TextStyle(color: primaryColor),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget launchButton = TextButton(
      child: Text(
        "DELETE FOR ME",
        style: TextStyle(color: primaryColor),
      ),
      onPressed: () {
        for (var mid in selectedMessages!) {
            // mid.isSelected = !mid.isSelected;
        
        if (mid.isSelected) 
          firebaseInstance
              .doc(widget.info['number'])
              .collection('privateChat')
              .doc(mid.data)
              .delete();
              
        }
        selectedMessages!.clear();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Message"),
      content: Text("Delete Message from ${widget.info['name']}?"),
      actions: [
        // remindButton,
        cancelButton,
        launchButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  List midList = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        FirebaseFirestore.instance
            .collection("chats")
            .doc("${widget.info["number"]}")
            .collection("personalChats")
            .doc(GlobalState.myNumber)
            .update({
          "isSeen": false,
        });
        if (show) {
          setState(() {
            show = false;
          });
        } else {
          Navigator.pop(context);
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFECE5DD),
        appBar: isAnySelected
            ? AppBar(
                backgroundColor: primaryColor,
                leading: IconButton(
                    onPressed: () {
                      setState(() {
                        selectedMessages!.clear();
                        isAnySelected = false;
                      });
                    },
                    icon: Icon(Icons.arrow_back_sharp)),

                // centerTitle: false,
                actions: [
                  IconButton(
                      onPressed: () {
                        deleteMessage(context, midList);
                      },
                      icon: Icon(Icons.delete)),
                ],
              )
            : AppBar(
                backgroundColor: primaryColor,
                leading: IconButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("chats")
                          .doc("${widget.info["number"]}")
                          .collection("personalChats")
                          .doc(GlobalState.myNumber)
                          .update({
                        "isSeen": false,
                      });
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => HomePage()));
                    },
                    icon: Icon(Icons.arrow_back_sharp)),
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage("images/blankProfile.webp"),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    FittedBox(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.info['name'],
                              overflow: TextOverflow.fade,
                              maxLines: 1,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10,
                                  width: 10,
                                  margin: EdgeInsets.only(
                                      right: 5, top: 5, bottom: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color:
                                          status ? Colors.green : Colors.red),
                                ),
                                Text(
                                  "${status ? 'Online' : '${lastSeen == null ? 'offline' : DateFormat('d MMM,').add_jm().format(lastSeen.toDate())}'}",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
                // centerTitle: false,
                actions: <Widget>[
                  PopupMenuButton(
                    onSelected: handleClick,
                    itemBuilder: (BuildContext context) {
                      return {'info'}.map((String choice) {
                        return PopupMenuItem(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
        //
        body: StreamBuilder(
            stream: firebaseInstance
                .doc(widget.info['number'])
                .collection("privateChat")
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot? data = snapshot.data;
                // print(
                //     "This is the Length : ${data!.docs.length} ${data.docs.isEmpty}");
                return  Column(
                        children: [
                          Flexible(
                            child: data!.docs.isEmpty
                    ? const Center(
                        child: Text("No Chat Found"),
                      )
                    : ListView.builder(
                                reverse: true,
                                // shrinkWrap: true,
                                itemCount: data.docs.length,
                                itemBuilder: (ctx, i) {
                                  if (selectedMessages!.isEmpty) {
                                    for (int i = 0; i < data.docs.length; i++) {
                                      selectedMessages!.add(
                                          SelectedMessages<String>(
                                              "${data.docs[i].id}"));
                                    }
                                  }
                                  return GestureDetector(
                                      onTap: () {
                                        if (selectedMessages!
                                            .any((item) => item.isSelected)) {
                                          setState(() {
                                            selectedMessages![i].isSelected =
                                                !selectedMessages![i]
                                                    .isSelected;
                                                
                                          });
                                        }
                                      },
                                      onLongPress: () {
                                        setState(() {
                                          selectedMessages![i].isSelected =
                                              true;
                                          isAnySelected = true;
                                       
                                          // midList.add(data.docs[i].id);
                                        });
                                      },
                                      
                                      child: Container(
                                        color: selectedMessages!.isEmpty ? Colors.transparent :  selectedMessages![i].isSelected
                                            ? Colors.blue[100]
                                            : Colors.transparent,
                                        child:
                                            renderChatMessage(data.docs[i], i),
                                      ));
                                }
                                // separatorBuilder:(context, index) => dateFetch(messages[index].date),
                                ),
                          ),
                          // Divider(),
                          Container(
                            child: renderTextBox(context),
                          ),
                        ],
                      );
              }

              return Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              ));
            }),
      ),
    );
  }
}
