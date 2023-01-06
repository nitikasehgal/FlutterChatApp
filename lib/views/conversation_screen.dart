import 'package:chatting_app/helper/constants.dart';
import 'package:chatting_app/services/database.dart';
import 'package:chatting_app/views/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ConversationScreen extends StatefulWidget {
  String chatroomid;
  ConversationScreen(this.chatroomid);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messagecontroller = TextEditingController();
  DatabaseMethods databaseMethods = DatabaseMethods();
  // Stream<QuerySnapshot>? chatmessagestream;
  Widget chatMessageList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .doc(widget.chatroomid)
            .collection('chats')
            .snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        snapshot.data!.docs[index]['message'],
                        snapshot.data!.docs[index]['SendBy'] ==
                            constants.myname);
                  });
        });
  }

  sendMessage() {
    if (messagecontroller.text.isNotEmpty) {
      Map<String, dynamic> messagemap = {
        "message": messagecontroller.text,
        "SendBy": constants.myname,
        'time': DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addconversationmessages(widget.chatroomid, messagemap);
      messagecontroller.text = "";
    }
  }

  @override
  void initState() {
    databaseMethods.getconversationmessages(widget.chatroomid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("${widget.chatroomid} chat Room")),
        body: Container(
            child: Stack(children: [
          chatMessageList(),
          Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messagecontroller,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        decoration: InputDecoration(
                            hintText: 'Message!',
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintStyle:
                                TextStyle(color: Colors.white54, fontSize: 18)),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: LinearGradient(colors: [
                                const Color(0x36FFFFFF),
                                const Color(0x0FFFFFFF)
                              ])),
                          padding: EdgeInsets.all(12),
                          child: Image.asset('assets/images/send.png')),
                    )
                  ],
                ),
              ))
        ])));
  }
}

class MessageTile extends StatefulWidget {
  final String message;
  final bool isSendByme;
  MessageTile(this.message, this.isSendByme);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: widget.isSendByme ? 0 : 24,
          right: widget.isSendByme ? 24 : 0),
      width: MediaQuery.of(context).size.width,
      alignment:
          widget.isSendByme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.isSendByme
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.isSendByme
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: widget.isSendByme
                  ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                  : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
            )),
        child: Text(
          widget.message,
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
